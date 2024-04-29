import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hinvex/features/properties/data/i_properties_facade.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IPropertiesFacade)
class IPropertiesImpl implements IPropertiesFacade {
  IPropertiesImpl(this._firestore);
  final FirebaseFirestore _firestore;

// FETCH PROPERTIES

  @override
  // Stream<QuerySnapshot<Map<String, dynamic>>> fetchProperties() {
  //   final result = _firestore
  //       .collection('posts')
  //       .orderBy('createDate', descending: true)
  //       .where('userId', isNotEqualTo: 'owner')
  //       .limit(5)
  //       .snapshots();
  //   return result;
  // }

  // @override
  // Stream<QuerySnapshot<Map<String, dynamic>>> fetchNextPoperties(
  //     DocumentSnapshot<Object?>? lastDocument) {
  //   if (lastDocument == null) {
  //     return const Stream.empty();
  //   }
  //   final result = _firestore
  //       .collection('posts')
  //       .orderBy('createDate', descending: true)
  //       .where('userId', isNotEqualTo: 'owner')
  //       .startAfterDocument(lastDocument)
  //       .limit(5)
  //       .snapshots();
  //   return result;
  // }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> fetchProperties() async {
    try {
      final result = await _firestore
          .collection('posts')
          .orderBy('createDate', descending: true)
          .where('userId', isNotEqualTo: 'owner')
          .limit(5)
          .get();
      return result;
    } catch (e) {
      print('Error fetching properties: $e');
      throw e; // rethrow the error to be caught by the caller
    }
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>?> fetchNextPoperties(
      DocumentSnapshot<Object?>? lastDocument) async {
    try {
      if (lastDocument == null) {
        return null;
      }
      final result = await _firestore
          .collection('posts')
          .orderBy('createDate', descending: true)
          .where('userId', isNotEqualTo: 'owner')
          .startAfterDocument(lastDocument)
          .limit(5)
          .get();
      return result;
    } catch (e) {
      print('Error fetching next properties: $e');
      throw e; // rethrow the error to be caught by the caller
    }
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> fetchUser(String userId) {
    final reuslt =
        _firestore.collection('users').where('userId', isEqualTo: userId).get();
    return reuslt;
  }
}
