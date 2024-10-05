import 'package:food_reviews/models/review_model.dart';
import 'package:geolocator/geolocator.dart';

import 'constants.dart';

class ReviewEntryArguments {
  final ReviewMode reviewMode;
  final ReviewModel reviewModel;

  ReviewEntryArguments({required this.reviewMode, required this.reviewModel});
}

class ReviewEntryPhotoArguments {
  final ReviewModel reviewModel;

  ReviewEntryPhotoArguments({required this.reviewModel});
}

class LocationArguments {
  final bool answer;
  final Position? position;

  LocationArguments({required this.answer, this.position});
}
