import "dart:convert";

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  final String uid;
  final String email;
  final DateTime createdDate;
  final bool isEmailVerified;
  final String phoneNumber;
  final String displayName;
  final String photoUrl;
  final String providerId;

  UserModel({
    required this.uid,
    required this.email,
    required this.createdDate,
    required this.isEmailVerified,
    required this.phoneNumber,
    required this.displayName,
    required this.photoUrl,
    required this.providerId,
  });

  factory UserModel.initializeNewUserWithDefaultValues({
    required String uid,
    String email = "",
    String providerId = "password",
  }) {
    return UserModel(
      uid: uid,
      email: email,
      providerId: providerId,
      createdDate: DateTime.now(),
      isEmailVerified: false,
      phoneNumber: "",
      displayName: "",
      photoUrl: "",
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json["uid"],
        email: json["email"],
        providerId: json["providerId"],
        createdDate: DateTime.parse(json["createdDate"]),
        isEmailVerified: json["isEmailVerified"],
        phoneNumber: json["phoneNumber"],
        displayName: json["displayName"],
        photoUrl: json["photoUrl"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "providerId": providerId,
        "createdDate": createdDate.toIso8601String(),
        "isEmailVerified": isEmailVerified,
        "phoneNumber": phoneNumber,
        "displayName": displayName,
        "photoUrl": photoUrl,
      };
}
