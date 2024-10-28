import 'package:flutter/material.dart';
import 'package:food_reviews/helper/constants.dart';
import 'package:food_reviews/logic/review_entry_logic.dart';

class ReviewEntryEditAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  const ReviewEntryEditAppbar({
    super.key,
    required ReviewEntryLogic reviewEntryLogic,
    required ValueNotifier<bool> showProgressIndicatorSaveNotofier,
  })  : _reviewEntryLogic = reviewEntryLogic,
        _showProgressIndicatorSaveNotofier = showProgressIndicatorSaveNotofier;

  final ReviewEntryLogic _reviewEntryLogic;
  final ValueNotifier<bool> _showProgressIndicatorSaveNotofier;

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: ValueListenableBuilder(
          valueListenable: _showProgressIndicatorSaveNotofier,
          builder: (BuildContext context, bool show, Widget? widget) {
            return Stack(
              children: [
                Visibility(
                  visible: !_showProgressIndicatorSaveNotofier.value,
                  child: Text(
                    _reviewEntryLogic.reviewMode == ReviewMode.add
                        ? "Add review"
                        : "Edit review",
                  ),
                ),
                Visibility(
                  visible: _showProgressIndicatorSaveNotofier.value,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              ],
            );
          }),
      leading: IconButton(
        tooltip: "Cancel editing Review",
        onPressed: () {
          _reviewEntryLogic
              .cancelEditingReview(context: context)
              .then((cancel) {
            if (cancel == true) {
              Navigator.of(context).pop();
            }
          });
        },
        icon: const Icon(
          Icons.cancel_outlined,
        ),
      ),
      actions: [
        _reviewEntryLogic.reviewMode == ReviewMode.edit
            ? IconButton(
                tooltip: "Delete review",
                onPressed: () {
                  _reviewEntryLogic
                      .deleteReview(context: context)
                      .then((delete) {
                    if (delete == true) {
                      Navigator.of(context).pop();
                    }
                  });
                },
                icon: const Icon(Icons.delete),
              )
            : const SizedBox(),
        IconButton(
          tooltip: "Save review",
          icon: const Icon(Icons.save_outlined),
          onPressed: () {
            _showProgressIndicatorSaveNotofier.value = true;
            _reviewEntryLogic.saveReview().then((success) {
              if (success == true) {
                Navigator.of(context).pop();
              }
            }).whenComplete(
                () => _showProgressIndicatorSaveNotofier.value = false);
          },
        )
      ],
    );
  }
}
