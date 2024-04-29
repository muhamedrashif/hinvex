import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String? id;
  String? image;
  final String? title;
  final String? description;
  final Timestamp? timestamp;

  NotificationModel({
    this.id,
    this.image,
    this.title,
    this.description,
    this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "title": title,
        "description": description,
        "timestamp": timestamp,
      };

  static NotificationModel fromSnap(
      DocumentSnapshot<Map<String, dynamic>> snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return NotificationModel(
      id: snap.id,
      image: snapshot['image'],
      title: snapshot['title'],
      description: snapshot['description'],
      timestamp: snapshot['timestamp'],
    );
  }
}
