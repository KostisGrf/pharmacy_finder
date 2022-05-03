import 'package:flutter/material.dart';
import 'package:pharmacy_finder/models/location.dart';
import '../models/place_search.dart';
import '../services/places_service.dart';


class ApplicationBloc extends ChangeNotifier {
  final placesService = PlacesService();

  List<PlaceSearch> searchResults = [];
  Location? cityLocation;

  ApplicationBloc();

  searchPlaces(String searchQuery) async {
    searchResults = await placesService.getAutoComplete(searchQuery);
    notifyListeners();
  }

  setCityLocation(String placeId) async {
    cityLocation = await placesService.getCityLocation(placeId);
    notifyListeners();
  }
}
