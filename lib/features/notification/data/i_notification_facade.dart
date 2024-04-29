import 'dart:typed_data';

import 'package:hinvex/features/notification/data/model/notification_model.dart';
import 'package:hinvex/general/typedefs/typedefs.dart';

abstract class INotificationFacade {
  FutureResult<Uint8List?> getImage() {
    throw UnimplementedError('getImage() not impl');
  }

  // FutureResult<String?> saveImages({required Uint8List? imagePath}) {
  //   throw UnimplementedError('saveImage() not impl');
  // }

  FutureResult<NotificationModel> sendNotification(
      {required NotificationModel notificationModel,
      required Uint8List? imageByte}) {
    throw UnimplementedError("sendNotification() not impl");
  }
}
