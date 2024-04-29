// import 'dart:convert';

// // ignore_for_file: public_member_api_docs, sort_constructors_first
// class LocationModel {
//   LocationModel({
//     required this.compoundCode,
//     required this.globalCode,
//     required this.results,
//     required this.status,
//   });

//   factory LocationModel.fromMap(Map<String, dynamic> map) {
//     return LocationModel(
//       compoundCode: map['compound_code'] as String?,
//       globalCode: map['global_code'] as String?,
//       results: List<Result>.from(
//         (map['results'] as List<dynamic>).map<Result>(
//           (x) => Result.fromMap(x as Map<String, dynamic>),
//         ),
//       ),
//       status: map['status'] as String?,
//     );
//   }
//   final String? compoundCode;
//   final String? globalCode;
//   final List<Result>? results;
//   final String? status;

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'compoundCode': compoundCode,
//       'globalCode': globalCode,
//       'results': results?.map((x) => x.toMap()).toList(),
//       'status': status,
//     };
//   }

//   String toJson() => json.encode(toMap());
// }

// class Result {
//   Result({
//     required this.addressComponents,
//     required this.formattedAddress,
//     required this.placeId,
//     required this.types,
//   });

//   factory Result.fromMap(Map<String, dynamic> map) {
//     return Result(
//       addressComponents: map['address_components'] != null
//           ? List<AddressComponent>.from(
//               (map['address_components'] as List<dynamic>)
//                   .map<AddressComponent>(
//                 (x) => AddressComponent.fromJson(x as Map<String, dynamic>),
//               ),
//             )
//           : null,
//       formattedAddress: map['formatted_address'] as String?,
//       placeId: map['placeId'] as String?,
//       types: map['types'] != null
//           ? List<dynamic>.from(map['types'] as List<dynamic>)
//           : null,
//     );
//   }
//   final List<AddressComponent>? addressComponents;
//   final String? formattedAddress;
//   final String? placeId;
//   final List<dynamic>? types;

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'addressComponents': addressComponents?.map((x) => x.toMap()).toList(),
//       'formattedAddress': formattedAddress,
//       'placeId': placeId,
//       'types': types,
//     };
//   }

//   String toJson() => json.encode(toMap());
// }

// class AddressComponent {
//   AddressComponent({
//     required this.longName,
//     required this.shortName,
//     required this.types,
//   });

//   factory AddressComponent.fromJson(Map<String, dynamic> json) {
//     return AddressComponent(
//       longName: json['long_name'] as String?,
//       shortName: json['short_name'] as String?,
//       types: List<dynamic>.from(json['types'] as List<dynamic>),
//     );
//   }
//   final String? longName;
//   final String? shortName;
//   final List<dynamic>? types;

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'longName': longName,
//       'shortName': shortName,
//       'types': types,
//     };
//   }

//   @override
//   String toString() => 'AddressComponent(longName: $longName,'
//       ' shortName: $shortName, types: $types)';

//   String toJson() => json.encode(toMap());
// }

// class Location {
//   Location({required this.lat, required this.lng});
//   factory Location.fromJson(Map<String, dynamic> map) {
//     return Location(lat: map['lat'] as double?, lng: map['lng'] as double?);
//   }
//   final double? lat;
//   final double? lng;

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'lat': lat,
//       'lng': lng,
//     };
//   }

//   String toJson() => json.encode(toMap());
// }

// class Place {
//   List<PlaceResult>? results;
//   String? status;

//   Place({this.results, this.status});

//   factory Place.fromJson(Map<String, dynamic> json) {
//     return Place(
//       results: json['results'] != null
//           // ignore: avoid_dynamic_calls
//           ? json['results']
//               .map(
//                 // ignore: inference_failure_on_untyped_parameter
//                 (place) => PlaceResult.fromJson(place as Map<String, dynamic>),
//               )
//               .toList() as List<PlaceResult>
//           : null,
//       status: json['status'] != null ? json['status'] as String : null,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'results': results?.map((x) => x.toMap()).toList(),
//       'status': status,
//     };
//   }

//   String toJson() => json.encode(toMap());
// }

// //--------------------------------------SEARCH PLACE MODELS--------------------------------------//
// class PlaceResult {
//   String? formattedAddress;
//   Geometry? geometry;

//   String? name;
//   String? placeId;
//   String? reference;
//   List<String>? types;

//   PlaceResult({
//     this.formattedAddress,
//     this.geometry,
//     this.name,
//     this.placeId,
//     this.reference,
//     this.types,
//   });

//   factory PlaceResult.fromJson(Map<String, dynamic> map) {
//     return PlaceResult(
//       formattedAddress: map['formatted_address'] != null
//           ? map['formatted_address'] as String
//           : null,
//       geometry: map['geometry'] != null
//           ? Geometry.fromJson(map['geometry'] as Map<String, dynamic>)
//           : null,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'formattedAddress': formattedAddress,
//       'geometry': geometry?.toMap(),
//       'name': name,
//       'placeId': placeId,
//       'reference': reference,
//       'types': types,
//     };
//   }

//   String toJson() => json.encode(toMap());
// }

// class Geometry {
//   Location? location;

//   Geometry({this.location});

//   factory Geometry.fromJson(Map<String, dynamic> json) {
//     return Geometry(
//       location: Location.fromJson(json['location'] as Map<String, dynamic>),
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'location': location?.toMap(),
//     };
//   }

//   String toJson() => json.encode(toMap());
// }
