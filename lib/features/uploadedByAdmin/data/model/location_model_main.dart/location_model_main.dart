// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import 'package:hinvex/general/failures/failures.dart';
import 'package:hinvex/general/typedefs/typedefs.dart';

class LocationModel {
  LocationModel({
    required this.compoundCode,
    required this.globalCode,
    required this.results,
    required this.status,
  });

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      compoundCode: map['compound_code'] as String?,
      globalCode: map['global_code'] as String?,
      results: List<Result>.from(
        (map['results'] as List<dynamic>).map<Result>(
          (x) => Result.fromMap(x as Map<String, dynamic>),
        ),
      ),
      status: map['status'] as String?,
    );
  }
  final String? compoundCode;
  final String? globalCode;
  final List<Result>? results;
  final String? status;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'compoundCode': compoundCode,
      'globalCode': globalCode,
      'results': results?.map((x) => x.toMap()).toList(),
      'status': status,
    };
  }

  String toJson() => json.encode(toMap());
}

class Result {
  Result({
    required this.addressComponents,
    required this.formattedAddress,
    required this.placeId,
    required this.types,
  });

  factory Result.fromMap(Map<String, dynamic> map) {
    return Result(
      addressComponents: map['address_components'] != null
          ? List<AddressComponent>.from(
              (map['address_components'] as List<dynamic>)
                  .map<AddressComponent>(
                (x) => AddressComponent.fromJson(x as Map<String, dynamic>),
              ),
            )
          : null,
      formattedAddress: map['formatted_address'] as String?,
      placeId: map['placeId'] as String?,
      types: map['types'] != null
          ? List<dynamic>.from(map['types'] as List<dynamic>)
          : null,
    );
  }
  final List<AddressComponent>? addressComponents;
  final String? formattedAddress;
  final String? placeId;
  final List<dynamic>? types;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'addressComponents': addressComponents?.map((x) => x.toMap()).toList(),
      'formattedAddress': formattedAddress,
      'placeId': placeId,
      'types': types,
    };
  }

  String toJson() => json.encode(toMap());
}

class AddressComponent {
  AddressComponent({
    required this.longName,
    required this.shortName,
    required this.types,
  });

  factory AddressComponent.fromJson(Map<String, dynamic> json) {
    return AddressComponent(
      longName: json['long_name'] as String?,
      shortName: json['short_name'] as String?,
      types: List<dynamic>.from(json['types'] as List<dynamic>),
    );
  }
  final String? longName;
  final String? shortName;
  final List<dynamic>? types;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'longName': longName,
      'shortName': shortName,
      'types': types,
    };
  }

  @override
  String toString() => 'AddressComponent(longName: $longName,'
      ' shortName: $shortName, types: $types)';

  String toJson() => json.encode(toMap());
}

class Location {
  Location({required this.lat, required this.lng});
  factory Location.fromJson(Map<String, dynamic> map) {
    return Location(lat: map['lat'] as double?, lng: map['lng'] as double?);
  }
  final double? lat;
  final double? lng;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lat': lat,
      'lng': lng,
    };
  }

  String toJson() => json.encode(toMap());
}

class Place {
  List<PlaceResult>? results;
  String? status;

  Place({this.results, this.status});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      results: json['results'] != null
          // ignore: avoid_dynamic_calls
          ? json['results']
              .map(
                // ignore: inference_failure_on_untyped_parameter
                (place) => PlaceResult.fromJson(place as Map<String, dynamic>),
              )
              .toList() as List<PlaceResult>
          : null,
      status: json['status'] != null ? json['status'] as String : null,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'results': results?.map((x) => x.toMap()).toList(),
      'status': status,
    };
  }

  String toJson() => json.encode(toMap());
}

//--------------------------------------SEARCH PLACE MODELS--------------------------------------//
class PlaceResult {
  String? formattedAddress;
  Geometry? geometry;

  String? name;
  String? placeId;
  String? reference;
  List<String>? types;

  PlaceResult({
    this.formattedAddress,
    this.geometry,
    this.name,
    this.placeId,
    this.reference,
    this.types,
  });

  factory PlaceResult.fromJson(Map<String, dynamic> map) {
    return PlaceResult(
      formattedAddress: map['formatted_address'] != null
          ? map['formatted_address'] as String
          : null,
      geometry: map['geometry'] != null
          ? Geometry.fromJson(map['geometry'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'formattedAddress': formattedAddress,
      'geometry': geometry?.toMap(),
      'name': name,
      'placeId': placeId,
      'reference': reference,
      'types': types,
    };
  }

  String toJson() => json.encode(toMap());
}

class Geometry {
  Location? location;

  Geometry({this.location});

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'location': location?.toMap(),
    };
  }

  String toJson() => json.encode(toMap());
}

class LocationService {
  static const String apikey = 'AIzaSyAtdiojUpua_HUorIa1wiTQXVRTanYkF6E';

  static FutureResult<LocationModel> getLocation({
    required String latitude,
    required String longitude,
  }) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apikey';

