import 'package:food_reviews/helper/location_api_key.dart';
import 'package:geocode/geocode.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Position> getLocation() async {
    Position currentPosition = await _determinePosition();
    return currentPosition;
  }

  static Future<Address> getReverseGeocodingWeb(Position position) async {
    GeoCode geocode = GeoCode(apiKey: LocationApiKey.geocodeApiKey);
    final address = await geocode.reverseGeocoding(
      latitude: position.latitude,
      longitude: position.longitude,
    );
    return address;
  }

  static Future<Placemark> getReverseGeocodingMobile(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    return place;
  }

  static Future<Position> _determinePosition() async {
    // test if location is enabled
    bool isServiceEnalbed = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnalbed) {
      return Future.error("Location services are disabled");
    }
    LocationPermission permisson = await Geolocator.checkPermission();
    if (permisson == LocationPermission.denied) {
      permisson = await Geolocator.requestPermission();
      if (permisson == LocationPermission.denied) {
        return Future.error("Location permissions are denied");
      }
    }
    if (permisson == LocationPermission.deniedForever) {
      return Future.error("""Location permissions are permanently denied.
    We cannot request permissons.""");
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }
}
