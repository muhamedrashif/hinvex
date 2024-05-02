import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hinvex/features/uploadedByAdmin/data/i_uploadedByAdmin_facade.dart';
// import 'package:hinvex/features/uploadedByAdmin/data/model/location_model_main.dart/location_model_main.dart';
import 'package:hinvex/features/uploadedByAdmin/data/model/search_location_model/search_location_model.dart';
import 'package:hinvex/features/user/data/model/user_product_details_model.dart';
import 'package:hinvex/general/failures/exeception/execeptions.dart';
import 'package:hinvex/general/failures/failures.dart';
import 'package:hinvex/general/services/function_service.dart';
import 'package:hinvex/general/services/key_word_generate.dart';
import 'package:hinvex/general/services/upload_location_service.dart';
import 'package:hinvex/general/typedefs/typedefs.dart';
import 'package:injectable/injectable.dart';

import '../data/model/location_model_main.dart/location_model_main.dart';

@LazySingleton(as: IUploadedByAdminFacade)
class IUploadedByAdminImpl implements IUploadedByAdminFacade {
  IUploadedByAdminImpl(this._placeService, this._firestore);
  final FirebaseFirestore _firestore;
  final UploadPlaceService _placeService;

  // GET IMAGE

  QueryDocumentSnapshot<Map<String, dynamic>>? lastDoc;

  // @override
  // FutureResult<List<String?>> getImage({
  //   required List<Uint8List> imageByte,
  // }) async {
  //   try {
  //     List<Uint8List?> imageBytes = await pickMultipleImages(7);
  //     List<String?> imgUrl = [];
  //     if (imageByte.isNotEmpty) {
  //       imgUrl = await saveImages(imagePaths: imageByte);
  //     }
  //     return right(imgUrl);
  //   } catch (ex) {
  //     return left(MainFailure.imagePickFailed(errorMsg: ex.toString()));
  //   }
  // }

// UPLOAD TO FIRESTORE
  @override
  FutureResult<UserProductDetailsModel> uploadPropertyToFireStore({
    required UserProductDetailsModel userProductDetailsModel,
    required List<String> imageByte,
  }) async {
    final builder = AlfabetKeywordsBuilder();

    builder.descriptionToKeywords(
        '${userProductDetailsModel.propertyTitle} ${userProductDetailsModel.description} ${userProductDetailsModel.propertyDetils}');
    final keywords = builder.build();

    try {
      // List<String?> imgUrl = [];
      // if (imageByte.isNotEmpty) {
      //   imgUrl = await saveImages(imagePaths: imageByte);
      // }
      userProductDetailsModel.propertyImage = imageByte;
      final response = await _firestore
          .collection('posts')
          .add(userProductDetailsModel.copyWith(keywords: keywords).toJson());
      return right(userProductDetailsModel.copyWith(id: response.id));
    } on CustomExeception catch (e) {
      return left(MainFailure.imageUploadFailure(errorMsg: e.errorMsg));
    }
  }
  // FETCH PROPERTIES

  // @override
  // Stream<QuerySnapshot<UserProductDetailsModel>> fetchUploadedProperties() {
  //   log("message");
  //   final result = _firestore
  //       .collection('posts')
  //       .orderBy('createDate', descending: true)
  //       .where('userId', isEqualTo: "owner")
  //       .withConverter(
  //         fromFirestore: (snapshot, options) =>
  //             UserProductDetailsModel.fromSnap(snapshot),
  //         toFirestore: (value, options) => value.toJson(),
  //       )
  //       .limit(5)
  //       .snapshots();
  //   log("result.toString()");
  //   return result;
  // }

