// ignore_for_file: unused_field, prefer_final_fields

import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hinvex/features/banner/data/i_banner_facade.dart';
import 'package:hinvex/features/banner/data/model/banner_model.dart';
import 'package:hinvex/features/user/data/model/user_product_details_model.dart';
import 'package:hinvex/general/failures/failures.dart';
import 'package:hinvex/general/services/image_picker_service.dart';
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
  List<UserProductDetailsModel> _suggestions = [];

  List<UserProductDetailsModel> get suggestions => _suggestions;
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

        _suggestions.addAll(r);
        isLoading = false;
        notifyListeners();
      },
    );
  }

  void clearSuggestions() {
    _suggestions.clear();

    notifyListeners();
  }

  void clearDoc() {
    iBannerFacade.clearDoc();
  }

  Future<void> updateBannerId(
      {required String id, required String bannerId}) async {
    final result = await iBannerFacade.updateBannerId(id, bannerId);
    result.fold((error) {
      debugPrint(error.errorMsg);
    }, (success) {
      notifyListeners();
    });
  }
}
