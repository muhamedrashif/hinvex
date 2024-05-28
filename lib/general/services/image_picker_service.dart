import 'dart:developer';
import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hinvex/general/failures/exeception/execeptions.dart';
import 'package:hinvex/general/failures/failures.dart';
import 'package:hinvex/general/typedefs/typedefs.dart';
import 'package:image_picker/image_picker.dart';

// Future<Uint8List?> pickImage() async {
//   final ImagePicker imagePicker = ImagePicker();

//  final file = await imagePicker.pickImage(source: ImageSource.gallery);
//   if (file == null) {
//     return null;
//   }

//   return File(file.path).readAsBytesSync();
// }
final FirebaseStorage _storage = FirebaseStorage.instance;

// IMAGE PICKER

Future<Uint8List?> pickImage() async {
  final ImagePicker imagePicker = ImagePicker();
  final XFile? pickedImageFile;
  final Uint8List? imageBytes;
  try {
    pickedImageFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImageFile != null) {
      final bytes = await pickedImageFile.readAsBytes();
      imageBytes = Uint8List.fromList(bytes);
      return imageBytes;
    } else {
      log('Failed to pick image from gallery');
    }
  } catch (e) {
    log('Failed to pick image from gallery');
  }

  return null;
}

// SAVE IMAGE

Future<String> saveImage({
  required Uint8List imagePath,
}) async {
  final String imageName =
      'BannerImages/${DateTime.now().microsecondsSinceEpoch}.png';
  try {
    await _storage
        .ref(imageName)
        .putData(imagePath, SettableMetadata(contentType: 'image/png'));
    final downloadUrl = await _storage.ref(imageName).getDownloadURL();
    return downloadUrl;
  } on FirebaseException catch (e) {
    throw CustomExeception(e.code);
  }
}

// Future<String> saveImage({
//   required Uint8List imagePath,
// }) async {
//   // Compress the image
//   final compressedImage = await FlutterImageCompress.compressWithList(
//     imagePath,
//     minHeight: 1220, // adjust as needed
//     minWidth: 420, // adjust as needed
//     quality: 80, // adjust as needed
//   );

//   // Create a file name for the compressed image
//   final String imageName =
//       'BannerImages/${DateTime.now().microsecondsSinceEpoch}.png';
//   try {
//     // Save the compressed image to Firebase Storage
//     await _storage
//         .ref(imageName)
//         .putData(compressedImage, SettableMetadata(contentType: 'image/png'));
//     final downloadUrl = await _storage.ref(imageName).getDownloadURL();
//     return downloadUrl;
//   } on FirebaseException catch (e) {
//     throw CustomExeception(e.code);
//   }
// }

// DELETE IMAGE FROM STORAGE

Future<void> deleteUrl({
  required String url,
}) async {
  log(url);
  final imageRef = _storage.refFromURL(url);
  try {
    await imageRef.delete();
  } catch (e) {
    log(e.toString());
  }
}

// MULTIPLE IMAGE PICKER

// Future<List<Uint8List>> pickMultipleImages(int maxImages) async {
//   final ImagePicker imagePicker = ImagePicker();
//   final List<XFile>? pickedImageFiles;
//   final List<Uint8List> imageBytesList = [];

//   try {
//     pickedImageFiles = await imagePicker.pickMultiImage();
//     if (pickedImageFiles.isNotEmpty) {
//       for (var pickedImageFile in pickedImageFiles) {
//         final bytes = await pickedImageFile.readAsBytes();
//         final Uint8List imageBytes = Uint8List.fromList(bytes);
//         imageBytesList.add(imageBytes);
//       }
//     } else {
//       print('No images picked');
//     }
//   } on CustomExeception catch (e) {
//     print('Failed to pick images: $e');
//   }

//   return imageBytesList;
// }
FutureResult<List<String>> pickMultipleImages(int maxImages) async {
  final ImagePicker imagePicker = ImagePicker();
  // ignore: unnecessary_nullable_for_final_variable_declarations
  final List<XFile>? pickedImageFiles = await imagePicker.pickMultiImage();
  final List<Uint8List> imageBytesList = [];
  List<String> url = [];
  if (pickedImageFiles != null && pickedImageFiles.length <= maxImages) {
    final List<Future<Uint8List>> futures = pickedImageFiles
        .take(maxImages)
        .map((pickedImageFile) => pickedImageFile.readAsBytes())
        .toList();

    final List<Uint8List> bytesList = await Future.wait(futures);

    for (final bytes in bytesList) {
      final Uint8List imageBytes = Uint8List.fromList(bytes);
      imageBytesList.add(imageBytes);
      url = await saveImages(imagePaths: imageBytesList);
    }
  } else {
    return left(
        const MainFailure.imagePickFailed(errorMsg: 'Failed to pick images'));
  }

  return right(url);
}

// SAVE MULTIPLE IMAGES

Future<List<String>> saveImages({
  required List<Uint8List> imagePaths,
}) async {
  final List<String> downloadUrls = [];

  for (var imagePath in imagePaths) {
    final String imageName =
        'Property/${DateTime.now().microsecondsSinceEpoch}.png';
    try {
      await _storage
          .ref(imageName)
          .putData(imagePath, SettableMetadata(contentType: 'image/png'));
      final downloadUrl = await _storage.ref(imageName).getDownloadURL();
      downloadUrls.add(downloadUrl);
    } on FirebaseException catch (e) {
      throw CustomExeception(e.code);
    }
  }

  return downloadUrls;
}
