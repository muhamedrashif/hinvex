// ignore_for_file: unused_field, prefer_final_fields

import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hinvex/features/banner/data/i_banner_facade.dart';
import 'package:hinvex/features/banner/data/model/banner_model.dart';
import 'package:hinvex/features/user/data/model/user_product_details_model.dart';
import 'package:hinvex/general/failures/failures.dart';
import 'package:hinvex/general/services/image_picker_service.dart';
import 'package:hinvex/general/typedefs/typedefs.dart';
import 'package:uuid/uuid.dart';

class BannerProvider with ChangeNotifier {
  final IBannerFacade iBannerFacade;
  BannerProvider({required this.iBannerFacade});

  Uint8List? imageFile;
  String? imageUrl;
  BannerModel? bannerModel;
  bool _getImageloading = false;
  bool saveImageloading = false;
  bool _uploadImageloading = false;
  bool fetchwebBannerloading = false;
  bool fetchMobileBannerloading = false;
  bool isLoading = false;
  // List<UserProductDetailsModel> _fetchProductsList = [];

  // List<UserProductDetailsModel> get fetchProductsList => _fetchProductsList;
  List<UserProductDetailsModel> suggestions = [];

  // List<UserProductDetailsModel> get suggestions => suggestions;
  // GET IMAGE

  Future<void> getImage() async {
    Uint8List? imageBytes = await pickImage();
    if (imageBytes != null) {
      imageFile = imageBytes;
    }
    notifyListeners();
  }

  // SAVE IMAGE

  Future saveImage({
    required Uint8List imagePath,
    required VoidCallback onSuccess,
    required String status,
  }) async {
    // log(imageFile.toString());
    saveImageloading = true;
    notifyListeners();
    final result = await iBannerFacade.saveImages(imagePath: imageFile!);
    result.fold((error) {
      log(error.errorMsg);
      saveImageloading = false;
    }, (success) {
      log(success);
      bannerModel = BannerModel(
          image: success,
          timestamp: Timestamp.now(),
          postId: const Uuid().v1(),
          status: status);
      saveImageloading = false;
      uploadImageToFireStore(url: success, status: status);

      onSuccess.call();
    });
    notifyListeners();
  }

// CLEAR IMAGE
  void clearImage() {
    imageFile = null;
    imageUrl = null;

    notifyListeners();
  }
  // UPLOAD IMAGES TO FIRESTORE

  Future<void> uploadImageToFireStore(
      {required String url, required String status}) async {
    _uploadImageloading = true;

    String postId = const Uuid().v1();
    BannerModel bannerModel = BannerModel(
        postId: postId, image: url, timestamp: Timestamp.now(), status: status);
    final result = await iBannerFacade.uploadImagesToFireStore(bannerModel);
    result.fold((error) {
      log(error.errorMsg);
    }, (success) {
      log(success);
    });

    notifyListeners();
    _uploadImageloading = false;
  }

  // FETCH WEB BANNER

  List<BannerModel> webBannerList = [];
  bool bannerIsLoading = false;
  Future fetchWebBanners({required String status}) async {
    bannerIsLoading = true;
    notifyListeners();
    fetchwebBannerloading = true;
    log('called provider');

    final result = iBannerFacade.fetchWebBanners(status);
    result.listen((event) {
      webBannerList = [...event.docs.map((e) => e.data())];
      fetchwebBannerloading = false;
      bannerIsLoading = false;
      notifyListeners();
    });
  }

  // DELETE IMAGE

  Future deleteStorageImage({
    required String url,
    required String id,
    required VoidCallback onSuccess,
    required VoidCallback onFailure,
  }) async {
    final result = await iBannerFacade.deleteImages(imagePath: id);
    result.fold((error) {
      log(error.errorMsg);
    }, (success) async {
      await deleteImagesFromFireStore(url: id).then((value) {
        value.fold(
          (l) {},
          (r) {
            imageUrl = null;

            notifyListeners();
            onSuccess.call();
          },
        );
      });
    });
  }

  // DELETE IMAGE FROM FIRESTORE
  Future<Either<MainFailure, Unit>> deleteImagesFromFireStore({
    required String url,
  }) async {
    return iBannerFacade.deleteImagesFromFireStore(url);
  }

  // FETCH MOBILE BANNER