    debugPrint(url);

    try {
      final response = await http.get(Uri.parse(url));
      log(response.body.toString());

      if (response.statusCode == 200) {
        final address = LocationModel.fromMap(json.decode(response.body));
        return right(address);
      } else {
        throw Exception('Failed to get location');
      }
    } catch (err) {
      log('ERROR IN CONVERT TO ADDRESS FUNCTION : $err');
      throw MainFailure.serverFailure(errorMsg: err.toString());
    }
  }

  // SEARCH LOCATION
  static Future<List<PlaceResult>?> searchPlaces(String input) async {
    List<PlaceResult>? result;
    log("STEP-1");
    try {
      log("STEP-2");
      final uri =
          Uri.https('maps.googleapis.com', '/maps/api/place/textsearch/json', {
        'query': input,
        'key': apikey,
      });
      final response = await http.get(uri);
      log("STEP-3");
      if (response.statusCode == 200) {
        log("STEP-");
        final predictions =
            json.decode(response.body)['results'] as List<dynamic>;

        result = predictions
            .map((e) => PlaceResult.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        print('SEARCH PLACES: ${response.statusCode}');
      }
    } catch (err) {
      print('ERROR IN SEARCH PLACES: $err');
    }
    return result;
  }

  static Future<LocationModel> userSearchPlaces(String input) async {
    try {
      final uri =
          Uri.https('maps.googleapis.com', '/maps/api/place/textsearch/json', {
        'query': input,
        'key': apikey,
      });
      final response = await http.get(uri);

      print(response.body);

      if (response.statusCode == 200) {
        return LocationModel.fromMap(json.decode(response.body));
      } else {
        throw MainFailure.serverFailure(
          errorMsg: response.reasonPhrase ?? 'Server Error',
        );
      }
    } on DioException catch (err) {
      print('ERROR IN USER SEARCH PLACES: $err');
      throw MainFailure.serverFailure(errorMsg: err.toString());
    }
  }

  Future httpRequestViaServer({url}) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'getDataFromUrl',
    );
    try {
      final HttpsCallableResult result = await callable.call(
        <String, dynamic>{
          'url': url,
        },
      );
      return (result.data);
    } on FirebaseFunctionsException catch (e) {
      debugPrint('caught firebase functions exception');
      debugPrint(e.code);
      debugPrint(e.message);
      debugPrint(e.details);
      return null;
    } catch (e) {
      debugPrint('caught generic exception');
      debugPrint(e.toString());
      return null;
    }
  }
}





// class LocationService {
//   static const String apikey = 'AIzaSyAtdiojUpua_HUorIa1wiTQXVRTanYkF6E';
//   static Dio dio = Dio();
//   static FutureResult<LocationModel> getLocation({
//     required String lattitude,
//     required String longitude,
//   }) async {
//     final url =
//         'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lattitude,$longitude&key=$apikey';

//     print(url);

//     try {
//       final response = await dio.get<dynamic>(url);
//       print(response.data.toString());
//       final adress =
//           LocationModel.fromMap(response.data as Map<String, dynamic>);

//       return right(adress);
//     } catch (err) {
//       log('ERROR IN CONVERT TO ADRESS FUNCTION : $err');
//       return left(MainFailure.serverFailure(errorMsg: err.toString()));
//     }
//   }

//   //SEARCH LOCATION
//   static Future<List<PlaceResult>?> searchPlaces(String input) async {
//     List<PlaceResult>? result;
//     try {
//       final uri =
//           Uri.https('maps.googleapis.com', '/maps/api/place/textsearch/json', {
//         'query': input,
//         'key': apikey,
//       });
//       // ignore: inference_failure_on_function_invocation
//       final res = await dio.getUri(uri);

//       if (res.statusCode == 200) {
//         // ignore: avoid_dynamic_calls
//         final predictions = res.data['results'] as List<dynamic>;

//         result = predictions
//             .map((e) => PlaceResult.fromJson(e as Map<String, dynamic>))
//             .toList();
//       } else {
//         log('SEARCH PLACES: ${res.statusCode}');
//       }
//     } catch (err) {
//       debugPrint('ERROR IN SEARCH PLACES: $err');
//     }
//     return result;
//   }

//   static FutureResult<LocationModel> userSearchPlaces(String input) async {
//     try {
//       final uri =
//           Uri.https('maps.googleapis.com', '/maps/api/place/textsearch/json', {
//         'query': input,
//         'key': apikey,
//       });
//       final response = await dio.getUri<dynamic>(uri);

//       log(response.data.toString());

//       if (response.statusCode == 200) {
//         return right(
//           LocationModel.fromMap(response.data as Map<String, dynamic>),
//         );
//       } else {
//         return left(
//           MainFailure.serverFailure(
//             errorMsg: response.statusMessage ?? 'Server Error',
//           ),
//         );
//       }
//     } catch (err) {
//       return left(MainFailure.serverFailure(errorMsg: err.toString()));
//     }
//   }
// }
