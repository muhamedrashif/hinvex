import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hinvex/features/user/data/i_user_facade.dart';
import 'package:hinvex/features/user/data/model/user_model.dart';
import 'package:hinvex/features/user/data/model/user_product_details_model.dart';

class UserProvider with ChangeNotifier {
  final IUserFacade iUserFacade;
  UserProvider({required this.iUserFacade}) {
    // Fetch user data when the provider is initialized
    fetchUser();
  }

  bool fetchUserLoding = false;
  UserModel? selectedUserDetails;
  bool fetchPostLoding = false;
  bool fetchReportLoading = false;

// FETCH USER DETAILS
  List<UserModel> fetchUserList = [];
  bool fetchNextUserLoading = false;
  bool fetchNextUserCompleted = false;
  DocumentSnapshot? lastDocument;
  bool isLoading = false; // Flag to indicate whether data is being loaded
  Future<void> fetchUser() async {
    isLoading = true;
    notifyListeners();
    fetchNextUserLoading = true;
    final result = iUserFacade.fetchUser();
    result.listen((event) {
      final users = event.docs.map((e) => UserModel.fromSnap(e)).toList();
      fetchUserList.addAll(users);
      lastDocument = event.docs.isNotEmpty ? event.docs.last : null;
      fetchNextUserLoading = false;
      // Populate _filteredUserList with the fetched data
      _filteredUserList.addAll(fetchUserList);
      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> fetchNextUserBatch() async {
    if (fetchNextUserLoading || fetchNextUserCompleted) return;

    notifyListeners();
    fetchNextUserLoading = true;
    final result = iUserFacade.fetchNextUser(lastDocument);
    result.listen((event) {
      final users = event.docs.map((e) => UserModel.fromSnap(e)).toList();
      fetchUserList.addAll(users);
      lastDocument = event.docs.isNotEmpty ? event.docs.last : null;
      fetchNextUserLoading = false;
      if (users.isEmpty) fetchNextUserCompleted = true;

      // Update _filteredUserList with the fetched data
      _filteredUserList.addAll(users);

      notifyListeners();
    });
  }

  // SET SELECTED USER DETAILS
  userDetails({required UserModel userModel}) {
    selectedUserDetails = userModel;
    notifyListeners();
  }
// FETCH USER POSTS DETAILS

  List<UserProductDetailsModel> fetchPostsList = [];

  Future fetchPosts({required String userId}) async {
    fetchPostLoding = true;
    final result = iUserFacade.fetchPosts(userId);
    result.listen((event) {
      fetchPostsList = [
        ...event.docs.map((e) => UserProductDetailsModel.fromSnap(e))
      ];
      notifyListeners();
    });
    fetchPostLoding = true;
  }

  // FETCH USER REPORTS DETAILS
  List<UserProductDetailsModel> fetchReportList = [];

  Future fetchRepors({required String userId}) async {
    fetchReportLoading = true;
    final result = iUserFacade.fetchReports(userId);
    result.listen((event) {
      fetchReportList = [
        ...event.docs.map((e) => UserProductDetailsModel.fromSnap(e))
      ];
      notifyListeners();
    });
    fetchReportLoading = false;
  }

  // DELETE POSTS

  Future deletePosts(
      {required String id, required VoidCallback onSuccess}) async {
    final result = await iUserFacade.deletePosts(id);
    result.fold((error) {
      log(error.errorMsg);
    }, (success) async {
      if (selectedUserDetails != null) {
        selectedUserDetails!.totalPosts -= 1;
        notifyListeners();
        await iUserFacade.updateUser(selectedUserDetails!);
      }
      onSuccess.call();
    });
    notifyListeners();
  }

  // DELETE REPORTS

  // Future deleteReports(
  //     {required String id, required VoidCallback onSuccess}) async {
  //   final result = await iUserFacade.deleteReports(id);
  //   result.fold((error) {
  //     log(error.errorMsg);
  //   }, (success) {
  //     onSuccess.call();
  //   });
  //   notifyListeners();
  // }

  // FILTER USER FOR SEARCH

  List<UserModel> _filteredUserList = [];

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      _filteredUserList = List.from(fetchUserList);
    } else {
      _filteredUserList = fetchUserList
          .where((user) =>
              user.userName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    notifyListeners();
  }

  // GET FILTERED USER LIST
  List<UserModel> get filteredUserList => _filteredUserList;

  // BLOCK OR UNBLOCK SELECTED USER
  void toggleUserBlockStatus() {
    if (selectedUserDetails != null) {
      selectedUserDetails!.isBlocked = !selectedUserDetails!.isBlocked;
      notifyListeners();
      iUserFacade.updateUser(selectedUserDetails!);
    }
  }
}
