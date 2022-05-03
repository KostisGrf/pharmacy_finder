import 'package:http/http.dart' as http;
import 'package:pharmacy_finder/models/location.dart';
import 'dart:convert' as convert;
import '../models/place_search.dart';
import 'package:flutter_config/flutter_config.dart';

class PlacesService {
  Future<List<PlaceSearch>> getAutoComplete(String searchQuery) async {
    var url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchQuery&types=geocode&language=gr&key=${FlutterConfig.get('API_KEY')}";
    var response = await http.get(Uri.parse(url));
    var data = convert.jsonDecode(response.body);
    var results = data['predictions'] as List;
    return results.map((place) => PlaceSearch.fromJson(place)).toList();
  }

  Future<Location> getCityLocation(String placeId) async {
    var url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${FlutterConfig.get('API_KEY')}";
    var response = await http.get(Uri.parse(url));
    var data = convert.jsonDecode(response.body);
    var results = data['result'] as Map<dynamic, dynamic>;
    return Location.fromJson(results);
  }
}
