import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_reviews/helper/constants.dart';
import 'package:food_reviews/models/user_model.dart';

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
}
