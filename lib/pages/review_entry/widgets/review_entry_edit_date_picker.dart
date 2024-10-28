import 'package:flutter/material.dart';
import 'package:food_reviews/helper/format_dates.dart';

import 'package:food_reviews/logic/review_entry_logic.dart';

class ReviewEntryEditDatePicker extends StatelessWidget {
  const ReviewEntryEditDatePicker({
    super.key,
    required ReviewEntryLogic reviewEntryLogic,
    required TextEditingController date,
    required ValueNotifier<String> reviewDateNotifier,
  })  : _reviewEntryLogic = reviewEntryLogic,
        _date = date,
        _reviewDateNotifier = reviewDateNotifier;

  final ReviewEntryLogic _reviewEntryLogic;
  final TextEditingController _date;
  final ValueNotifier<String> _reviewDateNotifier;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style:
          const ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.zero)),
      onPressed: () {
        _reviewEntryLogic.selectDate(context: context).then((selectedDate) {
          if (selectedDate.isNotEmpty) {
            _date.text = selectedDate;
            _reviewDateNotifier.value = selectedDate;
          }
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.calendar_today),
          const SizedBox(width: 16),
          ValueListenableBuilder(
            valueListenable: _reviewDateNotifier,
            builder: (BuildContext context, String url, Widget? widget) {
              return Text(
                FormatDates.dateFormatShortMonthDayYear(
                    "${_reviewEntryLogic.reviewEditModel.reviewDate}"),
                style: Theme.of(context).textTheme.bodyLarge,
              );
            },
          ),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}
