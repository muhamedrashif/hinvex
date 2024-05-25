import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hinvex/features/uploadedByAdmin/data/model/search_location_model/search_location_model.dart';

class UserModel {
  final String? id;
  final String userId;
  final String userName;
  final String userPhoneNumber;
  final String userWhatsAppNumber;
  final String userImage;
  int totalPosts;
  final PlaceCell? userLocation;
  final String partnership;
  bool isBlocked;

  UserModel({
    this.id,
    required this.userId,
    required this.userName,
    required this.userPhoneNumber,
    required this.userWhatsAppNumber,
    required this.userImage,
    required this.totalPosts,
    required this.userLocation,
    required this.partnership,
    required this.isBlocked,
  });
  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "userName": userName,
        "userPhoneNumber": userPhoneNumber,
        "userWhatsAppNumber": userWhatsAppNumber,
        "userImage": userImage,
        "totalPosts": totalPosts,
        "userLocation": userLocation!.toMap(),
        "partnership": partnership,
        "isBlocked": isBlocked,
      };
  static UserModel fromSnap(DocumentSnapshot<Map<String, dynamic>> snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      id: snap.id,
      userId: snapshot['userId'] ?? '',
      userName: snapshot['userName'] ?? '',
      userPhoneNumber: snapshot['userPhoneNumber'] ?? '',
      userWhatsAppNumber: snapshot['userWhatsAppNumber'] ?? '',
      userImage: snapshot['userImage'] ?? '',
      totalPosts: snapshot['totalPosts'] ?? 0,
      // userLocation: PlaceCell.fromMap(snapshot['userLocation']),
      userLocation: snapshot['userLocation'] != null
          ? PlaceCell.fromMap(snapshot['userLocation'])
          : null,

      partnership: snapshot['partnership'] ?? '',
      isBlocked: snapshot['isBlocked'] ?? false,
    );
  }
}
