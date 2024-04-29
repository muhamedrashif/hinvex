import 'package:dartz/dartz.dart';
import 'package:hinvex/features/uploadedByAdmin/data/model/location_model_main.dart/location_model_main.dart';
import 'package:hinvex/features/uploadedByAdmin/data/model/search_location_model/search_location_model.dart';
import 'package:hinvex/general/typedefs/typedefs.dart';

import 'model/popularcities_model.dart';

abstract class IPopularCitiesFacade {
  FutureResult<List<PlaceResult>> pickLocationFromSearch(
    String searchText,
  ) {
    throw UnimplementedError();
  }

  FutureResult<PlaceCell> serchLocationByAddres({
    required String latitude,
    required String longitude,
  }) {
    throw UnimplementedError(
      'serchLocationByAddres() is not implemented, '
      'implement the method before calling it',
    );
  }

  FutureResult<String> uploadPopularCities(
    PopularCitiesModel popularCitiesModel,
  ) {
    throw UnimplementedError('uploadPropertyToFireStore() not impl');
  }

  FutureResult<List<PopularCitiesModel>> fetchPopularCities() {
    throw UnimplementedError('fetchMobileBanners() not impl');
  }

  FutureResult<Unit> deletePopularCities(String id) {
    throw UnimplementedError('deletePopularCities() not impl');
  }
}
