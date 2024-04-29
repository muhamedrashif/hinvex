import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:hinvex/features/banner/data/model/banner_model.dart';
import 'package:hinvex/features/user/data/model/user_product_details_model.dart';
import 'package:hinvex/general/typedefs/typedefs.dart';

abstract class IBannerFacade {
  FutureResult<Uint8List?> getImage() {
    throw UnimplementedError('getImage() not impl');
  }

  FutureResult<String> saveImages({required Uint8List imagePath}) {
    throw UnimplementedError('saveImage() not impl');
  }

  FutureResult<String> uploadImagesToFireStore(BannerModel bannerModel) {
    throw UnimplementedError('uploadImages() not impl');
  }

  Stream<QuerySnapshot<BannerModel>> fetchWebBanners(String status) {
    throw UnimplementedError('fetchWebBanners() not impl');
  }

  FutureResult<Unit> deleteImages({required String imagePath}) {
    throw UnimplementedError('deleteImages() not impl');
  }

  FutureResult<Unit> deleteImagesFromFireStore(String url) {
    throw UnimplementedError('deleteImagesFromFireStore() not impl');
  }

  Stream<QuerySnapshot<BannerModel>> fetchMobileBanners(String status) {
    throw UnimplementedError('fetchMobileBanners() not impl');
  }

  // FutureResult<List<UserProductDetailsModel>> fetchProduct() {
  //   throw UnimplementedError('fetchProduct is not implemented');
  // }

  FutureResult<List<UserProductDetailsModel>> searchProperty(
      String categoryName) {
    throw UnimplementedError('fetchProduct is not implemented');
  }

  FutureResult<void> updateBannerId(String id, String bannerId) {
    throw UnimplementedError('updateBannerId() not impl');
  }

  void clearDoc() {}
}