  List<BannerModel> mobileBannerList = [];
  bool mobileIsLoading = false;
  Future fetchMobileBanners({required String status}) async {
    mobileIsLoading = true;
    notifyListeners();
    fetchMobileBannerloading = true;

    final result = iBannerFacade.fetchMobileBanners(status);
    result.listen((event) {
      mobileBannerList = [...event.docs.map((e) => e.data())];
      mobileIsLoading = false;
      notifyListeners();
    });

    fetchMobileBannerloading = false;
  }

  // Future<void> fetchProducts() async {
  //   log('called fetchProducts');

  //   isLoading = true;

  //   notifyListeners();
  //   final result = await iBannerFacade.fetchProduct();

  //   result.fold(
  //     (l) {
  //       log(l.errorMsg);
  //       isLoading = false;
  //       notifyListeners();
  //     },
  //     (r) {
  //       log(r.length.toString());
  //       isLoading = false;
  //       log(r.first.toString());
  //       _fetchProductsList.addAll(r);
  //       notifyListeners();
  //     },
  //   );
  // }

  Future<void> searchProperty(String categoryName) async {
    final result =
        await iBannerFacade.searchProperty(categoryName.toLowerCase());

    result.fold(
      (l) {
        log(l.errorMsg);
        clearSuggestions();
        isLoading = false;
        notifyListeners();
      },
      (r) {
        log(r.length.toString());
        log(r.first.toString());
        clearSuggestions();
        suggestions.addAll(r);
        isLoading = false;
        notifyListeners();
      },
    );
  }

  void clearSuggestions() {
    suggestions.clear();

    notifyListeners();
  }

  void clearDoc() {
    iBannerFacade.clearDoc();
  }

  // Future<void> updatewebBannerId({
  //   required UserProductDetailsModel product,
  //   required String webBannerId,
  //   required VoidCallback onSuccess,
  //   required VoidCallback onFailure,
  // }) async {
  //   final int index =
  //       suggestions.indexWhere((element) => element.id == product.id);

  //   if (index != -1) {
  //     // Deselect all items with the same webBannerId
  //     if (webBannerId.isEmpty) {
  //       for (int i = 0; i < suggestions.length; i++) {
  //         if (suggestions[i].webBannerId == webBannerId) {
  //           final updatedProduct = suggestions[i].copyWith(webBannerId: '');
  //           suggestions[i] = updatedProduct;
  //         }
  //       }
  //     }

  //     // Update the banner ID for the current item
  //     final updatedProduct = product.copyWith(webBannerId: webBannerId);
  //     suggestions[index] = updatedProduct;

  //     // Call the API or perform other necessary operations
  //     final result = await iBannerFacade.updatewebBannerId(product.id!, webBannerId);
  //     result.fold(
  //       (error) {
  //         debugPrint(error.errorMsg);
  //         onFailure();
  //       },
  //       (success) {
  //         onSuccess();
  //       },
  //     );

  //     notifyListeners(); // Notify listeners about the change
  //   }
  // }

  Future<void> updatewebBannerId({
    required UserProductDetailsModel product,
    required String webBannerId,
    required VoidCallback onSuccess,
    required VoidCallback onFailure,
  }) async {
    final prIndex =
        suggestions.indexWhere((element) => element.webBannerId == webBannerId);

    if (product.webBannerId == webBannerId) {
      log('product.webBannerId == webBannerId');
      final result = await _updatewebBannerId(null, webBannerId);

      result.fold(
        (l) {
          onFailure();
        },
        (r) {
          suggestions[suggestions
                  .indexWhere((element) => product.id == element.id)] =
              product.copyWith(webBannerId: null);
          notifyListeners();
          onSuccess();

          log('webBannerId ${suggestions[0].webBannerId}');
        },
      );
    } else {
      log('product.webBannerId != webBannerId');
      if (prIndex != -1) {
        log('prIndex != -1');
        suggestions[prIndex] = suggestions[prIndex].copyWith(webBannerId: null);
        notifyListeners();
      }

      final result = await _updatewebBannerId(product.id, webBannerId);

      result.fold(
        (l) => onFailure(),
        (r) {
          suggestions[suggestions
                  .indexWhere((element) => product.id == element.id)] =
              product.copyWith(webBannerId: webBannerId);
          notifyListeners();
          onSuccess();
        },
      );
    }
  }

  FutureResult<void> _updatewebBannerId(
    String? productId,
    String webBannerId,
  ) {
    return iBannerFacade.updateWebBannerId(productId, webBannerId);
  }
}
