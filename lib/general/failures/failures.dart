import 'package:freezed_annotation/freezed_annotation.dart';
part 'failures.freezed.dart';

@freezed
class MainFailure with _$MainFailure {
  const factory MainFailure.serverFailure({required String errorMsg}) =
      _ServerFailure;
  const factory MainFailure.networkFailure({required String errorMsg}) =
      _NetworkFailure;

  const factory MainFailure.imageUploadFailure({required String errorMsg}) =
      _ImageUploadFailure;

  const factory MainFailure.noDataFountFailure({required String errorMsg}) =
      _NoDataFountFailure;

  const factory MainFailure.imagePickFailed({required String errorMsg}) =
      _ImagePickFailed;

  const factory MainFailure.locationFailure({required String errorMsg}) =
      LocationFailure;
  const factory MainFailure.areaCoverd({required String errorMsg}) = AreaCoverd;

  const factory MainFailure.unknownError({required String errorMsg}) =
      UnknownError;
  const factory MainFailure.userAuthenticatorError({required String errorMsg}) =
      UserAuthenticatorError;
  const factory MainFailure.dynamicLinkError({required String errorMsg}) =
      DynamicLinkError;
}
