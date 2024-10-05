import 'package:food_reviews/models/review_model.dart';
import 'package:food_reviews/services/authentication_service.dart';
import 'package:food_reviews/services/database_service.dart';

class ReviewListLogic {
  ReviewListLogic() : _uid = AuthenticationService.getCurrentUserUid();

  final String _uid;
  late Stream<List<ReviewModel>> reviewModelList;

  void getReviewModelList() {
    reviewModelList = DatabaseService.getReviewsList(_uid);
  }

  ReviewModel addReview() {
    return ReviewModel.addNewReviewWithDefaultValues(uid: _uid);
  }

  static void deleteReview(ReviewModel reviewModel) {
    DatabaseService.deleteReview(reviewModel);
  }

  void signOut() {
    AuthenticationService.signOut();
  }
}
