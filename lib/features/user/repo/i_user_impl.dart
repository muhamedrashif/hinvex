import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:hinvex/features/user/data/i_user_facade.dart';
import 'package:hinvex/features/user/data/model/user_model.dart';
import 'package:hinvex/general/failures/exeception/execeptions.dart';
import 'package:hinvex/general/failures/failures.dart';
import 'package:hinvex/general/typedefs/typedefs.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IUserFacade)
class IUserImpl implements IUserFacade {
  IUserImpl(this._firestore);
  final FirebaseFirestore _firestore;

  QueryDocumentSnapshot<Map<String, dynamic>>? lastDoc;

// // FETCH USER DETAILS

  @override
  FutureResult<List<UserModel>> fetchUser() async {
    try {
      if (lastDoc == null) {
        log('lastdoc null');
      } else {
        log('lastdoc');
      }
      final result = lastDoc == null
          ? await _firestore.collection('users').limit(10).get()
          : await _firestore
              .collection('users')
              .startAfterDocument(lastDoc!)
              .limit(10)
              .get();

      if (result.docs.isNotEmpty) {
        lastDoc = result.docs.last;
        return right(
          [
            ...result.docs.map(
              (e) => UserModel.fromSnap(e),
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
  void clearDoc() {
    lastDoc = null;
  }

  // @override
  // Stream<QuerySnapshot<Map<String, dynamic>>> fetchUser() {
  //   final result = _firestore.collection('users').limit(5).snapshots();
  //   return result;
  // }

  // @override
  // Stream<QuerySnapshot<Map<String, dynamic>>> fetchNextUser(
  //     DocumentSnapshot? lastDocument) {
  //   if (lastDocument == null) {
  //     return const Stream.empty();
  //   }
  //   final result = _firestore
  //       .collection('users')
  //       .startAfterDocument(lastDocument)
  //       .limit(5)
  //       .snapshots();
  //   return result;
  // }

// FETCH USER POSTS DETAILS
  @override
  Future<QuerySnapshot<Map<String, dynamic>>> fetchPosts(String userId) {
    final result = _firestore
        .collection('posts')
        .orderBy('createDate', descending: true)
        .where('userId', isEqualTo: userId)
        .get();

    return result;
  }

// FETCH REPORTS

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> fetchReports(String userId) {
    final result = _firestore
        .collection('posts')
        .orderBy('createDate', descending: true)
        .where(Filter.and(
          Filter(
            'userId',
            isEqualTo: userId,
          ),
          Filter(
            'noOfReports',
            isGreaterThanOrEqualTo: 1,
          ),
        ))
        .get();
    log(result.toString());
    return result;
  }

// DELETE POSTS

  @override
  FutureResult<Unit> deletePosts(String id) async {
    try {
      await _firestore.collection('posts').doc(id).delete();
      return right(unit);
    } on CustomExeception catch (e) {
      return left(MainFailure.serverFailure(errorMsg: e.errorMsg));
    }
  }

// // DELETE REPORTS

//   @override
//   FutureResult<Unit> deleteReports(String id) async {
//     try {
//       await _firestore.collection('posts').doc(id).delete();
//       return right(unit);
//     } on CustomExeception catch (e) {
//       return left(MainFailure.serverFailure(errorMsg: e.errorMsg));
//     }
//   }

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
}
