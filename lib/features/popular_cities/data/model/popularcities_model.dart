import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hinvex/features/uploadedByAdmin/data/model/search_location_model/search_location_model.dart';

class PopularCitiesModel {
  final String? id;
  final PlaceCell? placeCell;
  PopularCitiesModel({
    this.id,
    this.placeCell,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'placeCell': placeCell?.toMap(),
      };

  static PopularCitiesModel fromSnap(
      DocumentSnapshot<Map<String, dynamic>> snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return PopularCitiesModel(
      id: snap.id,
      placeCell: PlaceCell.fromMap(snapshot['placeCell']),
    );
  }

  PopularCitiesModel copyWith({
    String? id,
    PlaceCell? placeCell,
  }) {
    return PopularCitiesModel(
      id: id ?? this.id,
      placeCell: placeCell ?? this.placeCell,
    );
  }
}
