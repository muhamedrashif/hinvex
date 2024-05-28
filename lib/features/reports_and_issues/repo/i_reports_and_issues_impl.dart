import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hinvex/features/reports_and_issues/data/i_reports_and_issues_facade.dart';
import 'package:hinvex/features/user/data/model/user_model.dart';
import 'package:hinvex/general/failures/exeception/execeptions.dart';
import 'package:hinvex/general/failures/failures.dart';
import 'package:hinvex/general/typedefs/typedefs.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IReportsAndIssuesFacade)
class IReportsAndIssuesImpl implements IReportsAndIssuesFacade {
  IReportsAndIssuesImpl(this._firestore);
  final FirebaseFirestore _firestore;

  // FETCH REPORTS

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> fetchReports({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      if (startDate == null || endDate == null) {
        throw ArgumentError('Start date and end date cannot be null');
      }

      if (startDate.isAfter(endDate)) {
        throw ArgumentError('Start date cannot be after end date');
      }

      final result = await _firestore
          .collection('posts')
          .orderBy('createDate', descending: true)
          .orderBy('noOfReports')
          .where(
            Filter.and(
              Filter('userId', isNotEqualTo: 'owner'),
              Filter(
                'createDate',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
              ),
              Filter(
                'createDate',
                isLessThanOrEqualTo: Timestamp.fromDate(endDate),
              ),
              Filter(
                'noOfReports',
                isGreaterThanOrEqualTo: 1,
              ),
            ),
          )
          .limit(10)
          .get();
      return result;
    } catch (e, stackTrace) {
      log("Error fetching reports: $e", stackTrace: stackTrace);
      print(e);
      // Handle the error as needed, e.g., throw a custom exception
      throw CustomExeception('Error fetching reports: $e');
    }
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>?> fetchNextReports({
    DateTime? startDate,
    DateTime? endDate,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      if (lastDocument == null || startDate == null || endDate == null) {
        return null;
      }

      if (startDate.isAfter(endDate)) {
        throw ArgumentError('Start date cannot be after end date');
      }

      final result = await _firestore
          .collection('posts')
          .orderBy('createDate', descending: true)
          .orderBy('noOfReports')
          .where(
            Filter.and(
              Filter('userId', isNotEqualTo: 'owner'),
              Filter(
                'createDate',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
              ),
              Filter(
                'createDate',
                isLessThanOrEqualTo: Timestamp.fromDate(endDate),
              ),
              Filter(
                'noOfReports',
                isGreaterThanOrEqualTo: 1,
              ),
            ),
          )
          .startAfterDocument(lastDocument)
          .limit(10)
          .get();

      return result;
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      log("Error fetching next reports: $e", stackTrace: stackTrace);
      // Handle the error as needed, e.g., throw a custom exception
      // throw CustomExeception('Error fetching next reports: $e');
    }
    return null;
  }

  // FETCH USER

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> fetchUser(String userId) {
    final result =
        _firestore.collection('users').where('userId', isEqualTo: userId).get();
    return result;
  }

// DELETE REPORTS

  @override
  FutureResult<Unit> deleteReports(String id) async {
    try {
      await _firestore.collection('posts').doc(id).delete();
      return right(unit);
    } on CustomExeception catch (e) {
      return left(MainFailure.serverFailure(errorMsg: e.errorMsg));
    }
  }

  @override
  FutureResult<void> updateUser(UserModel userModel) async {
    try {
      await _firestore.collection('users').doc(userModel.id).update({
        'totalPosts': userModel.totalPosts,
        'isBlocked': userModel.isBlocked,
      });
      return right(null);
    } on CustomExeception catch (e) {
      return left(MainFailure.serverFailure(errorMsg: e.errorMsg));
    }
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> fetchUserReports(String userId) {
    final result = _firestore
        .collection('posts')
        .orderBy('createDate', descending: true)
        .where(Filter.and(
            Filter(
              'noOfReports',
              isGreaterThanOrEqualTo: 1,
            ),
            Filter('userId', isEqualTo: userId)))
        .get();
    return result;
  }
}
