// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';

Future httpRequestViaServer(String url) async {
  HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
    'getDataFromUrl',
  );
  try {
    final HttpsCallableResult result = await callable.call(
      <String, dynamic>{
        'url': url,
      },
    );

    return result.data;
  } on FirebaseFunctionsException catch (e) {
    print('caught firebase functions exception');
    throw Exception(e.code);
  } catch (e) {
    throw Exception(e.toString());
  }
}

class LocationModel {
  final String formattedAddress;
  final Geometry geometry;
  LocationModel({
    required this.formattedAddress,
    required this.geometry,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'formattedAddress': formattedAddress,
      'geometry': geometry.toMap(),
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      formattedAddress: map['formatted_address'] as String,
      geometry: Geometry.fromMap(map['geometry'] as Map<String, dynamic>),
    );
  }
}

class Geometry {
  final Location location;
  Geometry({
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'location': location.toMap(),
    };
  }

  factory Geometry.fromMap(Map<String, dynamic> map) {
    return Geometry(
      location: Location.fromMap(map['location'] as Map<String, dynamic>),
    );
  }
}

class Location {
  Location({
    required this.lng,
    required this.lat,
  });
  final num lat;
  final num lng;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lat': lat,
      'lng': lng,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      lat: map['lat'] as num,
      lng: map['lng'] as num,
    );
  }
}
