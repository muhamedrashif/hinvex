import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hinvex/features/user/data/i_user_facade.dart';
import 'package:hinvex/features/user/data/model/user_model.dart';
import 'package:hinvex/features/user/data/model/user_product_details_model.dart';
import 'package:hinvex/general/utils/toast/toast.dart';

class UserProvider with ChangeNotifier {
  final IUserFacade iUserFacade;
  UserProvider({required this.iUserFacade});

  bool fetchUserLoding = false;
  UserModel? selectedUserDetails;
  bool fetchPostLoding = false;
  bool fetchReportLoading = false;
  final scrollController = ScrollController();
  List<UserModel> fetchUserList = [];

// FETCH USER DETAILS

  Future<void> fetchUser() async {
    log('called ');

    fetchUserLoding = true;
    notifyListeners();
    final result = await iUserFacade.fetchUser();
    result.fold(
      (l) {
        showToast(l.errorMsg);
        fetchUserLoding = false;
        notifyListeners();
      },
      (r) {
        fetchUserList.addAll(r);
        fetchUserLoding = false;
        notifyListeners();
      },
    );
  }

  void clearDoc() {
    iUserFacade.clearDoc();
  }

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
  }

  // DELETE POSTS

  Future deletePosts({
    required String id,
    required VoidCallback onSuccess,
    required VoidCallback onFailure,
  }) async {
    final result = await iUserFacade.deletePosts(id);
    result.fold((error) {
      showToast(error.errorMsg);
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

  // FILTER USER FOR SEARCH

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

  // BLOCK OR UNBLOCK SELECTED USER
  void toggleUserBlockStatus() {
    if (selectedUserDetails != null) {
      selectedUserDetails!.isBlocked = !selectedUserDetails!.isBlocked;
      notifyListeners();
      iUserFacade.updateUser(selectedUserDetails!);
    }
  }

  Future<void> init() async {
    if (fetchUserList.isEmpty) {
      iUserFacade.clearDoc();
      fetchUserList = [];
      await fetchUser();
    }

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent != 0 &&
          scrollController.position.atEdge &&
          fetchUserLoding == false) {
        fetchUser();
      }
    });
  }
}
