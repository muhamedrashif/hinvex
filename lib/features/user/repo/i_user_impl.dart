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
  bool noMoreData = false;
  @override
  FutureResult<List<UserModel>> fetchUser() async {
    if (noMoreData == true) return right([]); //THERE IS NOMORE DATA
    try {
      final result = lastDoc == null
          ? await _firestore.collection('users').limit(5).get()
          : await _firestore
              .collection('users')
              .startAfterDocument(lastDoc!)
              .limit(5)
              .get();
      log("result  ${result.docs.length}");

      if (result.docs.length < 5 || result.docs.isEmpty) {
        noMoreData = true;
      } else {
        lastDoc = result.docs.last;
      }
      final userList = result.docs.map((e) => UserModel.fromSnap(e)).toList();
      return right(userList);
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

// FETCH USER POSTS DETAILS
  @override
  Future<QuerySnapshot<Map<String, dynamic>>> fetchPosts(String userId) {
    try {
      final result = _firestore
          .collection('posts')
          .orderBy('createDate', descending: true)
          .where('userId', isEqualTo: userId)
          .get();

      return result;
    } on Exception catch (e) {
      return Future.error(e);
    }
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
