import 'package:flutter/material.dart';

import 'package:food_reviews/logic/review_entry_logic.dart';

class ReviewEntryEditTextfields extends StatelessWidget {
  const ReviewEntryEditTextfields({
    super.key,
    required ReviewEntryLogic reviewEntryLogic,
    required TextEditingController restaurant,
    required TextEditingController title,
    required TextEditingController category,
    required TextEditingController review,
  })  : _reviewEntryLogic = reviewEntryLogic,
        _restaurant = restaurant,
        _title = title,
        _category = category,
        _review = review;

  final ReviewEntryLogic _reviewEntryLogic;
  final TextEditingController _restaurant;
  final TextEditingController _title;
  final TextEditingController _category;
  final TextEditingController _review;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _restaurant,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            hintText: "Restaurant",
          ),
          onTapOutside: (PointerDownEvent pointerDownEvent) {
            FocusScope.of(context).unfocus();
          },
          onChanged: (value) {
            _reviewEntryLogic.reviewEditModel =
                _reviewEntryLogic.reviewEditModel.copyWith(restaurant: value);
          },
        ),
        TextField(
          controller: _title,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            hintText: "Title",
          ),
          onTapOutside: (PointerDownEvent pointerDownEvent) {
            FocusScope.of(context).unfocus();
          },
          onChanged: (value) {
            _reviewEntryLogic.reviewEditModel =
                _reviewEntryLogic.reviewEditModel.copyWith(title: value);
          },
        ),
        TextField(
          controller: _category,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            hintText: "Category",
          ),
          onTapOutside: (PointerDownEvent pointerDownEvent) {
            FocusScope.of(context).unfocus();
          },
          onChanged: (value) {
            _reviewEntryLogic.reviewEditModel =
                _reviewEntryLogic.reviewEditModel.copyWith(category: value);
          },
        ),
        TextField(
          controller: _review,
          textInputAction: TextInputAction.newline,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: const InputDecoration(
            hintText: "Review",
          ),
          onTapOutside: (PointerDownEvent pointerDownEvent) {
            FocusScope.of(context).unfocus();
          },
          onChanged: (value) {
            _reviewEntryLogic.reviewEditModel =
                _reviewEntryLogic.reviewEditModel.copyWith(review: value);
          },
        ),
      ],
    );
  }
}
