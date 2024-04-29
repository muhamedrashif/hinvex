// import 'package:cloud_firestore/cloud_firestore.dart';

// class PropertiesModel {
//   final String? id;
//   final String userId;
//   final String propertyImage;
//   final String propertyPrice;
//   final String propertyTitle;
//   final String propertyDetils;
//   final String propertyLocation;
//   final String propertyCategory;
//   final String propertyType;
//   PropertiesModel({
//     this.id,
//     required this.userId,
//     required this.propertyImage,
//     required this.propertyPrice,
//     required this.propertyTitle,
//     required this.propertyDetils,
//     required this.propertyLocation,
//     required this.propertyCategory,
//     required this.propertyType,
//   });
//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'userId': userId,
//         'propertyImage': propertyImage,
//         'propertyPrice': propertyPrice,
//         'propertyTitle': propertyTitle,
//         'propertyDetils': propertyDetils,
//         'propertyLocation': propertyLocation,
//         'propertyCategory': propertyCategory,
//         'propertyType': propertyType
//       };
//   static PropertiesModel fromSnap(DocumentSnapshot<Map<String, dynamic>> snap) {
//     var snapshot = snap.data() as Map<String, dynamic>;
//     return PropertiesModel(
//       id: snap.id,
//       userId: snapshot['userId'],
//       propertyImage: snapshot['propertyImage'],
//       propertyPrice: snapshot['propertyPrice'],
//       propertyTitle: snapshot['propertyTitle'],
//       propertyDetils: snapshot['propertyDetils'],
//       propertyLocation: snapshot['propertyLocation'],
//       propertyCategory: snapshot['propertyCategory'],
//       propertyType: snapshot['propertyType'],
//     );
//   }
// }
