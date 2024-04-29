// ignore_for_file: unused_local_variable

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:hinvex/features/notification/data/i_notification_facade.dart';
import 'package:hinvex/features/notification/data/model/notification_model.dart';
import 'package:hinvex/general/failures/exeception/execeptions.dart';
import 'package:hinvex/general/failures/failures.dart';
import 'package:hinvex/general/services/image_picker_service.dart';
import 'package:hinvex/general/services/notification_services.dart';
import 'package:hinvex/general/typedefs/typedefs.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: INotificationFacade)
class INotificationImpl implements INotificationFacade {
  INotificationImpl(this._firestore);
  final FirebaseFirestore _firestore;

  // GET IMAGE

  @override
  FutureResult<Uint8List?> getImage() async {
    try {
      Uint8List? imageBytes = await pickImage();
      return right(imageBytes);
    } catch (ex) {
      return left(MainFailure.imagePickFailed(errorMsg: ex.toString()));
    }
  }

  // SAVE IMAGE

  // @override
  // FutureResult<String?> saveImages({required Uint8List? imagePath}) async {
  //   try {
  //     if (imagePath == null) return right(null);
  //     String url = await saveImage(imagePath: imagePath);
  //     return right(url);
  //   } on CustomExeception catch (e) {
  //     return left(MainFailure.imageUploadFailure(errorMsg: e.errorMsg));
  //   }
  // }

// SEND AND STORE NOTIFICATION TO FIRESTORE

  @override
  FutureResult<NotificationModel> sendNotification(
      {required NotificationModel notificationModel,
      required Uint8List? imageByte}) async {
    try {
      String? imgUrl;
      if (imageByte != null) {
        imgUrl = await saveImage(imagePath: imageByte);
      }
      notificationModel.image = imgUrl;
      final result = await NotificationServices.sendFcmMessage(
          body: notificationModel.description.toString(),
          title: notificationModel.title.toString(),
          image: notificationModel.image);
      final response = await _firestore
          .collection('notification')
          .add(notificationModel.toJson());
      return right(notificationModel);
    } on CustomExeception catch (e) {
      return left(MainFailure.imageUploadFailure(errorMsg: e.errorMsg));
    }
  }
}
