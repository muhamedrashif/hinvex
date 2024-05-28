import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hinvex/features/properties/data/i_properties_facade.dart';
import 'package:hinvex/features/user/data/model/user_product_details_model.dart';
import 'package:hinvex/general/failures/failures.dart';
import 'package:hinvex/general/typedefs/typedefs.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IPropertiesFacade)
class IPropertiesImpl implements IPropertiesFacade {
  IPropertiesImpl(this._firestore);
  final FirebaseFirestore _firestore;

  QueryDocumentSnapshot<Map<String, dynamic>>? lastDoc;
  bool noMoreData = false;

// FETCH PROPERTIES
  @override
  FutureResult<List<UserProductDetailsModel>> fetchProperties() async {
    log("FETCH PROPERTY CALLED");
    if (noMoreData == true) return right([]); //THERE IS NOMORE DATA
    try {
      final result = lastDoc == null
          ? await _firestore
              .collection('posts')
              .where('isAdmin', isEqualTo: false)
              .orderBy('createDate', descending: true)
              .limit(10)
              .get()
          : await _firestore
              .collection('posts')
              .where('isAdmin', isEqualTo: false)
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
      final userList =
          result.docs.map((e) => UserProductDetailsModel.fromSnap(e)).toList();
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

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> fetchUser(String userId) {
    final reuslt =
        _firestore.collection('users').where('userId', isEqualTo: userId).get();
    return reuslt;
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
                    Filter('isAdmin', isEqualTo: false),
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
                  Filter('isAdmin', isEqualTo: false),
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
}
