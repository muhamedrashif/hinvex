import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hinvex/features/notification/data/i_notification_facade.dart';
import 'package:hinvex/features/notification/data/model/notification_model.dart';
import 'package:hinvex/general/services/image_picker_service.dart';

class NotificationProvider with ChangeNotifier {
  final INotificationFacade iNotificationFacade;

  NotificationProvider({required this.iNotificationFacade});

  Uint8List? imageFile;
  NotificationModel? notificationModel;
  String? imageUrl;
  bool sendLoading = false;

  // GET IMAGE

  Future<void> getImage() async {
    Uint8List? imageBytes = await pickImage();
    if (imageBytes != null) {
      imageFile = imageBytes;
    }
    notifyListeners();
  }

  // SAVE IMAGE

  // Future<void> saveImage({
  //   required String title,
  //   required String description,
  //   required VoidCallback onSuccess,
  // }) async {
  //   log("111");
  //   sendAndStoreloading = true;
  //   notifyListeners();
  //   log("send loading $sendAndStoreloading");

  //   String? imgUrl;
  //   log(imageFile.toString());

  //   if (imageFile != null) {
  //     final result = await iNotificationFacade.saveImages(imagePath: imageFile);
  //     result.fold((error) {
  //       sendAndStoreloading = false;
  //       notifyListeners();
  //       log(error.errorMsg);
  //     }, (success) {
  //       imgUrl = success;

  //       onSuccess.call();
  //     });
  //   }

  //   notificationModel = NotificationModel(
  //     image: imgUrl,
  //     timestamp: Timestamp.now(),
  //   );
  //   await sendNotification(url: imgUrl, title: title, description: description);
  //   sendAndStoreloading = false;
  //   notifyListeners();
  // }

// CLEAR IMAGE

  void clearImage() {
    imageFile = null;
    imageUrl = null;

    notifyListeners();
  }

// SEND AND STORE NOTIFICATION TO FIRESTORE
  Future<void> sendAndStroreNotification({
    required NotificationModel notification,
    required VoidCallback onSuccess,
  }) async {
    sendLoading = true;
    notifyListeners();

    final result = await iNotificationFacade.sendNotification(
      notificationModel: notification,
      imageByte: imageFile,
    );
    result.fold(
      (error) {
        sendLoading = false;
        notifyListeners();
      },
      (success) {
        onSuccess.call();
        clearImage();
        sendLoading = false;
        notifyListeners();
      },
    );
  }
}
