import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hinvex/features/banner/data/i_banner_facade.dart';
import 'package:hinvex/features/banner/data/model/banner_model.dart';
import 'package:hinvex/features/user/data/model/user_product_details_model.dart';
import 'package:hinvex/general/failures/exeception/execeptions.dart';
import 'package:hinvex/general/failures/failures.dart';
import 'package:hinvex/general/services/image_picker_service.dart';
import 'package:hinvex/general/typedefs/typedefs.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IBannerFacade)
class IBannerImpl implements IBannerFacade {
  IBannerImpl(this._firestore);
  final FirebaseFirestore _firestore;

  QueryDocumentSnapshot<Map<String, dynamic>>? lastDoc;

  // GET IMAGE

  @override
  FutureResult<Uint8List?> getImage() async {
    try {
      Uint8List? imageBytes = await pickImage();
      return right(imageBytes);
    } catch (ex) {
      return left(MainFailure.imagePickFailed(errorMsg: ex.toString()));
    }
  }

// SAVE IMAGE
  @override
  FutureResult<String> saveImages({required Uint8List imagePath}) async {
    try {
      String url = await saveImage(imagePath: imagePath);
      return right(url);
    } on CustomExeception catch (e) {
      return left(MainFailure.imageUploadFailure(errorMsg: e.errorMsg));
    }
  }

  // UPLOAD IMAGE TO FIRESTORE
  @override
  FutureResult<String> uploadImagesToFireStore(BannerModel bannerModel) async {
    try {
      final response =
          await _firestore.collection('banners').add(bannerModel.toJson());
      return right(response.id);
    } on CustomExeception catch (e) {
      return left(MainFailure.imageUploadFailure(errorMsg: e.errorMsg));
    }
  }

  // FETCH WEB BANNERS
  @override
  Stream<QuerySnapshot<BannerModel>> fetchWebBanners(String status) {
    log('called impl');
    final result = _firestore
        .collection('banners')
        .orderBy('timestamp', descending: true)
        .where('status', isEqualTo: status)
        .withConverter(
          fromFirestore: (snapshot, options) => BannerModel.fromSnap(snapshot),
          toFirestore: (value, options) => value.toJson(),
        )
        .snapshots();
    return result;
  }

  // DELETE IMAGE
  @override
  FutureResult<Unit> deleteImages({required String imagePath}) async {
    try {
      log('called');
      // await deleteUrl(url: imagePath);
      return right(unit);
    } on CustomExeception catch (e) {
      return left(MainFailure.serverFailure(errorMsg: e.errorMsg));
    }
  }
  // DELETE IMAGE FROM FIRESTORE

  @override
  FutureResult<Unit> deleteImagesFromFireStore(String id) async {
    try {
      await _firestore.collection('banners').doc(id).delete();
      return right(unit);
    } on CustomExeception catch (e) {
      return left(MainFailure.serverFailure(errorMsg: e.errorMsg));
    }
  }

  // FETCH MOBILE BANNERS
  @override
  Stream<QuerySnapshot<BannerModel>> fetchMobileBanners(String status) {
    final result = _firestore
        .collection('banners')
        .orderBy('timestamp', descending: true)
        .where('status', isEqualTo: status)
        .withConverter(
          fromFirestore: (snapshot, options) => BannerModel.fromSnap(snapshot),
          toFirestore: (value, options) => value.toJson(),
        )
        .snapshots();
    return result;
  }

  // @override
  // FutureResult<List<UserProductDetailsModel>> fetchProduct() async {
  //   log('fetchProduct impl');
  //   try {
  //     if (lastDoc == null) {
  //       log('lastdoc null');
  //     } else {
  //       log('lastdoc');
  //     }
  //     final result = lastDoc == null
  //         ? await _firestore
  //             .collection('posts')
  //             .orderBy('createDate', descending: true)
  //             .where('userId', isEqualTo: "owner")
  //             .limit(10)
  //             .get()
  //         : await _firestore
  //             .collection('posts')
  //             .orderBy('createDate', descending: true)
  //             .where('userId', isEqualTo: "owner")
  //             .startAfterDocument(lastDoc!)
  //             .limit(10)
  //             .get();

  //     if (result.docs.isNotEmpty) {
  //       lastDoc = result.docs.last;
  //       return right(
  //         [
  //           ...result.docs.map(
  //             (e) => UserProductDetailsModel.fromSnap(e),
  //           ),
  //         ],
  //       );
  //     }

  //     return left(
  //         const MainFailure.noDataFountFailure(errorMsg: 'No Data Fount'));
  //   } on FirebaseException catch (e) {
  //     debugPrint(e.toString());
  //     return left(MainFailure.noDataFountFailure(errorMsg: e.code));
  //   }
  // }

  @override
  FutureResult<List<UserProductDetailsModel>> searchProperty(
      String categoryName) async {
    log('searchProperty impl');
    try {
      if (lastDoc == null) {
        log('lastdoc null');
      } else {
        log('lastdoc');
      }
      final result = lastDoc == null
          ? await _firestore
              .collection('posts')
              .orderBy('createDate', descending: true)
              .where(
                Filter.and(
                    Filter('userId', isEqualTo: "owner"),
                    Filter.or(
                      Filter('propertyCategory', isEqualTo: categoryName),
                      Filter(
                        'keywords',
                        arrayContains: categoryName,
                      ),
                    )),
              )
              .limit(10)
              .get()
          : await _firestore
              .collection('posts')
              .orderBy('createDate', descending: true)
              .where(
                Filter.and(
                  Filter('userId', isEqualTo: "owner"),
                  Filter('propertyCategory', isEqualTo: categoryName),
                  Filter(
                    'keywords',
                    arrayContains: categoryName,
                  ),
                ),
              )
              .startAfterDocument(lastDoc!)
              .limit(10)
              .get();

      if (result.docs.isNotEmpty) {
        lastDoc = result.docs.last;
        return right(
          [
            ...result.docs.map(
              (e) => UserProductDetailsModel.fromSnap(e),
            ),
          ],
        );
      }

      return left(
          const MainFailure.noDataFountFailure(errorMsg: 'No Data Fount'));
    } on FirebaseException catch (e) {
      debugPrint(e.message);
      return left(MainFailure.noDataFountFailure(errorMsg: e.code));
    }
  }

  void clearDoc() {
    lastDoc = null;
  }

  @override
  FutureResult<void> updateBannerId(String id, String bannerId) async {
    try {
      await _firestore.collection('posts').doc(id).update({
        'bannerId': bannerId,
      });
      return right(null);
    } on CustomExeception catch (e) {
      return left(MainFailure.serverFailure(errorMsg: e.errorMsg));
    }
  }
}
