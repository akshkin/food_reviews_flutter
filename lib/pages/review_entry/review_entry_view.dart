import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:food_reviews/helper/arguments.dart';
import 'package:food_reviews/helper/constants.dart';
import 'package:food_reviews/helper/format_dates.dart';
import 'package:food_reviews/helper/themes.dart';
import 'package:food_reviews/models/review_model.dart';
import 'package:food_reviews/pages/review_entry/review_entry_edit.dart';
import 'package:food_reviews/pages/review_entry/review_entry_photo_zoom.dart';
import 'package:food_reviews/widget/muted_text.dart';
import 'package:food_reviews/widget/star_rating.dart';
import 'package:latlong2/latlong.dart';

class ReviewEntryView extends StatelessWidget {
  const ReviewEntryView({super.key});

  static const String route = "/review_entry_view";

  @override
  Widget build(BuildContext context) {
    final ReviewEntryArguments reviewEntryArguments =
        ModalRoute.of(context)?.settings.arguments as ReviewEntryArguments;

    final ReviewModel reviewModel = reviewEntryArguments.reviewModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(reviewModel.category),
        actions: [
          IconButton(
              tooltip: "Edit Review",
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).popAndPushNamed(
                  ReviewEntryEdit.route,
                  arguments: ReviewEntryArguments(
                    reviewMode: ReviewMode.edit,
                    reviewModel: reviewModel,
                  ),
                );
              }),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                child: Hero(
                  tag: "${reviewModel.reviewDate}",
                  child: reviewModel.photo.isNotEmpty
                      ? Image.network(
                          reviewModel.photo,
                          fit: BoxFit.fitWidth,
                          loadingBuilder: (
                            BuildContext context,
                            Widget image,
                            ImageChunkEvent? loadingProcess,
                          ) {
                            if (loadingProcess == null) return image;
                            return Center(
                              child: CircularProgressIndicator(
                                  value: loadingProcess.expectedTotalBytes !=
                                          null
                                      ? loadingProcess.cumulativeBytesLoaded /
                                          loadingProcess.expectedTotalBytes!
                                      : null),
                            );
                          },
                        )
                      : const SizedBox(),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    ReviewEntryPhotoZoom.route,
                    arguments: ReviewEntryPhotoArguments(
                      reviewModel: reviewModel,
                    ),
                  );
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        reviewModel.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                        overflow:
                            kIsWeb ? TextOverflow.ellipsis : TextOverflow.fade,
                        softWrap: false,
                      ),
                    ),
                    const SizedBox(width: 16),
                    StarRating(
                      rating: reviewModel.rating,
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MutedText(reviewModel.restaurant),
                        MutedText(reviewModel.affordability)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MutedText(reviewModel.category),
                        MutedText(
                          FormatDates.dateFormatShortMonthDayYear(
                              "${reviewModel.reviewDate}"),
                        ),
                      ],
                    ),
                    const Divider(height: 26),
                    Text(reviewModel.review),
                    const Divider(height: 24),
                    Wrap(
                      children: [
                        MutedText(reviewModel.locationPlacemark.street),
                        MutedText(reviewModel.locationPlacemark.locality),
                        MutedText(
                            reviewModel.locationPlacemark.administrativeArea),
                        MutedText(reviewModel.locationPlacemark.postalCode),
                        MutedText(reviewModel.locationPlacemark.country),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 150,
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(
                            reviewModel.location.latitude,
                            reviewModel.location.latitude,
                          ),
                          initialZoom: 16,
                          maxZoom: 18,
                          interactionOptions: const InteractionOptions(
                            flags: InteractiveFlag.none,
                          ),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: const ["map", "b", "c"],
                            userAgentPackageName: "com.example.com",
                            tileProvider: NetworkTileProvider(),
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: LatLng(
                                  reviewModel.location.latitude,
                                  reviewModel.location.longitude,
                                ),
                                width: 80,
                                height: 80,
                                child: const Icon(
                                  Icons.location_pin,
                                  color: ThemeColors.locationPin,
                                  size: 40,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                mouseCursor: SystemMouseCursors.click,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
