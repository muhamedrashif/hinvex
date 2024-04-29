import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:hinvex/features/user/data/model/user_model.dart';
import 'package:hinvex/general/typedefs/typedefs.dart';

abstract class IUserFacade {
  Stream<QuerySnapshot<Map<String, dynamic>>> fetchUser() {
    throw UnimplementedError('fetchUser() not impl');
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchNextUser(
      DocumentSnapshot? lastDocument) {
    throw UnimplementedError('fetchNextUser() not impl');
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchPosts(String userId) {
    throw UnimplementedError('fetchPosts() not impl');
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchReports(String userId) {
    throw UnimplementedError('fetchReports() not impl');
  }

  FutureResult<Unit> deletePosts(String id) {
    throw UnimplementedError('deletePosts() not impl');
  }

  // FutureResult<Unit> deleteReports(String id) {
  //   throw UnimplementedError('deleteReports() not impl');
  // }

  FutureResult<void> updateUser(UserModel userModel) {
    throw UnimplementedError('updateUser() not impl');
  }
}
