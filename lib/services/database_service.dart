import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_reviews/helper/constants.dart';
import 'package:food_reviews/models/review_model.dart';
import 'package:food_reviews/models/user_model.dart';
import 'package:food_reviews/services/storage_service.dart';
import 'package:image_picker/image_picker.dart';

class DatabaseService {
  /// User collection
  static Future<bool> addUser(UserModel userModel) async {
    // use the set() to add new user in order to assign our own uid
    var result = await FirebaseFirestore.instance
        .collection(DatabaseCollections.users.name)
        .doc(userModel.uid) // assign our own uid
        .withConverter<UserModel>(
            fromFirestore: (snapshot, _) =>
                UserModel.fromJson(snapshot.data()!),
            toFirestore: (user, _) => user.toJson())
        // merge to true so that we don't create a new user with the same uid if we click on register again
        .set(userModel, SetOptions(merge: true))
        .then((_) => true)
        .onError((error, stackTrace) => false);

    return result;
  }

  static Future<UserModel> getUser(String uid) async {
    return FirebaseFirestore.instance
        .collection("${DatabaseCollections.users.name}/$uid")
        .doc(uid)
        .withConverter(
            fromFirestore: (snapshot, _) =>
                UserModel.fromJson(snapshot.data()!),
            toFirestore: (user, _) => user.toJson())
        .get()
        .then((docSnapshot) => docSnapshot.data()!)
        .onError((error, stackTrace) => Future.error("$error"));
  }

  static Future<bool> updateUser(UserModel userModel) {
    return FirebaseFirestore.instance
        .collection(DatabaseCollections.users.name)
        .doc(userModel.uid)
        .update(userModel.toJson())
        .then((_) => true)
        .onError((error, stackTrace) => false);
  }

  // Review collection
  static Future<bool> addReview(
      {required ReviewModel reviewModel, XFile? file}) async {
    if (reviewModel.photo.isNotEmpty) {
      String downloadUrl =
          await StorageService.uploadPhoto(uid: reviewModel.uid, file: file!);

      reviewModel.copyWith(photo: downloadUrl);
    }

    return FirebaseFirestore.instance
        .collection(DatabaseCollections.usersData.name)
        .doc(reviewModel.uid)
        .collection(DatabaseCollections.reviews.name)
        .withConverter<ReviewModel>(
          fromFirestore: (snapshot, _) =>
              ReviewModel.fromJson(snapshot.data()!),
          toFirestore: (review, _) => review.toJson(),
        )
        .add(reviewModel)
        .then((value) => true)
        .onError((error, stackTrace) => false);
  }

  static Future<bool> updateReview({
    required bool isPhotoChanged,
    required String originalPhotoUrl,
    required ReviewModel reviewEditModel,
    XFile? file,
  }) async {
    // check if a photo changed and delete current uploaded photo
    if (reviewEditModel.photo.isEmpty &&
        originalPhotoUrl.isNotEmpty &&
        isPhotoChanged) {
      await StorageService.deletePhoto(photoPath: originalPhotoUrl);
    } else if (reviewEditModel.photo.isNotEmpty &&
        originalPhotoUrl.isNotEmpty &&
        isPhotoChanged) {
      // remove current photo
      await StorageService.deletePhoto(photoPath: originalPhotoUrl);
      // upload new photo
      String downloadUrl = await StorageService.uploadPhoto(
          uid: reviewEditModel.uid, file: file!);
      reviewEditModel.copyWith(photo: downloadUrl);
    } else if (reviewEditModel.photo.isNotEmpty &&
        originalPhotoUrl.isEmpty &&
        isPhotoChanged) {
      // no original photo , only new photo to upload
      String downloadUrl = await StorageService.uploadPhoto(
          uid: reviewEditModel.uid, file: file!);
      reviewEditModel.copyWith(photo: downloadUrl);
    }

    return FirebaseFirestore.instance
        .collection(DatabaseCollections.usersData.name)
        .doc(reviewEditModel.uid)
        .collection(DatabaseCollections.reviews.name)
        .doc(reviewEditModel.documentId)
        .update(reviewEditModel.toJson())
        .then((_) => true)
        .onError((error, stackTrace) => false);
  }

  static Future<bool> deleteReview(ReviewModel reviewModel) async {
    if (reviewModel.photo.isNotEmpty) {
      StorageService.deletePhoto(photoPath: reviewModel.photo);
    }

    return FirebaseFirestore.instance
        .collection(DatabaseCollections.usersData.name)
        .doc(reviewModel.uid)
        .collection(DatabaseCollections.reviews.name)
        .doc(reviewModel.documentId)
        .delete()
        .then((_) => true)
        .onError((error, stackTrace) => false);
  }

  static Stream<List<ReviewModel>> getReviewsList(String uid) {
    return FirebaseFirestore.instance
        .collection(DatabaseCollections.usersData.name)
        .doc(uid)
        .collection(DatabaseCollections.reviews.name)
        .where("uid", isEqualTo: uid)
        .orderBy('reviewDate', descending: true)
        .withConverter<ReviewModel>(
            fromFirestore: (snapshot, _) {
              final reviewModel = ReviewModel.fromJson(snapshot.data()!);
              final reviewModelWithDocumentId =
                  reviewModel.copyWith(documentId: snapshot.id);
              return reviewModelWithDocumentId;
            },
            toFirestore: (review, _) => review.toJson())
        .snapshots() // constant stream of data
        .map((QuerySnapshot<ReviewModel> snapshot) =>
            snapshot.docs.map((doc) => doc.data()).toList())
        .handleError((error) => debugPrint("Error: $error"));
  }

  static Stream<List<ReviewModel>> getReviewListPhotos(String uid) {
    return FirebaseFirestore.instance
        .collection(DatabaseCollections.usersData.name)
        .doc(uid)
        .collection(DatabaseCollections.reviews.name)
        .where("uid", isEqualTo: uid)
        .where("photo", isNotEqualTo: "")
        // .orderBy('reviewDate', descending: true)
        .withConverter<ReviewModel>(
            fromFirestore: (snapshot, _) {
              final reviewModel = ReviewModel.fromJson(snapshot.data()!);
              final reviewModelWithDocumentId =
                  reviewModel.copyWith(documentId: snapshot.id);
              return reviewModelWithDocumentId;
            },
            toFirestore: (review, _) => review.toJson())
        .snapshots() // constant stream of data
        .map((QuerySnapshot<ReviewModel> snapshot) {
      List<ReviewModel> list = snapshot.docs.map((doc) => doc.data()).toList();
      list.sort((a, b) => b.reviewDate.compareTo(a.reviewDate));
      return list;
    }).handleError((error) => debugPrint("Error: $error"));
  }
}
