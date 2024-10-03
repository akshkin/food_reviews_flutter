import 'package:flutter/material.dart';
import 'package:food_reviews/pages/authentication/authentication_login.dart';
import 'package:food_reviews/pages/authentication/authentication_signup.dart';
import 'package:food_reviews/pages/authentication/forgot_password.dart';
import 'package:food_reviews/pages/home.dart';
import 'package:food_reviews/pages/review_entry/review_entry.dart';
import 'package:food_reviews/pages/review_entry/review_entry_edit.dart';
import 'package:food_reviews/pages/review_entry/review_entry_photo_zoom.dart';
import 'package:food_reviews/pages/review_grid.dart';
import 'package:food_reviews/pages/review_list/review_list.dart';
import 'package:food_reviews/pages/review_map_locations.dart/ewview_map_locations.dart';

class Routes {
  static final Map<String, WidgetBuilder> routes = {
    MyHomePage.route: (BuildContext context) => const MyHomePage(),
    UserLogin.route: (BuildContext context) => const UserLogin(),
    UserSignup.route: (BuildContext context) => const UserSignup(),
    ForgotPassword.route: (BuildContext context) => const ForgotPassword(),
    ReviewList.route: (BuildContext context) => const ReviewList(),
    ReviewEntryView.route: (BuildContext context) => const ReviewEntryView(),
    ReviewEntryEdit.route: (BuildContext context) => const ReviewEntryEdit(),
    ReviewEntryPhotoZoom.route: (BuildContext context) =>
        const ReviewEntryPhotoZoom(),
    ReviewMapLocations.route: (BuildContext context) =>
        const ReviewMapLocations(),
    ReviewGridPhotos.route: (BuildContext context) => const ReviewGridPhotos(),
  };
}
