import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hinvex/features/uploadedByAdmin/data/i_uploadedByAdmin_facade.dart';
import 'package:hinvex/features/uploadedByAdmin/data/model/search_location_model/search_location_model.dart';
import 'package:hinvex/features/user/data/model/user_model.dart';
import 'package:hinvex/features/user/data/model/user_product_details_model.dart';
import 'package:hinvex/general/services/image_picker_service.dart';

import '../../data/model/location_model_main.dart/location_model_main.dart';

class UploadedByAdminProvider with ChangeNotifier {
  final IUploadedByAdminFacade iUploadedByAdminFacade;
  UploadedByAdminProvider({required this.iUploadedByAdminFacade}) {
    // fetchProducts();
  }
  List<Uint8List> imageFile = [];
  bool sendLoading = false;
  bool fetchUploadedPropertiesLoading = false;
  DocumentSnapshot? lastDocument;
  bool fetchNextUploadedPopertiesLoading = false;
  bool fetchNextUploadedPopertiesCompleted = false;
  bool fetchUserLoading = false;
  UserModel? userModel;
  UserProductDetailsModel? selectedPropertiesDetails;
  List<UserProductDetailsModel> _filteredUploadedPropertiesList = [];

  List<UserProductDetailsModel> get filteredUploadedPropertiesList =>
      _filteredUploadedPropertiesList;
  bool updateLoading = false;
  List<PlaceResult> _suggestions = [];

  List<PlaceResult> get suggestions => _suggestions;

  // // FETCH PROPERTIES
  bool isLoading = false;
  // List<UserProductDetailsModel> fetchUploadedPropertiesList = [];

  // GET IMAGE

  Future<void> getImage() async {
    List<Uint8List> imageBytes = await pickMultipleImages(7);
    if (imageBytes.isNotEmpty) {
      imageFile.addAll(imageBytes);
    }
    log("imageFile::::::::::::${imageFile.toString()}");
    log("imageFile length::::::::::::${imageFile.length}");
    notifyListeners();
  }

  // Method to remove image based on index
  void removeImageAtIndex(int index) {
    if (index >= 0 && index < imageFile.length) {
      imageFile.removeAt(index);
      notifyListeners();
    }
  }

  // STORE PROPERTY TO FIRESTORE

  Future<void> uploadPropertyToFireStore({
    required UserProductDetailsModel userProductDetailsModel,
    required VoidCallback onSuccess,
  }) async {
    sendLoading = true;
    notifyListeners();
    final result = await iUploadedByAdminFacade.uploadPropertyToFireStore(
      userProductDetailsModel: userProductDetailsModel,
      imageByte: imageFile,
    );
    result.fold((error) {
      log(error.errorMsg);
    }, (success) {
      _filteredUploadedPropertiesList.insert(0, success);
      imageFile.clear();
      sendLoading = false;
      notifyListeners();
      onSuccess.call();
    });
  }

  // Future fetchUploadedProperties() async {
  //   isLoading = true;

  //   notifyListeners();
  //   fetchUploadedPropertiesLoading = true;
  //   final result = iUploadedByAdminFacade.fetchUploadedProperties();
  //   result.listen((event) {
  //     final uploadedProperties = event.docs.map((e) => e.data()).toList();
  //     fetchUploadedPropertiesList.addAll(uploadedProperties);
  //     lastDocument = event.docs.isNotEmpty ? event.docs.last : null;
  //     fetchNextUploadedPopertiesLoading = false;
  //     _filteredUploadedPropertiesList.addAll(fetchUploadedPropertiesList);
  //     isLoading = false;
  //     notifyListeners();
  //   });
  // }

  // Future<void> fetchNextUploadedProperties() async {
  //   if (fetchNextUploadedPopertiesLoading ||
  //       fetchNextUploadedPopertiesCompleted) return;
  //   fetchUploadedPropertiesList.clear();
  //   notifyListeners();
  //   fetchNextUploadedPopertiesLoading = true;
  //   final result =
  //       iUploadedByAdminFacade.fetchNextUploadedProperties(lastDocument);
  //   result.listen((event) {
  //     final uploadedProperties = event.docs.map((e) => e.data()).toList();
  //     fetchUploadedPropertiesList.addAll(uploadedProperties);
  //     lastDocument = event.docs.isNotEmpty ? event.docs.last : null;
  //     fetchNextUploadedPopertiesLoading = false;
  //     if (uploadedProperties.isEmpty) {
  //       fetchNextUploadedPopertiesCompleted = true;
  //     }
  //     _filteredUploadedPropertiesList.addAll(uploadedProperties);

  //     notifyListeners();
  //   });
  // }

  // FILTER PROPERTIES FOR SEARCH

  // void search(String query) {
  //   if (query.isEmpty) {
  //     _filteredUploadedPropertiesList.addAll(_filteredUploadedPropertiesList);
  //   } else {
  //     _filteredUploadedPropertiesList =
  //         _filteredUploadedPropertiesList.where((property) {
  //       return property.getSelectedCategoryString
  //               .toLowerCase()
  //               .contains(query.toLowerCase()) ||
  //           property.getSelectedTypeString
  //               .toLowerCase()
  //               .contains(query.toLowerCase());
  //     }).toList();
  //   }