  // @override
  // Stream<QuerySnapshot<UserProductDetailsModel>> fetchNextUploadedProperties(
  //     DocumentSnapshot<Object?>? lastDocument) {
  //   if (lastDocument == null) {
  //     return const Stream.empty();
  //   }
  //   final result = _firestore
  //       .collection('posts')
  //       .orderBy('createDate', descending: true)
  //       .where('userId', isEqualTo: "owner")
  //       .withConverter(
  //         fromFirestore: (snapshot, options) =>
  //             UserProductDetailsModel.fromSnap(snapshot),
  //         toFirestore: (value, options) => value.toJson(),
  //       )
  //       .startAfterDocument(lastDocument)
  //       .limit(5)
  //       .snapshots();
  //   return result;
  // }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> fetchUser(String userId) {
    final reuslt =
        _firestore.collection('users').where('userId', isEqualTo: userId).get();
    return reuslt;
  }

  @override
  FutureResult<Unit> uploadLocation(PlaceCell place) {
    return _placeService.uploadPlace(place);
  }

  @override
  FutureResult<List<UserProductDetailsModel>> fetchProduct() async {
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
              .where('userId', isEqualTo: "owner")
              .limit(10)
              .get()
          : await _firestore
              .collection('posts')
              .orderBy('createDate', descending: true)
              .where('userId', isEqualTo: "owner")
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
      return left(MainFailure.noDataFountFailure(errorMsg: e.code));
    }
  }

  @override
  FutureResult<List<UserProductDetailsModel>> searchProperty(
      String categoryName) async {
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

  @override
  FutureResult<PlaceCell> serchLocationByAddres({
    required String latitude,
    required String longitude,
  }) async {
    final result = await LocationService.getLocation(
      latitude: latitude,
      longitude: longitude,
    );

    return result.fold(
      left,
      (r) {
        final placeCell = <String, dynamic>{};

        r.results?[0].addressComponents?.forEach((e) {
          final typeActions = {
            'postal_code': () => placeCell['pincode'] = e.longName ?? '',
            'administrative_area_level_1': () =>
                placeCell['state'] = e.longName ?? '',
            'administrative_area_level_3': () =>
                placeCell['district'] = e.longName ?? '',
            'locality': () => placeCell['localArea'] = e.longName ?? '',
            'country': () => placeCell['country'] = e.longName ?? '',
          };

          e.types?.forEach((type) {
            if (typeActions.containsKey(type)) {
              typeActions[type]!();
            }
          });
        });

        placeCell['geoPoint'] = LandMark(
          latitude: double.parse(latitude),
          longitude: double.parse(longitude),
        ).toMap();

        debugPrint(placeCell.toString());

        return right(PlaceCell.fromMap(placeCell));
      },
    );
  }

  // @override
  // FutureResult<List<PlaceResult>> pickLocationFromSearch(
  //   String searchText,
  // ) async {
  //   try {
  //     final res = await LocationService.searchPlaces(searchText.toLowerCase());
  //     log("SEARCH:::::::::::${res.toString()}");
  //     if (res != null) {
  //       return right(res);
  //     } else {
  //       return left(
  //         const MainFailure.serverFailure(errorMsg: 'No result found'),
  //       );
  //     }
  //   } catch (err) {
  //     return left(MainFailure.serverFailure(errorMsg: err.toString()));
  //   }
  // }

  @override
  FutureResult<List<PlaceResult>> pickLocationFromSearch(
    String searchText,
  ) async {
    try {
      const String apikey = 'AIzaSyAtdiojUpua_HUorIa1wiTQXVRTanYkF6E';

      final url =
          'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$searchText&key=$apikey';

      final res = await httpRequestViaServer(url);
      print("SEARCH:::::::::::${res.toString()}");
      return right(
          [...(res['results'] as List).map((e) => PlaceResult.fromJson(e))]);
    } catch (err) {
      return left(MainFailure.serverFailure(errorMsg: err.toString()));
    }
  }

  @override
  void clearDoc() {
    lastDoc = null;
  }

  @override
  FutureResult<Unit> deleteUploadedPosts(String id) async {
    try {
      await _firestore.collection('posts').doc(id).delete();
      return right(unit);
    } on CustomExeception catch (e) {
      return left(MainFailure.serverFailure(errorMsg: e.errorMsg));
    }
  }

  @override
  FutureResult<void> updateUploadedPosts(
      UserProductDetailsModel userProductDetailsModel) async {
    try {
      log("inside for update");
      debugPrint(
          "Updating post in Firestore with ID: ${userProductDetailsModel.id}");
      await _firestore
          .collection('posts')
          .doc(userProductDetailsModel.id)
          .update(userProductDetailsModel.toJson());
      return right(null);
    } on CustomExeception catch (e) {
      return left(MainFailure.serverFailure(errorMsg: e.errorMsg));
    }
  }
}
