import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  Future<Position> getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  double getDistance(double startLatitude, double startLongitude, double endLatitude, double endLongitude)  {
   return Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);
  }
}
