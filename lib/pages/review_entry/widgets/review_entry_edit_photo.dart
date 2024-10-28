import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_reviews/helper/constants.dart';
import 'package:food_reviews/helper/themes.dart';

import 'package:food_reviews/logic/review_entry_logic.dart';
import 'package:image_picker/image_picker.dart';

class ReviewEntryEditPhoto extends StatelessWidget {
  const ReviewEntryEditPhoto({
    super.key,
    required ReviewEntryLogic reviewEntryLogic,
    required ValueNotifier<String> photoNotifier,
  })  : _reviewEntryLogic = reviewEntryLogic,
        _photoNotifier = photoNotifier;

  final ReviewEntryLogic _reviewEntryLogic;
  final ValueNotifier<String> _photoNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _photoNotifier,
      builder: (BuildContext context, String photo, Widget? widget) {
        return _reviewEntryLogic.reviewEditModel.photo.isNotEmpty
            ? Stack(
                clipBehavior: Clip.none,
                children: [
                  Hero(
                      tag: "${_reviewEntryLogic.reviewEditModel.reviewDate}",
                      child: (_reviewEntryLogic.xFile != null && !kIsWeb)
                          ? Image.file(File(_reviewEntryLogic.xFile!.path))
                          : CachedNetworkImage(
                              imageUrl: _reviewEntryLogic.reviewEditModel.photo,
                              fit: BoxFit.fitWidth,
                              progressIndicatorBuilder: (
                                BuildContext context,
                                String url,
                                DownloadProgress downloadProgress,
                              ) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: downloadProgress.progress,
                                  ),
                                );
                              },
                              errorWidget: (
                                BuildContext context,
                                String url,
                                dynamic error,
                              ) =>
                                  const Icon(Icons.error),
                            )
                      // : Image.network(
                      //     _reviewEntryLogic.reviewEditModel.photo,
                      //     fit: BoxFit.fitWidth,
                      //     loadingBuilder: (
                      //       BuildContext context,
                      //       Widget image,
                      //       ImageChunkEvent? loadingProgress,
                      //     ) {
                      //       if (loadingProgress == null) return image;
                      //       return Center(
                      //         child: CircularProgressIndicator(
                      //           value: loadingProgress.expectedTotalBytes !=
                      //                   null
                      //               ? loadingProgress
                      //                       .cumulativeBytesLoaded /
                      //                   loadingProgress.expectedTotalBytes!
                      //               : null,
                      //           strokeWidth: 5,
                      //         ),
                      //       );
                      //     },
                      //   ),
                      ),
                  Positioned(
                    right: 8,
                    bottom: -28,
                    child: Card(
                      color: ThemeColors.washedOutWhite,
                      child: Row(
                        children: [
                          PopupMenuButton(
                            icon: const Icon(Icons.camera),
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            position: PopupMenuPosition.under,
                            tooltip: "Replace photo",
                            itemBuilder: (BuildContext context) => [
                              const PopupMenuItem<MenuItemsPhoto>(
                                value: MenuItemsPhoto.camera,
                                child: Row(
                                  children: [
                                    Icon(Icons.camera),
                                    SizedBox(width: 8),
                                    Text("Take a photo"),
                                  ],
                                ),
                              ),
                              const PopupMenuItem<MenuItemsPhoto>(
                                value: MenuItemsPhoto.gallery,
                                child: Row(
                                  children: [
                                    Icon(Icons.photo_album),
                                    SizedBox(width: 16),
                                    Text("Add from Photo Album"),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (selected) {
                              switch (selected) {
                                case MenuItemsPhoto.camera:
                                  _reviewEntryLogic
                                      .pickedImage(
                                          imageSource: ImageSource.camera)
                                      .then((photo) =>
                                          _photoNotifier.value = photo);
                                  break;
                                case MenuItemsPhoto.gallery:
                                  _reviewEntryLogic
                                      .pickedImage(
                                          imageSource: ImageSource.gallery)
                                      .then((photo) =>
                                          _photoNotifier.value = photo);
                                  break;
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            tooltip: "Delete photo",
                            onPressed: () {
                              _reviewEntryLogic.reviewEditModel =
                                  _reviewEntryLogic.reviewEditModel
                                      .copyWith(photo: "");
                              _photoNotifier.value =
                                  _reviewEntryLogic.reviewEditModel.photo;
                            },
                            icon: const Icon(Icons.delete),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            : Hero(
                tag: _reviewEntryLogic.reviewMode == ReviewMode.add
                    ? "addReviewEntry"
                    : "",
                child: PopupMenuButton(
                  icon: const Icon(Icons.add_a_photo_outlined),
                  position: PopupMenuPosition.under,
                  itemBuilder: (context) => [
                    const PopupMenuItem<MenuItemsPhoto>(
                      value: MenuItemsPhoto.camera,
                      child: Row(
                        children: [
                          Icon(Icons.photo_camera),
                          SizedBox(width: 8),
                          Text("Take a photo")
                        ],
                      ),
                    ),
                    const PopupMenuItem<MenuItemsPhoto>(
                      value: MenuItemsPhoto.gallery,
                      child: Row(
                        children: [
                          Icon(Icons.photo_library),
                          SizedBox(width: 8),
                          Text("Choose from gallery")
                        ],
                      ),
                    ),
                  ],
                  onSelected: (selected) {
                    switch (selected) {
                      case MenuItemsPhoto.camera:
                        _reviewEntryLogic
                            .pickedImage(imageSource: ImageSource.camera)
                            .then((photo) => _photoNotifier.value = photo);
                        break;
                      case MenuItemsPhoto.gallery:
                        _reviewEntryLogic
                            .pickedImage(imageSource: ImageSource.gallery)
                            .then((photo) => _photoNotifier.value = photo);
                        break;
                    }
                  },
                ),
              );
      },
    );
  }
}
