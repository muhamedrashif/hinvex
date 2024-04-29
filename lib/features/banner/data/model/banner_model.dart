import 'package:cloud_firestore/cloud_firestore.dart';

// STATUS - 0 = WEB BANNER
// STATUS - 1 = MOBILE BANNER

class BannerModel {
  final String postId;
  final String image;
  final Timestamp timestamp;
  final String status;

  const BannerModel(
      {required this.postId,
      required this.image,
      required this.timestamp,
      required this.status});

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "image": image,
        "timestamp": timestamp,
        "status": status
      };

  static BannerModel fromSnap(DocumentSnapshot<Map<String, dynamic>> snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return BannerModel(
        postId: snap.id,
        image: snapshot['image'],
        timestamp: snapshot['timestamp'],
        status: snapshot['status']);
  }
}
