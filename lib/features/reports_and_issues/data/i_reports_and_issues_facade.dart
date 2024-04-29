import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:hinvex/features/user/data/model/user_model.dart';
import 'package:hinvex/general/typedefs/typedefs.dart';

abstract class IReportsAndIssuesFacade {
  Future<QuerySnapshot<Map<String, dynamic>>> fetchReports(
      {DateTime? startDate, DateTime? endDate}) {
    throw UnimplementedError('fetchReports() not impl');
  }

  Future<QuerySnapshot<Map<String, dynamic>>?> fetchNextReports(
      {DateTime? startDate,
      DateTime? endDate,
      DocumentSnapshot? lastDocument}) {
    throw UnimplementedError('fetchNextReports() not impl');
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchUser(String userId) {
    throw UnimplementedError('fetchUser() not impl');
  }

  FutureResult<Unit> deleteReports(String id) {
    throw UnimplementedError('deleteReports() not impl');
  }

  FutureResult<void> updateUser(UserModel userModel) {
    throw UnimplementedError('updateUser() not impl');
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchUserReports(String userId) {
    throw UnimplementedError('fetchUserReports() not impl');
  }
}