  //   notifyListeners();
  // }

  // SELECTED PROPERTY DETAILS

  propertyDetails({required UserProductDetailsModel userProductDetailsModel}) {
    selectedPropertiesDetails = userProductDetailsModel;
    notifyListeners();
  }

  // SEARCH LOCATION

  Future<void> getLocations(String query) async {
    final reult = await iUploadedByAdminFacade.pickLocationFromSearch(query);
    reult.fold(
      (l) => null,
      (r) {
        _suggestions = r;
        notifyListeners();
      },
    );
  }

  Future<void> serchLocationByAddres({
    required String latitude,
    required String longitude,
    required Function(PlaceCell) onSuccess,
    required VoidCallback onFailure,
  }) async {
    final result = await iUploadedByAdminFacade.serchLocationByAddres(
        latitude: latitude, longitude: longitude);

    await result.fold(
      (l) {
        onFailure();
      },
      (r) async {
        log('serchLocationByAddres success');
        final result = await iUploadedByAdminFacade.uploadLocation(r);

        result.fold((l) {
          onFailure();
        }, (_) {
          onSuccess(r);
        });
      },
    );
  }

  // List<OpentreetMapModel> _locations = [];
  // List<OpentreetMapModel> _suggestions = [];

  // List<OpentreetMapModel> get locations => _locations;
  // List<OpentreetMapModel> get suggestions => _suggestions;

  // Future<void> getLocations(String query) async {
  //   log("inside");
  //   try {
  //     isGetLocationLoading = true;
  //     notifyListeners();
  //     final response = await Dio().get(
  //         "https://nominatim.openstreetmap.org/search.php?q=$query&format=json&addressdetails=1&limit=20&countrycodes=in");
  //     if (response.statusCode == 200) {
  //       log(response.statusCode.toString());
  //       final parsed = response.data.cast<Map<String, dynamic>>();
  //       log("parsed$parsed");
  //       _locations = parsed
  //           .map<OpentreetMapModel>((json) => OpentreetMapModel.fromMap(json))
  //           .toList();
  //       _suggestions = _locations
  //           .where(
  //               (location) => location.localArea!.toLowerCase().contains(query))
  //           .cast<OpentreetMapModel>()
  //           .toList();
  //       notifyListeners();
  //     } else {
  //       throw Exception('Failed to load area............');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to load area: $e');
  //   } finally {
  //     // Set loading to false regardless of success or failure
  //     isGetLocationLoading = false;
  //     notifyListeners();
  //   }
  // }

  void clearSuggestions() {
    _suggestions.clear();
    notifyListeners();
  }

  Future<void> uploadLocation(PlaceCell place) async {
    final result = await iUploadedByAdminFacade.uploadLocation(place);

    result.fold((l) => null, (r) => null);
  }

  Future<void> fetchProducts() async {
    log('called fetchProducts');

    isLoading = true;

    notifyListeners();
    final result = await iUploadedByAdminFacade.fetchProduct();

    result.fold(
      (l) {
        log(l.errorMsg);
        isLoading = false;
        notifyListeners();
      },
      (r) {
        log(r.length.toString());
        isLoading = false;
        log(r.first.toString());
        _filteredUploadedPropertiesList.addAll(r);
        notifyListeners();
      },
    );
  }

  Future<void> searchProperty(String categoryName) async {
    final result = await iUploadedByAdminFacade.searchProperty(categoryName);

    result.fold(
      (l) {
        log(l.errorMsg);
        isLoading = false;
        notifyListeners();
      },
      (r) {
        log(r.length.toString());
        isLoading = false;
        log(r.first.toString());
        _filteredUploadedPropertiesList.addAll(r);
        notifyListeners();
      },
    );
  }

  Future deleteUploadedPosts(
      {required String id, required VoidCallback onSuccess}) async {
    final result = await iUploadedByAdminFacade.deleteUploadedPosts(id);
    result.fold((error) {
      log(error.errorMsg);
    }, (success) {
      onSuccess.call();
    });
    notifyListeners();
  }

  Future<void> updateUploadedPosts({
    required UserProductDetailsModel userProductDetailsModel,
    required VoidCallback onSuccess,
    required VoidCallback onFailure,
  }) async {
    updateLoading = true;
    notifyListeners();
    final result = await iUploadedByAdminFacade
        .updateUploadedPosts(userProductDetailsModel);
    result.fold((error) {
      log(error.errorMsg);
    }, (success) {
      updateLoading = false;
      _filteredUploadedPropertiesList[
              _filteredUploadedPropertiesList.indexWhere(
                  (element) => element.id == userProductDetailsModel.id)] =
          userProductDetailsModel;
      notifyListeners();
      onSuccess.call();
    });
  }

  void clearDoc() {
    iUploadedByAdminFacade.clearDoc();
  }

  void deleteUploadedPost(String id) {
    _filteredUploadedPropertiesList = _filteredUploadedPropertiesList
        .where((element) => element.id != id)
        .toList();
  }

  void clearData() {
    _filteredUploadedPropertiesList.clear();
    notifyListeners();
  }
}
