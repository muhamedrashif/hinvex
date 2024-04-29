import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IPropertiesFacade {
  Future<QuerySnapshot<Map<String, dynamic>>> fetchProperties() {
    throw UnimplementedError('fetchProperties() not impl');
  }

  Future<QuerySnapshot<Map<String, dynamic>>?> fetchNextPoperties(
      DocumentSnapshot? lastDocument) {
    throw UnimplementedError('fetchNextPoperties() not impl');
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchUser(String userId) {
    throw UnimplementedError('fetchUser() not impl');
  }
}
