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

  bool noMoreData = false;
  QueryDocumentSnapshot<Map<String, dynamic>>? lastDoc;

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
          .add(userProductDetailsModel.copyWith(keywords: [
            ...keywords,
            ...keywordsBuilder(userProductDetailsModel.propertyTitle ?? ''),
            ...keywordsBuilder(
                userProductDetailsModel.getSelectedCategoryString),
          ]).toJson());
      return right(userProductDetailsModel.copyWith(id: response.id));
    } on CustomExeception catch (e) {
      return left(MainFailure.imageUploadFailure(errorMsg: e.errorMsg));
    }
  }

// FETCH USER

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> fetchUser(String userId) {
    final reuslt =
        _firestore.collection('users').where('userId', isEqualTo: userId).get();
    return reuslt;
  }

// UPLOAD LOCATION

  @override
  FutureResult<Unit> uploadLocation(PlaceCell place) {
    return _placeService.uploadPlace(place);
  }

  // FETCH PROPERTIES

  @override
  FutureResult<List<UserProductDetailsModel>> fetchProduct() async {
    log("FETCH PROPERTY CALLED");
    if (noMoreData == true) return right([]); //THERE IS NOMORE DATA
    try {
      final result = lastDoc == null
          ? await _firestore
              .collection('posts')
              .where('isAdmin', isEqualTo: true)
              .orderBy('createDate', descending: true)
              .limit(10)
              .get()
          : await _firestore
              .collection('posts')
              .where('isAdmin', isEqualTo: true)
              .orderBy('createDate', descending: true)
              .startAfterDocument(lastDoc!)
              .limit(10)
              .get();
      log("result  ${result.docs.length}");

      if (result.docs.length < 10 || result.docs.isEmpty) {
        noMoreData = true;
      } else {
        lastDoc = result.docs.last;
      }
      final propertyList =
          result.docs.map((e) => UserProductDetailsModel.fromSnap(e)).toList();
      return right(propertyList);
    } catch (e) {
      print(e.toString());
      return left(MainFailure.noDataFountFailure(errorMsg: e.toString()));
    }
  }

  @override
  void clearDoc() {
    lastDoc = null;
    noMoreData = false;
  }

// SEARCH PROPERTY
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

// LOCATION
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

// DELETE UPLOADED PROPERTY

  @override
  FutureResult<Unit> deleteUploadedPosts(String id) async {
    try {
      await _firestore.collection('posts').doc(id).delete();
      return right(unit);
    } on CustomExeception catch (e) {
      return left(MainFailure.serverFailure(errorMsg: e.errorMsg));
    }
  }
// UPDATE UPLOADED PROPERTY

  @override
  FutureResult<Unit> updateUploadedPosts(
      UserProductDetailsModel userProductDetailsModel) async {
    try {
      final builder = AlfabetKeywordsBuilder();
      builder.descriptionToKeywords(
          '${userProductDetailsModel.propertyTitle} ${userProductDetailsModel.description} ${userProductDetailsModel.propertyDetils}');
      final keywords = builder.build();
      await _firestore
          .collection('posts')
          .doc(userProductDetailsModel.id)
          .update(userProductDetailsModel.copyWith(keywords: [
            ...keywords,
            ...keywordsBuilder(
                userProductDetailsModel.getSelectedCategoryString),
            ...keywordsBuilder(userProductDetailsModel.propertyTitle ?? ''),
          ]).toJson());
      return right(unit);
    } on CustomExeception catch (e) {
      return left(MainFailure.serverFailure(errorMsg: e.errorMsg));
    }
  }
}
