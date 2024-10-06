import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_reviews/helper/arguments.dart';
import 'package:food_reviews/helper/constants.dart';
import 'package:food_reviews/helper/format_dates.dart';
import 'package:food_reviews/models/review_model.dart';
import 'package:food_reviews/services/database_service.dart';
import 'package:food_reviews/services/location_service.dart';
import 'package:food_reviews/widget/dialogs.dart';
import 'package:geocode/geocode.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class ReviewEntryLogic {
  ReviewEntryLogic({required this.reviewOriginalModel});

  // public
  final ReviewModel reviewOriginalModel;
  late ReviewModel reviewEditModel;
  late ReviewMode reviewMode;
  late Affordability affordability;
  XFile? xFile;

  ValueNotifier<Position> initializePositionDefaults() {
    return ValueNotifier<Position>(
      Position(
        longitude: 0.0,
        latitude: 0.0,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        altitudeAccuracy: 0.0,
        heading: 0.0,
        headingAccuracy: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      ),
    );
  }

  Future<Position> getLocation() async {
    Position position = await LocationService.getLocation();
    if (kIsWeb) {
      Address address = await LocationService.getReverseGeocodingWeb(position);
      setLocationAndAddressWeb(position: position, address: address);
    } else {
      Placemark placemark =
          await LocationService.getReverseGeocodingMobile(position);
      setLocationAndAddressMobile(position: position, placemark: placemark);
    }

    return position;
  }

  Future<LocationArguments> replaceLocation({required BuildContext context}) {
    return Dialogs.showAlertDialog(
      context: context,
      title: "Change Location",
      contentDescription: "Would you like to retrieve a new location?",
      noButtonTitle: "No",
      yesButtonTitle: "Yes",
    ).then((answer) async {
      if (answer == true) {
        Position position = await getLocation();
        return LocationArguments(answer: true, position: position);
      } else {
        return LocationArguments(answer: false);
      }
    });
  }

  Future<LocationArguments> deleteLocation({required BuildContext context}) {
    return Dialogs.showAlertDialog(
      context: context,
      title: "Remove location",
      contentDescription: "Would you like to remove location?",
      noButtonTitle: "No",
      yesButtonTitle: "Yes",
    ).then((answer) {
      if (answer == true) {
        reviewEditModel = reviewEditModel.copyWith(
          location: reviewEditModel.location.copyWith(
            latitude: 0.0,
            longitude: 0.0,
          ),
          locationPlacemark: reviewEditModel.locationPlacemark.copyWith(
            administrativeArea: "",
            country: "",
            isoCountryCode: "",
            name: "",
            postalCode: "",
            street: "",
            locality: "",
            subLocality: "",
            subAdministrativeArea: "",
            subThoroughFare: "",
            thoroughFare: "",
          ),
        );
        Position position = Position(
          longitude: 0.0,
          latitude: 0.0,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          altitudeAccuracy: 0.0,
          heading: 0.0,
          headingAccuracy: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
        );

        return LocationArguments(answer: true, position: position);
      } else {
        return LocationArguments(answer: false);
      }
    });
  }

  // called by get location method
  void setLocationAndAddressWeb({
    required Position position,
    required Address address,
  }) {
    reviewEditModel = reviewEditModel.copyWith(
        location: reviewOriginalModel.location.copyWith(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
        locationPlacemark: reviewEditModel.locationPlacemark.copyWith(
          administrativeArea: address.city,
          country: address.countryName,
          isoCountryCode: address.countryCode,
          name: address.streetNumber == null ? "" : "${address.streetNumber}",
          postalCode: address.postal,
          street: address.streetAddress,
        ));
  }

  void setLocationAndAddressMobile({
    required Position position,
    required Placemark placemark,
  }) {
    reviewEditModel = reviewEditModel.copyWith(
        location: reviewOriginalModel.location.copyWith(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
        locationPlacemark: reviewEditModel.locationPlacemark.copyWith(
          administrativeArea: placemark.administrativeArea,
          country: placemark.country,
          isoCountryCode: placemark.isoCountryCode,
          name: placemark.name,
          postalCode: placemark.postalCode,
          street: placemark.thoroughfare,
        ));
  }

  bool checkIfDataChanged() {
    if (reviewOriginalModel == reviewEditModel) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> saveReview() {
    // check if user changed photo when editing
    bool isPhotoChanged =
        reviewOriginalModel.photo != reviewEditModel.photo ? true : false;

    if (reviewMode == ReviewMode.edit) {
      if (checkIfDataChanged()) {
        return DatabaseService.updateReview(
                isPhotoChanged: isPhotoChanged,
                originalPhotoUrl: reviewOriginalModel.photo,
                reviewEditModel: reviewEditModel,
                file: xFile)
            .then((value) => true)
            .onError((error, stackTrace) => false);
      } else {
        // data did not change, close the page
        return Future.value(true);
      }
    } else if (reviewMode == ReviewMode.add) {
      return DatabaseService.addReview(
        reviewModel: reviewEditModel,
        file: xFile,
      ).then((value) => true).onError((error, stackTrace) => false);
    } else {
      return Future.value(false);
    }
  }

  Future<bool> cancelEditingReview({required BuildContext context}) async {
    // check if any changes were made
    // if no changes have been made, allow to close the page
    if (reviewOriginalModel == reviewEditModel) {
      return true;
    }

    return Dialogs.showAlertDialog(
            context: context,
            title: "Cancel saving?",
            contentDescription: "Would you like to cancel saving",
            noButtonTitle: "No",
            yesButtonTitle: "Yes")
        .then((answer) => answer == true ? true : false);
  }

  Future<bool> deleteReview({required BuildContext context}) async {
    return Dialogs.showAlertDialog(
            context: context,
            title: "Delete Review?",
            contentDescription: "Are you sure you want to delete this review?",
            noButtonTitle: "No",
            yesButtonTitle: "Yes")
        .then((answer) {
      if (answer == true) {
        return DatabaseService.deleteReview(reviewOriginalModel)
            .then((value) => true)
            .onError((error, stackTrace) => false);
      } else {
        return false;
      }
    });
  }

  Future<String> selectDate({required BuildContext context}) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      keyboardType: TextInputType.datetime,
      initialDatePickerMode: DatePickerMode.day,
      initialDate: reviewEditModel.reviewDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    );
    if (pickedDate != null) {
      final DateTime selectedDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        reviewEditModel.reviewDate.hour,
        reviewEditModel.reviewDate.minute,
        reviewEditModel.reviewDate.second,
        reviewEditModel.reviewDate.millisecond,
        reviewEditModel.reviewDate.microsecond,
      );
      reviewEditModel = reviewEditModel.copyWith(reviewDate: selectedDate);

      return FormatDates.dateFormatShortMonthDayYear(
          "${reviewEditModel.reviewDate}");
    } else {
      return "";
    }
  }

  Future<String> pickedImage({
    ImageSource imageSource = ImageSource.gallery,
  }) async {
    final ImagePicker imagePicker = ImagePicker();
    xFile = await imagePicker.pickImage(source: imageSource);

    // update the page with the newly picked image, it will be saved later
    reviewEditModel = reviewEditModel.copyWith(photo: xFile?.path);
    return reviewEditModel.photo;
  }
}
