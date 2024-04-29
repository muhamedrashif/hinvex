// //SEARCH LOCATION
// import 'dart:developer';

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:hinvex/features/uploadedByAdmin/data/model/location_model/locationa_model.dart';

// Dio dio = Dio();

// Future<List<PlaceResult>?> searchPlaces({
//   required String input,
//   required String apiKey,
// }) async {
//   List<PlaceResult>? result;
//   try {
//     final uri =
//         Uri.https('maps.googleapis.com', '/maps/api/place/textsearch/json', {
//       'query': input,
//       'key': apiKey,
//     });
//     // ignore: inference_failure_on_function_invocation
//     final res = await dio.getUri(uri);

//     if (res.statusCode == 200) {
//       // ignore: avoid_dynamic_calls
//       final predictions = res.data['results'] as List<dynamic>;

//       result = predictions
//           .map((e) => PlaceResult.fromJson(e as Map<String, dynamic>))
//           .toList();
//     } else {
//       log('SEARCH PLACES: ${res.statusCode}');
//     }
//   } catch (err) {
//     debugPrint('ERROR IN SEARCH PLACES: $err');
//   }
//   return result;
// }
