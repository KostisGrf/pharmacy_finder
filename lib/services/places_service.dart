import 'package:http/http.dart' as http;
import 'package:pharmacy_finder/services/geolocator_service.dart';
import 'dart:convert' as convert;
import '../models/place_search.dart';
import 'package:flutter_config/flutter_config.dart';
import '../models/place.dart';

class PlacesService {
  

  Future<List<PlaceSearch>> getAutoComplete(String? searchQuery) async {
    var url =
         "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchQuery&types=geocode&language=gr&key=${FlutterConfig.get('API_KEY')}";
    var response = await http.get(Uri.parse(url));
    var data = convert.jsonDecode(response.body);
    var results = data['predictions'] as List;
    return results.map((place) => PlaceSearch.fromJson(place)).toList();
  }

  Future<Place> getCityLocation(String placeId) async {
    var url =
       "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${FlutterConfig.get('API_KEY')}";
    var response = await http.get(Uri.parse(url));
    var data = convert.jsonDecode(response.body);
    var results = data['result'] as Map<dynamic, dynamic>;
    return Place.fromJson(results);
  }

  Future<List<Place>> getPharmacies(
      {required double lat, required double lng}) async {
    var url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&type=pharmacy&rankby=distance&key=${FlutterConfig.get('API_KEY')}";
    var url2 =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&type=drugstore&rankby=distance&key=${FlutterConfig.get('API_KEY')}";
    var response = await http.get(Uri.parse(url));
    var response2 = await http.get(Uri.parse(url2));
    var data = convert.jsonDecode(response.body);
    var data2 = convert.jsonDecode(response2.body);
    var results = data['results'] as List;
    var results2 = data2['results'] as List;
    results = [...results, ...results2].toSet().toList();
    for (var element in results) {
      element['phoneNumber'] = await getPhoneNumber(element['place_id']);
      element['distance'] = GeolocatorService().getDistance(
              lat,
              lng,
              element['geometry']['location']['lat'],
              element['geometry']['location']['lng']) /
          1000;
    }
    return results.map((place) => Place.fromJson(place)).toList();
  }

  Future<String?> getPhoneNumber(String placeId) async {
    var url =
        "https://maps.googleapis.com/maps/api/place/details/json?fields=formatted_phone_number&place_id=$placeId&key=${FlutterConfig.get('API_KEY')}";
    var response = await http.get(Uri.parse(url));
    var data = convert.jsonDecode(response.body);
    var result = data['result']['formatted_phone_number'];
    return result;
  }
}
