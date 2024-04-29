// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i4;
import 'package:firebase_storage/firebase_storage.dart' as _i5;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../features/banner/data/i_banner_facade.dart' as _i17;
import '../../features/banner/repo/i_banner_impl.dart' as _i18;
import '../../features/notification/data/i_notification_facade.dart' as _i19;
import '../../features/notification/repo/i_notification_impl.dart' as _i20;
import '../../features/popular_cities/data/i_popularCities_facade.dart' as _i11;
import '../../features/popular_cities/repo/i_popularCities_impl.dart' as _i12;
import '../../features/properties/data/i_properties_facade.dart' as _i13;
import '../../features/properties/repo/i_properties_impl.dart' as _i14;
import '../../features/reports_and_issues/data/i_reports_and_issues_facade.dart'
    as _i15;
import '../../features/reports_and_issues/repo/i_reports_and_issues_impl.dart'
    as _i16;
import '../../features/uploadedByAdmin/data/i_uploadedByAdmin_facade.dart'
    as _i9;
import '../../features/uploadedByAdmin/repo/i_uploadedByAdmin_impl.dart'
    as _i10;
import '../../features/user/data/i_user_facade.dart' as _i7;
import '../../features/user/repo/i_user_impl.dart' as _i8;
import '../services/upload_location_service.dart' as _i6;
import 'firebase_injectable_module.dart' as _i3;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i1.GetIt> init(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final firebaseInjectableModule = _$FirebaseInjectableModule();
  await gh.factoryAsync<_i3.FirebaseServeice>(
    () => firebaseInjectableModule.firebaseServeice,
    preResolve: true,
  );
  gh.lazySingleton<_i4.FirebaseFirestore>(
      () => firebaseInjectableModule.firestore);
  gh.lazySingleton<_i5.FirebaseStorage>(
      () => firebaseInjectableModule.firebaseDtorage);
  gh.lazySingleton<_i6.UploadPlaceService>(
      () => _i6.UploadPlaceService(gh<_i4.FirebaseFirestore>()));
  gh.lazySingleton<_i7.IUserFacade>(
      () => _i8.IUserImpl(gh<_i4.FirebaseFirestore>()));
  gh.lazySingleton<_i9.IUploadedByAdminFacade>(() => _i10.IUploadedByAdminImpl(
        gh<_i6.UploadPlaceService>(),
        gh<_i4.FirebaseFirestore>(),
      ));
  gh.lazySingleton<_i11.IPopularCitiesFacade>(
      () => _i12.IPopularCitiesImpl(gh<_i4.FirebaseFirestore>()));
  gh.lazySingleton<_i13.IPropertiesFacade>(
      () => _i14.IPropertiesImpl(gh<_i4.FirebaseFirestore>()));
  gh.lazySingleton<_i15.IReportsAndIssuesFacade>(
      () => _i16.IReportsAndIssuesImpl(gh<_i4.FirebaseFirestore>()));
  gh.lazySingleton<_i17.IBannerFacade>(
      () => _i18.IBannerImpl(gh<_i4.FirebaseFirestore>()));
  gh.lazySingleton<_i19.INotificationFacade>(
      () => _i20.INotificationImpl(gh<_i4.FirebaseFirestore>()));
  return getIt;
}

class _$FirebaseInjectableModule extends _i3.FirebaseInjectableModule {}
