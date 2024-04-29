// import 'dart:developer';

// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:hinvex/features/uploadedByAdmin/data/model/location_model/locationa_model.dart';
// import 'package:hinvex/general/failures/failures.dart';
// import 'package:hinvex/general/typedefs/typedefs.dart';

// class LocationService {
//   static const String apikey = 'AIzaSyAtdiojUpua_HUorIa1wiTQXVRTanYkF6E';
//   static Dio dio = Dio();
//   static FutureResult<LocationModel> getLocation({
//     required String lattitude,
//     required String longitude,
//   }) async {
//     final url =
//         'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lattitude,$longitude&key=$apikey';

//     log(url);

//     try {
//       final response = await dio.get<dynamic>(url);
//       log(response.data.toString());
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
// }
