// import 'dart:developer';

// import 'package:dio/dio.dart';
// import 'package:hinvex/features/uploadedByAdmin/data/model/search_location_model/search_location_model.dart';

// class LocationService {
//   Future<List<OpentreetMapModel>> getsLocation(String query) async {
//     log("inside");
//     final response = await Dio().get(
//         "https://nominatim.openstreetmap.org/search.php?q=$query&format=json&addressdetails=1&limit=20&countrycodes=in");
//     if (response.statusCode == 200) {
//       log(response.statusCode.toString());
//       final parsed = response.data.cast<Map<String, dynamic>>();
//       log("parsed" + parsed.toString());
//       return parsed
//           .map<OpentreetMapModel>((json) => OpentreetMapModel.fromMap(json))
//           .toList();
//     } else {
//       throw Exception('Failed to load area............');
//     }
//   }
// }
