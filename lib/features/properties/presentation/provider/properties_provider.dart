import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hinvex/features/properties/data/i_properties_facade.dart';
import 'package:hinvex/features/user/data/model/user_model.dart';
import 'package:hinvex/features/user/data/model/user_product_details_model.dart';

class PropertiesProvider with ChangeNotifier {
  final IPropertiesFacade iPropertiesFacade;
  PropertiesProvider({required this.iPropertiesFacade}) {
    fetchProperties();
  }

  bool fetchPropertiesLoading = false;
  UserProductDetailsModel? selectedPropertiesDetails;
  bool fetchUserLoading = false;
  UserModel? userModel;
  bool fetchNextPopertiesLoading = false;
  bool fetchNextPopertiesCompleted = false;
  DocumentSnapshot? lastDocument;
  bool isLoading = false;

  // FETCH PROPERTIES

  List<UserProductDetailsModel> fetchPropertiesList = [];
  Future<void> fetchProperties() async {
    isLoading = true;
    fetchPropertiesLoading = true;
    notifyListeners();
    try {
      final result = await iPropertiesFacade.fetchProperties();
      fetchPropertiesList.clear();
      fetchPropertiesList.addAll(result.docs
          .map((doc) => UserProductDetailsModel.fromSnap(doc))
          .toList());
      lastDocument = result.docs.isNotEmpty ? result.docs.last : null;
      fetchPropertiesLoading = false;
      filteredPropertiesList.addAll(fetchPropertiesList);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching properties: $e');
      fetchPropertiesLoading = false;
      isLoading = false;
      notifyListeners();
    }
  }

  // Fetch next properties
  Future<void> fetchNextPoperties() async {
    if (fetchNextPopertiesLoading || fetchNextPopertiesCompleted) return;
    fetchNextPopertiesLoading = true;
    notifyListeners();
    try {
      final result = await iPropertiesFacade.fetchNextPoperties(lastDocument);
      fetchPropertiesList.clear();
      fetchPropertiesList.addAll(result!.docs
          .map((doc) => UserProductDetailsModel.fromSnap(doc))
          .toList());
      lastDocument = result.docs.isNotEmpty ? result.docs.last : null;
      fetchNextPopertiesLoading = false;
      if (fetchPropertiesList.isEmpty) fetchNextPopertiesCompleted = true;
      filteredPropertiesList.addAll(fetchPropertiesList);
      notifyListeners();
    } catch (e) {
      print('Error fetching next properties: $e');
      fetchNextPopertiesLoading = false;
      notifyListeners();
    }
  }
  // Future<void> fetchProperties() async {
  //   isLoading = true;
  //   notifyListeners();
  //   fetchPropertiesLoading = true;
  //   fetchPropertiesList.clear();
  //   final result = iPropertiesFacade.fetchProperties();
  //   result.listen((event) {
  //     final properties =
  //         event.docs.map((e) => UserProductDetailsModel.fromSnap(e)).toList();
  //     fetchPropertiesList.addAll(properties);
  //     lastDocument = event.docs.isNotEmpty ? event.docs.last : null;
  //     fetchNextPopertiesLoading = false;
  //     _filteredPropertiesList.addAll(fetchPropertiesList);
  //     isLoading = false;
  //     notifyListeners();
  //   });
  // }

  // Future<void> fetchNextPoperties() async {
  //   if (fetchNextPopertiesLoading || fetchNextPopertiesCompleted) return;
  //   notifyListeners();
  //   fetchNextPopertiesLoading = true;
  //   fetchPropertiesList.clear();
  //   final result = iPropertiesFacade.fetchNextPoperties(lastDocument);
  //   result.listen((event) {
  //     final properties =
  //         event.docs.map((e) => UserProductDetailsModel.fromSnap(e)).toList();
  //     fetchPropertiesList.addAll(properties);
  //     lastDocument = event.docs.isNotEmpty ? event.docs.last : null;
  //     fetchNextPopertiesLoading = false;
  //     if (properties.isEmpty) fetchNextPopertiesCompleted = true;
  //     _filteredPropertiesList.addAll(properties);

  //     notifyListeners();
  //   });
  // }

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
  // Future fetchUser({required String userId}) async {
  //   fetchUserLoading = true;
  //   // Set a default value for userModel before fetching the data

  //   final result = iPropertiesFacade.fetchUser(userId);
  //   result.listen((event) {
  //     if (event.docs.isNotEmpty) {
  //       // Update userModel with the fetched data
  //       userModel = UserModel.fromSnap(event.docs.first);
  //     } else {
  //       // Handle the case when no documents are found
  //       userModel = null; // or any default value you prefer
  //     }
  //     fetchUserLoading =
  //         false; // Set fetchUserLoading to false after receiving data
  //     notifyListeners();
  //   });
  // }

  // FILTER USER FOR SEARCH

  List<UserProductDetailsModel> _filteredPropertiesList = [];

  // Filter properties based on category and type
  void onSearchChanged(String query) {
    if (query.isEmpty) {
      // If the query is empty, reset the filtered list to the full list
      _filteredPropertiesList = List.from(fetchPropertiesList);
    } else {
      // If the query is not empty, filter the fetchPropertiesList based on the query
      _filteredPropertiesList = fetchPropertiesList.where((property) {
        // Check if the property's category or type contains the query
        return property.getSelectedCategoryString
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            property.getSelectedTypeString
                .toLowerCase()
                .contains(query.toLowerCase());
      }).toList();
    }
    // Notify listeners to update the UI with the filtered list
    notifyListeners();
  }

  // Getter for the filtered properties list
  List<UserProductDetailsModel> get filteredPropertiesList =>
      _filteredPropertiesList;
}
