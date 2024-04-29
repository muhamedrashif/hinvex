import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hinvex/features/popular_cities/data/i_popularCities_facade.dart';
import 'package:hinvex/features/popular_cities/data/model/popularcities_model.dart';
import 'package:hinvex/features/uploadedByAdmin/data/model/location_model_main.dart/location_model_main.dart';
import 'package:hinvex/features/uploadedByAdmin/data/model/search_location_model/search_location_model.dart';

class PopularCitiesProvider with ChangeNotifier {
  final IPopularCitiesFacade iPopularCitiesFacade;
  PopularCitiesProvider({required this.iPopularCitiesFacade});
  final List<PlaceResult> _suggestions = [];

  List<PlaceResult> get suggestions => _suggestions;
  // SEARCH LOCATION

  Future<void> getLocations(String query) async {
    final reult = await iPopularCitiesFacade.pickLocationFromSearch(query);
    _suggestions.clear();
    reult.fold(
      (l) => null,
      (r) {
        log('Data ${r.length}');
        _suggestions.addAll(r);
        notifyListeners();
      },
    );
  }

  Future<void> serchLocationByAddres({
    required String latitude,
    required String longitude,
    required Function(PlaceCell) onSuccess,
    required VoidCallback onFailure,
  }) async {
    final result = await iPopularCitiesFacade.serchLocationByAddres(
        latitude: latitude, longitude: longitude);

    await result.fold(
      (l) {
        onFailure();
      },
      (r) async {
        log('serchLocationByAddres success');

        result.fold((l) {
          onFailure();
        }, (_) {
          onSuccess(r);
        });
      },
    );
  }

  Future<void> uploadPopularCities({
    required PopularCitiesModel popularCitiesModel,
    required VoidCallback onSuccess,
    required VoidCallback onFailure,
  }) async {
    final result =
        await iPopularCitiesFacade.uploadPopularCities(popularCitiesModel);

    result.fold((error) {
      print(error.errorMsg);
    }, (success) {
      notifyListeners();
    });
  }

  List<PopularCitiesModel> popularcitiesList = [];
  bool popularcitiesIsLoading = false;
  Future fetchPopularCities() async {
    popularcitiesIsLoading = true;
    notifyListeners();

    final result = await iPopularCitiesFacade.fetchPopularCities();
    result.fold((l) => null,
        (r) => popularcitiesList.addAll(r as Iterable<PopularCitiesModel>));

    popularcitiesIsLoading = false; // Set loading to false after fetching
    notifyListeners();
  }

  Future deletePopularCities({
    required String id,
    required VoidCallback onSuccess,
    required VoidCallback onFailure,
  }) async {
    final result = await iPopularCitiesFacade.deletePopularCities(id);
    result.fold((error) {
      log(error.errorMsg);
    }, (success) async {
      onSuccess.call();
    });
    notifyListeners();
  }

  void clearSuggestions() {
    _suggestions.clear();
    notifyListeners();
  }
}
