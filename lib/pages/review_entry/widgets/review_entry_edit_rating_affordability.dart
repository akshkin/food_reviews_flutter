import 'package:flutter/material.dart';

import 'package:food_reviews/helper/constants.dart';
import 'package:food_reviews/logic/review_entry_logic.dart';
import 'package:food_reviews/widget/star_rating.dart';

class ReviewEntryEditRatingAffordability extends StatelessWidget {
  const ReviewEntryEditRatingAffordability({
    super.key,
    required ReviewEntryLogic reviewEntryLogic,
    required ValueNotifier<double> ratingNotifier,
    required ValueNotifier<Affordability> affordabilityNotifier,
  })  : _reviewEntryLogic = reviewEntryLogic,
        _ratingNotifier = ratingNotifier,
        _affordabilityNotifier = affordabilityNotifier;

  final ReviewEntryLogic _reviewEntryLogic;
  final ValueNotifier<double> _ratingNotifier;
  final ValueNotifier<Affordability> _affordabilityNotifier;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ValueListenableBuilder(
          valueListenable: _ratingNotifier,
          builder: (
            BuildContext context,
            double rating,
            Widget? widget,
          ) {
            return StarRating(
              rating: _reviewEntryLogic.reviewEditModel.rating,
              ratingMaximum: 5,
              halfRatingAllowed: true,
              iconFull: const Icon(Icons.star),
              iconHalf: const Icon(Icons.star_half_outlined),
              ratingChangedCallback: (ratingSelected) {
                _reviewEntryLogic.reviewEditModel = _reviewEntryLogic
                    .reviewEditModel
                    .copyWith(rating: ratingSelected);
                _ratingNotifier.value =
                    _reviewEntryLogic.reviewEditModel.rating;
              },
            );
          },
        ),
        ValueListenableBuilder(
          valueListenable: _affordabilityNotifier,
          builder: (BuildContext context, Affordability affordability,
              Widget? widget) {
            return Flexible(
              child: SegmentedButton<Affordability>(
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  side: WidgetStatePropertyAll(
                    BorderSide(
                      color: Theme.of(context).splashColor,
                      strokeAlign: -8,
                    ),
                  ),
                ),
                showSelectedIcon: false,
                segments: <ButtonSegment<Affordability>>[
                  ButtonSegment<Affordability>(
                    value: Affordability.$,
                    label: Text(Affordability.$.name),
                  ),
                  ButtonSegment<Affordability>(
                    value: Affordability.$$,
                    label: Text(Affordability.$$.name),
                  ),
                  ButtonSegment<Affordability>(
                    value: Affordability.$$$,
                    label: Text(Affordability.$$$.name),
                  ),
                  ButtonSegment<Affordability>(
                    value: Affordability.$$$$,
                    label: Text(Affordability.$$$$.name),
                  ),
                ],
                selected: <Affordability>{_reviewEntryLogic.affordability},
                onSelectionChanged: (Set<Affordability> newSelection) {
                  // by default there is only a single segment that can be selected
                  // at a time, so its value is always the first item
                  // in the selected set
                  _reviewEntryLogic.affordability = newSelection.first;
                  _reviewEntryLogic.reviewEditModel = _reviewEntryLogic
                      .reviewEditModel
                      .copyWith(affordability: newSelection.first.name);
                  _affordabilityNotifier.value = newSelection.first;
                },
              ),
            );
          },
        )
      ],
    );
  }
}
