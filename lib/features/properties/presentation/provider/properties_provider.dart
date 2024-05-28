import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hinvex/features/properties/data/i_properties_facade.dart';
import 'package:hinvex/features/user/data/model/user_model.dart';
import 'package:hinvex/features/user/data/model/user_product_details_model.dart';
import 'package:hinvex/general/utils/toast/toast.dart';

class PropertiesProvider with ChangeNotifier {
  final IPropertiesFacade iPropertiesFacade;
  PropertiesProvider({required this.iPropertiesFacade});

  bool fetchPropertiesLoading = false;
  UserProductDetailsModel? selectedPropertiesDetails;
  bool fetchUserLoading = false;
  UserModel? userModel;
  bool searchLoading = false;

  List<UserProductDetailsModel> fetchPropertiesList = [];
  final scrollController = ScrollController();

  // FETCH PROPERTIES
  Future<void> fetchProducts() async {
    fetchPropertiesLoading = true;
    notifyListeners();
    final result = await iPropertiesFacade.fetchProperties();
    result.fold(
      (error) {
        showToast(error.errorMsg);
        fetchPropertiesLoading = false;
        notifyListeners();
      },
      (success) {
        fetchPropertiesList.addAll(success);
        fetchPropertiesLoading = false;
        notifyListeners();
      },
    );
  }

  // SELECTED PROPERTY DETAILS

  propertyDetails({required UserProductDetailsModel userProductDetailsModel}) {
    selectedPropertiesDetails = userProductDetailsModel;
    notifyListeners();
  }

  // FETCH USER DETAILS
  Future<void> fetchUser({required String userId}) async {
    fetchUserLoading = true;
    notifyListeners();
    try {
      final result = await iPropertiesFacade.fetchUser(userId);
      if (result.docs.isNotEmpty) {
        userModel = UserModel.fromSnap(result.docs.first);
      } else {
        userModel = null;
      }
      fetchUserLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching user: $e');
      fetchUserLoading = false;
      notifyListeners();
    }
  }

  // SEARCH PROPERTY

  Future<void> searchProperty(String categoryName) async {
    final result = await iPropertiesFacade.searchProperty(categoryName);

    result.fold(
      (l) {
        log(l.errorMsg);
        // showToast(l.errorMsg);
        searchLoading = false;
        notifyListeners();
      },
      (r) {
        log(r.length.toString());
        searchLoading = false;
        log(r.first.toString());
        fetchPropertiesList.addAll(r);
        notifyListeners();
      },
    );
  }

  void clearDoc() {
    iPropertiesFacade.clearDoc();
  }

  Future<void> init() async {
    if (fetchPropertiesList.isEmpty) {
      iPropertiesFacade.clearDoc();
      fetchPropertiesList = [];
      await fetchProducts();
    }

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent != 0 &&
          scrollController.position.atEdge &&
          fetchPropertiesLoading == false) {
        fetchProducts();
      }
    });
  }
}
