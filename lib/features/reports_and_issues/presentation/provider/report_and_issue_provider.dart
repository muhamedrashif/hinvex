import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hinvex/features/reports_and_issues/data/i_reports_and_issues_facade.dart';
import 'package:hinvex/features/user/data/model/user_model.dart';
import 'package:hinvex/features/user/data/model/user_product_details_model.dart';

class ReportsAndIssuesProvider with ChangeNotifier {
  final IReportsAndIssuesFacade iReportsAndIssuesFacade;
  ReportsAndIssuesProvider({required this.iReportsAndIssuesFacade});

  bool fetchReportsLoading = false;
  DocumentSnapshot? lastDocument;
  bool isLoading = false;
  bool fetchNextReportsLoading = false;
  bool fetchNextReportsCompleted = false;
  bool fetchUsertLoading = false;
  bool fetchUserReportstLoading = false;

// FETCH REPORTS

  List<UserProductDetailsModel> fetchReportList = [];

  Future<void> fetchReports(
      {required DateTime startDate, required DateTime endDate}) async {
    isLoading = true;
    fetchReportsLoading = true;
    notifyListeners(); // Move notifyListeners() here
    final result = await iReportsAndIssuesFacade.fetchReports(
      startDate: startDate,
      endDate: endDate,
    );
    final resultData =
        result.docs.map((e) => UserProductDetailsModel.fromSnap(e)).toList();
    fetchReportList.addAll(resultData);
    lastDocument = result.docs.isNotEmpty ? result.docs.last : null;
    fetchNextReportsLoading = false;
    _filteredReportsList.addAll(fetchReportList);
    isLoading = false;
    notifyListeners(); // Notify listeners after the asynchronous operation is completed
  }

  Future<void> fetchNextReports({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (fetchNextReportsLoading || fetchNextReportsCompleted) return;

    fetchNextReportsLoading = true;
    notifyListeners();

    final result = await iReportsAndIssuesFacade.fetchNextReports(
      startDate: startDate,
      endDate: endDate,
      lastDocument: lastDocument,
    );

    if (result == null) {
      return;
    }

    final newReports = result.docs
        .map((e) => UserProductDetailsModel.fromSnap(e))
        .where((newReport) => !fetchReportList
            .any((existingReport) => existingReport.id == newReport.id))
        .toList();

    fetchReportList.addAll(newReports);
    _filteredReportsList.addAll(newReports);

    lastDocument = result.docs.isNotEmpty ? result.docs.last : null;
    fetchNextReportsLoading = false;

    if (newReports.isEmpty) fetchNextReportsCompleted = true;

    notifyListeners();
  }

  void clearFetchReportList() {
    fetchReportList.clear();
    _filteredReportsList.clear();
  }

  // FILTER REPORTS FOR SEARCH

  List<UserProductDetailsModel> _filteredReportsList = [];

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      _filteredReportsList = List.from(fetchReportList);
    } else {
      _filteredReportsList = fetchReportList
          .where((reports) =>
              reports.getSelectedCategoryString
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              reports.getSelectedTypeString
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  List<UserProductDetailsModel> get filteredReportsList => _filteredReportsList;

  // FETCH REPORTS USER DETAILS
  List<UserModel> fetchUsertList = [];

  Future fetchUser({required String userId}) async {
    fetchUsertLoading = true;
    notifyListeners();
    final result = await iReportsAndIssuesFacade.fetchUser(userId);
    fetchUsertList = [...result.docs.map((e) => UserModel.fromSnap(e))];
    fetchUsertLoading = false;

    notifyListeners();

    // result.listen((event) {
    //   fetchUsertList = [...event.docs.map((e) => UserModel.fromSnap(e))];
    //   fetchUsertLoading = false;

    //   notifyListeners();
    // });
  }

  // DELETE REPORTS

  Future deleteReports(
      {required String id, required VoidCallback onSuccess}) async {
    final result = await iReportsAndIssuesFacade.deleteReports(id);
    result.fold((error) {
      log(error.errorMsg);
    }, (success) {
      onSuccess.call();
    });
    notifyListeners();
  }

  List<UserProductDetailsModel> fetchUserReportstList = [];
  Future fetchUserReports({required String userId}) async {
    fetchUserReportstLoading = true;
    notifyListeners();
    final result = await iReportsAndIssuesFacade.fetchUserReports(userId);
    fetchUserReportstList =
        result.docs.map((e) => UserProductDetailsModel.fromSnap(e)).toList();
    fetchUserReportstLoading = false;

    notifyListeners();
    // result.listen((event) {
    //   fetchUserReportstList = [
    //     ...event.docs.map((e) => UserProductDetailsModel.fromSnap(e))
    //   ];
    //   fetchUserReportstLoading = false;

    //   notifyListeners();
    // });
  }

  // BLOCK OR UNBLOCK SELECTED USER
  void toggleUserBlockStatus(String userId) {
    // Find the user in the list
    UserModel user = fetchUsertList.firstWhere((user) => user.userId == userId);
    // Toggle block status
    user.isBlocked = !user.isBlocked;
    // Update user status in the database
    iReportsAndIssuesFacade.updateUser(user);
    notifyListeners();
  }

  void clearData() {
    fetchReportList.clear();
    _filteredReportsList.clear();
    fetchUsertList.clear();
    fetchUserReportstList.clear();
  }
}
