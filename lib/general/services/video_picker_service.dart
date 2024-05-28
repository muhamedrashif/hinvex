import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hinvex/general/failures/exeception/execeptions.dart';
import 'package:hinvex/general/utils/toast/toast.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

final FirebaseStorage _storage = FirebaseStorage.instance;

// VIDEO PICKER

// Future<Uint8List?> pickVideo() async {
//   final ImagePicker imagePicker = ImagePicker();
//   final XFile? pickedVideoFile;
//   final Uint8List? videoBytes;
//   try {
//     pickedVideoFile = await imagePicker.pickVideo(source: ImageSource.gallery);
//     if (pickedVideoFile != null) {
//       final bytes = await pickedVideoFile.readAsBytes();
//       final int sizeInBytes = bytes.length;
//       final int sizeInMB = sizeInBytes ~/ (1024 * 1024);
//       if (sizeInMB < 15) {
//         videoBytes = Uint8List.fromList(bytes);
//         return videoBytes;
//       } else {
//         showToast(
//             'Video file is too large: ${sizeInMB}MB. Maximum allowed size is 15MB.');
//       }
//     } else {
//       showToast('Failed to pick video from gallery');
//     }
//   } catch (e) {
//     showToast('Failed to pick video from gallery: $e');
//   }

//   return null;
// }

Future<Uint8List?> pickVideo() async {
  final FileUploadInputElement input = FileUploadInputElement()
    ..accept = 'video/*';
  input.click();

  await input.onChange.first;

  if (input.files != null && input.files!.isNotEmpty) {
    final File file = input.files![0];
    final FileReader reader = FileReader();
    reader.readAsArrayBuffer(file);

    await reader.onLoad.first;

    final Uint8List videoBytes = reader.result as Uint8List;

    // Check video size
    final int sizeInBytes = videoBytes.length;
    final int sizeInMB = sizeInBytes ~/ (1024 * 1024);
    if (sizeInMB > 15) {
      // Video size exceeds 15 MB
      window.alert('Video size exceeds 15 MB.');
      return null;
    }

    // Check video duration
    final VideoElement videoElement = VideoElement()
      ..src = Url.createObjectUrlFromBlob(file);
    await videoElement.onLoadedMetadata.first;

    final num durationInSeconds = videoElement.duration;
    if (durationInSeconds > 60) {
      // Video duration exceeds 1 minute
      window.alert('Video duration exceeds 1 minute.');
      return null;
    }

    return videoBytes;
  } else {
    // No file selected
    return null;
  }
}

Future<String> saveVideo({
  required Uint8List videoBytes,
}) async {
  final String videoName =
      'ProductVideos/${DateTime.now().microsecondsSinceEpoch}.mp4';
  try {
    await _storage
        .ref(videoName)
        .putData(videoBytes, SettableMetadata(contentType: 'video/mp4'));
    final downloadUrl = await _storage.ref(videoName).getDownloadURL();
    return downloadUrl;
  } on FirebaseException catch (e) {
    throw CustomExeception(e.code);
  }
}

Future<void> deleteVideo({required String videoPath}) async {
  try {
    await _storage.ref(videoPath).delete();
    showToast('Video deleted successfully');
  } on FirebaseException catch (e) {
    showToast('Failed to delete video: ${e.code}');
  }
}
