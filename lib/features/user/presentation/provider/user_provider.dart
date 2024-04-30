import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hinvex/features/user/data/i_user_facade.dart';
import 'package:hinvex/features/user/data/model/user_model.dart';
import 'package:hinvex/features/user/data/model/user_product_details_model.dart';

class UserProvider with ChangeNotifier {
  final IUserFacade iUserFacade;
  UserProvider({required this.iUserFacade}) {
    // Fetch user data when the provider is initialized
    // fetchUser();
  }

  bool fetchUserLoding = false;
  UserModel? selectedUserDetails;
  bool fetchPostLoding = false;
  bool fetchReportLoading = false;

// FETCH USER DETAILS
  List<UserModel> fetchUserList = [];

  Future<void> fetchUser() async {
    log('called ');

    fetchUserLoding = true;

    notifyListeners();
    final result = await iUserFacade.fetchUser();

    result.fold(
      (l) {
        log(l.errorMsg);
        fetchUserLoding = false;
        notifyListeners();
      },
      (r) {
        log(r.length.toString());
        fetchUserLoding = false;
        log(r.first.toString());
        fetchUserList.addAll(r);
        notifyListeners();
      },
    );
  }

  void clearDoc() {
    iUserFacade.clearDoc();
  }
  // Future<void> fetchUser() async {
  //   isLoading = true;
  //   notifyListeners();
  //   fetchNextUserLoading = true;
  //   final result = iUserFacade.fetchUser();
  //   result.listen((event) {
  //     final users = event.docs.map((e) => UserModel.fromSnap(e)).toList();
  //     fetchUserList.addAll(users);
  //     lastDocument = event.docs.isNotEmpty ? event.docs.last : null;
  //     fetchNextUserLoading = false;
  //     // Populate _filteredUserList with the fetched data
  //     _filteredUserList.addAll(fetchUserList);
  //     isLoading = false;
  //     notifyListeners();
  //   });
  // }

  // Future<void> fetchNextUserBatch() async {
  //   if (fetchNextUserLoading || fetchNextUserCompleted) return;

  //   notifyListeners();
  //   fetchNextUserLoading = true;
  //   final result = iUserFacade.fetchNextUser(lastDocument);
  //   result.listen((event) {
  //     final users = event.docs.map((e) => UserModel.fromSnap(e)).toList();
  //     fetchUserList.addAll(users);
  //     lastDocument = event.docs.isNotEmpty ? event.docs.last : null;
  //     fetchNextUserLoading = false;
  //     if (users.isEmpty) fetchNextUserCompleted = true;

  //     // Update _filteredUserList with the fetched data
  //     _filteredUserList.addAll(users);

  //     notifyListeners();
  //   });
  // }

  // SET SELECTED USER DETAILS
  userDetails({required UserModel userModel}) {
    selectedUserDetails = userModel;
    notifyListeners();
  }
// FETCH USER POSTS DETAILS

  List<UserProductDetailsModel> fetchPostsList = [];

  Future fetchPosts({required String userId}) async {
    log("fetchPosts called");
    fetchPostLoding = true;
    final result = await iUserFacade.fetchPosts(userId);
    fetchPostsList = [
      ...result.docs.map((e) => UserProductDetailsModel.fromSnap(e))
    ];
    fetchPostLoding = true;
    notifyListeners();
    // result.listen((event) {
    //   fetchPostsList = [
    //     ...event.docs.map((e) => UserProductDetailsModel.fromSnap(e))
    //   ];
    // fetchPostLoding = true;
    //   notifyListeners();
    // });
  }

  // FETCH USER REPORTS DETAILS
  List<UserProductDetailsModel> fetchReportList = [];

  Future fetchRepors({required String userId}) async {
    log("fetchRepors called");
    fetchReportLoading = true;
    final result = await iUserFacade.fetchReports(userId);
    fetchReportList = [
      ...result.docs.map((e) => UserProductDetailsModel.fromSnap(e))
    ];
    fetchReportLoading = false;
    notifyListeners();
    // result.listen((event) {
    //   fetchReportList = [
    //     ...event.docs.map((e) => UserProductDetailsModel.fromSnap(e))
    //   ];
    //   fetchReportLoading = false;
    //   notifyListeners();
    // });
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

  // List<UserModel> filteredUserList = [];

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      fetchUserList = List.from(fetchUserList);
    } else {
      fetchUserList = fetchUserList
          .where((user) =>
              user.userName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    notifyListeners();
  }

  // // GET FILTERED USER LIST
  // List<UserModel> get filteredUserList => _filteredUserList;

  // BLOCK OR UNBLOCK SELECTED USER
  void toggleUserBlockStatus() {
    if (selectedUserDetails != null) {
      selectedUserDetails!.isBlocked = !selectedUserDetails!.isBlocked;
      notifyListeners();
      iUserFacade.updateUser(selectedUserDetails!);
    }
  }
}
