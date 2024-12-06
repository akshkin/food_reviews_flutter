import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  static Future<String> uploadPhoto(
      {required String uid, required XFile file}) async {
    final Reference storageReference = FirebaseStorage.instance.ref();
    final Reference photoReference =
        storageReference.child("$uid/${file.name}");

    try {
      if (kIsWeb) {
        Uint8List? fileAsBytes = await file.readAsBytes();
        await photoReference.putData(fileAsBytes);
      } else {
        await photoReference.putFile(File(file.path));
      }
    } on Exception catch (error) {
      debugPrint("Error uploading photo : $error");
    }

    String downloadUrl = await photoReference.getDownloadURL();
    return downloadUrl;
  }

  static Future<void> deletePhoto({required String photoPath}) async {
    final Reference storageReference =
        FirebaseStorage.instance.refFromURL(photoPath);
    try {
      await storageReference
          .delete()
          .then((success) => debugPrint("Successfully deleted photo"))
          .onError((error, stackTrace) => debugPrint("Error deleting photo"));
    } on Exception catch (error) {
      debugPrint("Error deleting photo : $error");
    }
  }
}
