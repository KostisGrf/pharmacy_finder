import 'package:flutter/material.dart';

import '../models/place_search.dart';
import '../services/places_service.dart';

class ApplicationBloc extends ChangeNotifier {
  final placesService = PlacesService();

  List<PlaceSearch> searchResults = [];

  ApplicationBloc();

  searchPlaces(String searchQuery) async {
    searchResults = await placesService.getAutoComplete(searchQuery);
    notifyListeners();
  }
}
