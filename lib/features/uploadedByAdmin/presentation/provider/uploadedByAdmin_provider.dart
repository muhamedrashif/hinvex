import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hinvex/features/uploadedByAdmin/data/i_uploadedByAdmin_facade.dart';
import 'package:hinvex/features/uploadedByAdmin/data/model/search_location_model/search_location_model.dart';
import 'package:hinvex/features/user/data/model/user_model.dart';
import 'package:hinvex/features/user/data/model/user_product_details_model.dart';
import 'package:hinvex/general/services/image_picker_service.dart';
import 'package:hinvex/general/services/video_picker_service.dart';
import 'package:hinvex/general/utils/progress_indicator_widget/progress_indicator_widget.dart';
import 'package:hinvex/general/utils/toast/toast.dart';

import '../../data/model/location_model_main.dart/location_model_main.dart';

class UploadedByAdminProvider with ChangeNotifier {
  final IUploadedByAdminFacade iUploadedByAdminFacade;
  UploadedByAdminProvider({required this.iUploadedByAdminFacade}) {
    // fetchProducts();
  }
  List<String> imageFile = [];
  bool sendLoading = false;
  bool fetchUploadedPropertiesLoading = false;
  // DocumentSnapshot? lastDocument;
  bool fetchNextUploadedPopertiesLoading = false;
  bool fetchNextUploadedPopertiesCompleted = false;
  bool fetchUserLoading = false;
  UserModel? userModel;
  UserProductDetailsModel? selectedPropertiesDetails;
  List<UserProductDetailsModel> filteredUploadedPropertiesList = [];

  bool updateLoading = false;
  List<PlaceResult> _suggestions = [];

  List<PlaceResult> get suggestions => _suggestions;

  bool isLoading = false;
  bool fetchPropertyLoading = false;
  final scrollController = ScrollController();
  String? videoPath;
  Set<String> propertyIds = {}; // Set to track unique property IDs

  // GET IMAGE

  Future<void> getImage({
    required VoidCallback onSuccess,
    required VoidCallback onFailure,
  }) async {
    final result = await pickMultipleImages(7 - imageFile.length);

    result.fold((l) {
      showToast(l.errorMsg);
      onFailure();
    }, (r) {
      if (r.isNotEmpty) {
        imageFile.addAll(r);
      }
      onSuccess();
      notifyListeners();
    });
    log("imageFile::::::::::::${imageFile.toString()}");
    log("imageFile length::::::::::::${imageFile.length}");
    notifyListeners();
  }

  // Method to remove image based on index
  void removeImageAtIndex(int index) async {
    // await deleteUrl(url: imageFile[index]);

    if (index >= 0 && index < imageFile.length) {
      imageFile.removeAt(index);

      notifyListeners();
    }
  }

  // STORE PROPERTY TO FIRESTORE

  Future<void> uploadPropertyToFireStore(
      {required UserProductDetailsModel userProductDetailsModel,
      required VoidCallback onSuccess,
      required VoidCallback onFailure}) async {
    sendLoading = true;
    notifyListeners();
    final result = await iUploadedByAdminFacade.uploadPropertyToFireStore(
      userProductDetailsModel: userProductDetailsModel,
      imageByte: imageFile,
    );
    result.fold((error) {
      onFailure();
      showToast(error.errorMsg);
    }, (success) {
      filteredUploadedPropertiesList.insert(0, success);
      sendLoading = false;
      notifyListeners();
      onSuccess.call();
    });
  }

  // SELECTED PROPERTY DETAILS

