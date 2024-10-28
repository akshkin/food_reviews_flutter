import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:food_reviews/helper/themes.dart';
import 'package:food_reviews/widget/muted_text.dart';
import 'package:geolocator/geolocator.dart';

import 'package:food_reviews/logic/review_entry_logic.dart';
import 'package:latlong2/latlong.dart';

class ReviewEntryEditPlacemarkMap extends StatelessWidget {
  const ReviewEntryEditPlacemarkMap({
    super.key,
    required ReviewEntryLogic reviewEntryLogic,
    required ValueNotifier<Position> positonNotifier,
    required MapController mapController,
    required ValueNotifier<bool> showProgressIndicatorLocationNotifier,
  })  : _reviewEntryLogic = reviewEntryLogic,
        _positonNotifier = positonNotifier,
        _mapController = mapController,
        _showProgressIndicatorLocationNotifier =
            showProgressIndicatorLocationNotifier;

  final ReviewEntryLogic _reviewEntryLogic;
  final ValueNotifier<Position> _positonNotifier;
  final MapController _mapController;
  final ValueNotifier<bool> _showProgressIndicatorLocationNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _positonNotifier,
      builder: (BuildContext context, Position position, Widget? widget) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location placemark
            Wrap(
              alignment: WrapAlignment.start,
              children: [
                MutedText(
                    "${_reviewEntryLogic.reviewEditModel.locationPlacemark.street} "),
                MutedText(
                    "${_reviewEntryLogic.reviewEditModel.locationPlacemark.locality} "),
                MutedText(
                    "${_reviewEntryLogic.reviewEditModel.locationPlacemark.administrativeArea} "),
                MutedText(
                    "${_reviewEntryLogic.reviewEditModel.locationPlacemark.postalCode} "),
                MutedText(_reviewEntryLogic
                    .reviewEditModel.locationPlacemark.country),
              ],
            ),
            // container for map
            SizedBox(
              height: 150,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // map
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.none,
                      ),
                      initialCenter: LatLng(
                        _reviewEntryLogic.reviewEditModel.location.latitude,
                        _reviewEntryLogic.reviewEditModel.location.latitude,
                      ),
                      initialZoom: 16,
                      maxZoom: 18,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: const ["map", "b", "c"],
                        userAgentPackageName: "com.example.app",
                        tileProvider: NetworkTileProvider(),
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(
                              _reviewEntryLogic
                                  .reviewEditModel.location.latitude,
                              _reviewEntryLogic
                                  .reviewEditModel.location.latitude,
                            ),
                            width: 80,
                            height: 80,
                            child: const Icon(
                              Icons.location_pin,
                              color: ThemeColors.locationPin,
                              size: 40,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  // progress indicator
                  ValueListenableBuilder(
                    valueListenable: _showProgressIndicatorLocationNotifier,
                    builder: (
                      BuildContext context,
                      bool show,
                      Widget? widget,
                    ) {
                      return Visibility(
                        visible: _showProgressIndicatorLocationNotifier.value,
                        child: Positioned(
                          child: Container(
                            color: ThemeColors.washedOutBlack,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // menu card
                  Positioned(
                    right: 8,
                    bottom: -28,
                    child: Card(
                      color: ThemeColors.washedOutWhite,
                      child: Row(
                        children: [
                          IconButton(
                            tooltip: "Replace location",
                            icon: const Icon(Icons.location_pin),
                            onPressed: () {
                              _showProgressIndicatorLocationNotifier.value =
                                  true;
                              _reviewEntryLogic
                                  .replaceLocation(context: context)
                                  .then((locationArguments) async {
                                if (locationArguments.answer == true) {
                                  _positonNotifier.value =
                                      locationArguments.position!;
                                  _mapController.move(
                                    LatLng(
                                        _reviewEntryLogic
                                            .reviewEditModel.location.latitude,
                                        _reviewEntryLogic
                                            .reviewEditModel.location.latitude),
                                    16,
                                  );
                                }
                              }).whenComplete(() =>
                                      _showProgressIndicatorLocationNotifier
                                          .value = false);
                            },
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            tooltip: "Delete location",
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _reviewEntryLogic
                                  .deleteLocation(context: context)
                                  .then(
                                (locationAruments) {
                                  if (locationAruments.answer == true) {
                                    _positonNotifier.value =
                                        locationAruments.position!;
                                    _mapController.move(
                                        const LatLng(0.0, 0.0), 16);
                                  }
                                },
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
