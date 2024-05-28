import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hinvex/features/user/data/model/user_product_details_model.dart';
import 'package:hinvex/general/typedefs/typedefs.dart';

abstract class IPropertiesFacade {
  FutureResult<List<UserProductDetailsModel>> fetchProperties() {
    throw UnimplementedError('fetchProperties() not impl');
  }

  void clearDoc() {}

  Future<QuerySnapshot<Map<String, dynamic>>> fetchUser(String userId) {
    throw UnimplementedError('fetchUser() not impl');
  }

  FutureResult<List<UserProductDetailsModel>> searchProperty(
      String categoryName) {
    throw UnimplementedError('fetchProduct is not implemented');
  }
}