  propertyDetails({required UserProductDetailsModel userProductDetailsModel}) {
    selectedPropertiesDetails = userProductDetailsModel;
    imageFile = List<String>.from(userProductDetailsModel.propertyImage ?? []);
    videoPath = userProductDetailsModel.videoUrl!.isEmpty
        ? null
        : userProductDetailsModel.videoUrl;
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

// UPLOAD LOCATION

  Future<void> uploadLocation(PlaceCell place) async {
    final result = await iUploadedByAdminFacade.uploadLocation(place);

    result.fold((l) => null, (r) => null);
  }

// // FETCH PROPERTY

//   Future<void> fetchProducts() async {
//     log('called fetchProducts');

//     fetchPropertyLoading = true;
//     notifyListeners();
//     final result = await iUploadedByAdminFacade.fetchProduct();
//     result.fold(
//       (l) {
//         showToast(l.errorMsg);
//         fetchPropertyLoading = false;
//         notifyListeners();
//       },
//       (r) {
//         filteredUploadedPropertiesList.addAll(r);
//         fetchPropertyLoading = false;
//         notifyListeners();
//       },
//     );
//   }

//   // SEARCH PROPERTY

//   Future<void> searchProperty(String categoryName) async {
//     if (isLoading) return;
//     final result = await iUploadedByAdminFacade.searchProperty(categoryName);

//     result.fold(
//       (l) {
//         log(l.errorMsg);
//         isLoading = false;
//         notifyListeners();
//       },
//       (r) {
//         filteredUploadedPropertiesList.addAll(r);
//         isLoading = false;
//         notifyListeners();
//       },
//     );
//   }

  // FETCH PROPERTY
  Future<void> fetchProducts() async {
    log('called fetchProducts');

    fetchPropertyLoading = true;
    notifyListeners();
    final result = await iUploadedByAdminFacade.fetchProduct();
    result.fold(
      (l) {
        showToast(l.errorMsg);
        fetchPropertyLoading = false;
        notifyListeners();
      },
      (r) {
        // Filter out duplicates using propertyIds set
        final uniqueProperties = r.where((property) {
          if (propertyIds.contains(property.id)) {
            return false;
          } else {
            propertyIds.add(property.id!);
            return true;
          }
        }).toList();

        filteredUploadedPropertiesList.addAll(uniqueProperties);
        fetchPropertyLoading = false;
        notifyListeners();
      },
    );
  }

  // SEARCH PROPERTY
  Future<void> searchProperty(String categoryName) async {
    if (isLoading) return;
    clearPreviousResults(); // Clear previous results before new search
    final result = await iUploadedByAdminFacade.searchProperty(categoryName);

    result.fold(
      (l) {
        log(l.errorMsg);
        isLoading = false;
        notifyListeners();
      },
      (r) {
        // Filter out duplicates using propertyIds set
        final uniqueProperties = r.where((property) {
          if (propertyIds.contains(property.id)) {
            return false;
          } else {
            propertyIds.add(property.id!);
            return true;
          }
        }).toList();

        filteredUploadedPropertiesList.addAll(uniqueProperties);
        isLoading = false;
        notifyListeners();
      },
    );
  }

// DELETE PROPERTY

  Future deleteUploadedPosts({
    required String id,
    required VoidCallback onSuccess,
    required VoidCallback onFailure,
  }) async {
    final result = await iUploadedByAdminFacade.deleteUploadedPosts(id);
    result.fold((error) {
      onFailure();
      showToast(error.errorMsg);
    }, (success) {
      onSuccess.call();
    });
    notifyListeners();
  }
// UPDATE UPLOADED PROPERTY

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
      showToast(error.errorMsg);
    }, (success) {
      updateLoading = false;
      filteredUploadedPropertiesList[filteredUploadedPropertiesList.indexWhere(
              (element) => element.id == userProductDetailsModel.id)] =
          userProductDetailsModel;
      notifyListeners();
      onSuccess.call();
    });
  }

// REMOVE LOCALY FROM THE LIST
  void removeFromfilteredUploadedPropertiesList(String id) {
    filteredUploadedPropertiesList = filteredUploadedPropertiesList
        .where((element) => element.id != id)
        .toList();
    notifyListeners();
  }

// GET VIDEO

  Future<void> getVideo({required BuildContext context}) async {
    await pickVideo().then((value) {
      value.fold((failure) {
        log(failure.errorMsg);
      }, (videoPickedBytes) async {
        showProgress(context);
        notifyListeners();
        if (videoPickedBytes == null) {
          log('Calledddd');
          return;
        }
        if (videoPath != null) {
          log("videoPathhhhhhhhh:::::::$videoPath");
          await deleteVideo(videoPath: videoPath!).then((value) {
            videoPath = null;
          });
        }
        log("videoPickedBytes$videoPickedBytes");

        await saveVideo(videoBytes: videoPickedBytes).then((value) {
          value.fold((failure) {
            log(failure.errorMsg);
            Navigator.pop(context);
          }, (r) {
            log("videoPath2::::::::::::$r");
            videoPath = r;
            notifyListeners();
            Navigator.pop(context);
          });
        });
      });
    });
  }

// REMOVE VIDEO

  Future<void> removeVideo(
      {required String path,
      required bool isEditing,
      UserProductDetailsModel? userProductDetailsModel}) async {
    await deleteVideo(videoPath: path).then((value) async {
      if (isEditing) {
        log("message");
        await iUploadedByAdminFacade
            .deleteVideoFromFireStore(userProductDetailsModel);
        videoPath = null;
        notifyListeners();
      }
    });
    if (videoPath != null) {
      videoPath = null;
      notifyListeners();
    }
  }

// INITSTATE

  Future<void> init() async {
    if (filteredUploadedPropertiesList.isEmpty) {
      clearDoc();
      clearPreviousResults();
      await fetchProducts();
    }

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent != 0 &&
          scrollController.position.atEdge &&
          fetchPropertyLoading == false) {
        fetchProducts();
      }
    });
  }

  void clearSuggestions() {
    _suggestions.clear();
    notifyListeners();
  }

  // Clear previous search results before new search
  void clearPreviousResults() {
    filteredUploadedPropertiesList.clear();
    propertyIds.clear();
  }

  void clearDoc() {
    iUploadedByAdminFacade.clearDoc();
    filteredUploadedPropertiesList.clear();
    notifyListeners();
  }
}
