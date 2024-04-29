import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hinvex/features/popular_cities/data/i_popularCities_facade.dart';
import 'package:hinvex/features/popular_cities/data/model/popularcities_model.dart';
import 'package:hinvex/features/uploadedByAdmin/data/model/location_model_main.dart/location_model_main.dart';
import 'package:hinvex/features/uploadedByAdmin/data/model/search_location_model/search_location_model.dart';
import 'package:hinvex/general/failures/exeception/execeptions.dart';
import 'package:hinvex/general/failures/failures.dart';
import 'package:hinvex/general/services/function_service.dart';
import 'package:hinvex/general/typedefs/typedefs.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IPopularCitiesFacade)
class IPopularCitiesImpl implements IPopularCitiesFacade {
  IPopularCitiesImpl(this._firestore);
  // ignore: unused_field
  final FirebaseFirestore _firestore;

  @override
  FutureResult<PlaceCell> serchLocationByAddres({
    required String latitude,
    required String longitude,
  }) async {
    final result = await LocationService.getLocation(
      latitude: latitude,
      longitude: longitude,
    );

    return result.fold(
      left,
      (r) {
        final placeCell = <String, dynamic>{};

        r.results?[0].addressComponents?.forEach((e) {
          final typeActions = {
            'postal_code': () => placeCell['pincode'] = e.longName ?? '',
            'administrative_area_level_1': () =>
                placeCell['state'] = e.longName ?? '',
            'administrative_area_level_3': () =>
                placeCell['district'] = e.longName ?? '',
            'locality': () => placeCell['localArea'] = e.longName ?? '',
            'country': () => placeCell['country'] = e.longName ?? '',
          };

          e.types?.forEach((type) {
            if (typeActions.containsKey(type)) {
              typeActions[type]!();
            }
          });
        });

        placeCell['geoPoint'] = LandMark(
          latitude: double.parse(latitude),
          longitude: double.parse(longitude),
        ).toMap();

        debugPrint(placeCell.toString());

        return right(PlaceCell.fromMap(placeCell));
      },
    );
  }

  @override
  FutureResult<List<PlaceResult>> pickLocationFromSearch(
    String searchText,
  ) async {
    try {
      const String apikey = 'AIzaSyAtdiojUpua_HUorIa1wiTQXVRTanYkF6E';

      final url =
          'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$searchText&key=$apikey';

      final res = await httpRequestViaServer(url);
      print("SEARCH:::::::::::${res.toString()}");
      return right(
          [...(res['results'] as List).map((e) => PlaceResult.fromJson(e))]);
    } catch (err) {
      return left(MainFailure.serverFailure(errorMsg: err.toString()));
    }
  }

  @override
  FutureResult<String> uploadPopularCities(
      PopularCitiesModel popularCitiesModel) async {
    try {
      final response = await _firestore
          .collection('popularcities')
          .add(popularCitiesModel.toJson());
      return right(response.id);
    } on CustomExeception catch (e) {
      print(e.toString());
      return left(MainFailure.imageUploadFailure(errorMsg: e.errorMsg));
    }
  }

  @override
  FutureResult<List<PopularCitiesModel>> fetchPopularCities() async {
    // try {
    //   final result = await _firestore.collection('popularcities').get();
    //   final cities = result.docs.map((e) => e.data()).toList();
    //   final popularCitiesModel =
    //       cities.map((data) => PopularCitiesModel.fromSnap(data)).toList();

    //   return Right(popularCitiesModel);
    // } catch (e, stackTrace) {
    //   print(e.toString());
    //   log("Error fetching next reports: $e", stackTrace: stackTrace);
    //   throw CustomExeception('Error fetching next reports: $e');
    // }
    try {
      final result = await _firestore.collection('popularcities').get();
      final popularCitiesModel =
          result.docs.map((doc) => PopularCitiesModel.fromSnap(doc)).toList();

      return Right(popularCitiesModel);
    } catch (e, stackTrace) {
      print(e.toString());
      log("Error fetching next reports: $e", stackTrace: stackTrace);
      throw CustomExeception('Error fetching next reports: $e');
    }
  }

  @override
  FutureResult<Unit> deletePopularCities(String id) async {
    try {
      await _firestore.collection('popularcities').doc(id).delete();
      return right(unit);
    } on CustomExeception catch (e) {
      return left(MainFailure.serverFailure(errorMsg: e.errorMsg));
    }
  }
}
