import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
// import 'package:hinvex/features/uploadedByAdmin/data/model/location_model_main.dart/location_model_main.dart';
import 'package:hinvex/features/uploadedByAdmin/data/model/search_location_model/search_location_model.dart';
import 'package:hinvex/features/user/data/model/user_product_details_model.dart';
import 'package:hinvex/general/typedefs/typedefs.dart';

import 'model/location_model_main.dart/location_model_main.dart';

abstract class IUploadedByAdminFacade {
  FutureResult<List<Uint8List?>> getImage() {
    throw UnimplementedError('getImage() not impl');
  }

  FutureResult<UserProductDetailsModel> uploadPropertyToFireStore({
    required UserProductDetailsModel userProductDetailsModel,
    required List<Uint8List> imageByte,
  }) {
    throw UnimplementedError('uploadPropertyToFireStore() not impl');
  }

  // Stream<QuerySnapshot<UserProductDetailsModel>> fetchUploadedProperties() {
  //   throw UnimplementedError('fetchProperties() not impl');
  // }

  // Stream<QuerySnapshot<UserProductDetailsModel>> fetchNextUploadedProperties(
  //   DocumentSnapshot? lastDocument,
  // ) {
  //   throw UnimplementedError('fetchNextUploadedProperties() not impl');
  // }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchUser(String userId) {
    throw UnimplementedError('fetchUser() not impl');
  }

  FutureResult<Unit> uploadLocation(PlaceCell place) {
    throw UnimplementedError();
  }

  FutureResult<List<UserProductDetailsModel>> fetchProduct() {
    throw UnimplementedError('fetchProduct is not implemented');
  }

  FutureResult<List<UserProductDetailsModel>> searchProperty(
      String categoryName) {
    throw UnimplementedError('fetchProduct is not implemented');
  }

  FutureResult<List<PlaceResult>> pickLocationFromSearch(
    String searchText,
  ) {
    throw UnimplementedError();
  }

  void clearDoc() {}

  FutureResult<PlaceCell> serchLocationByAddres({
    required String latitude,
    required String longitude,
  }) {
    throw UnimplementedError(
      'serchLocationByAddres() is not implemented, '
      'implement the method before calling it',
    );
  }

  FutureResult<Unit> deleteUploadedPosts(String id) {
    throw UnimplementedError('deleteUploadedPosts() not impl');
  }

  FutureResult<void> updateUploadedPosts(
      UserProductDetailsModel userProductDetailsModel) {
    throw UnimplementedError('updateUploadedPosts() not impl');
  }
}
