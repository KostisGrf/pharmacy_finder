import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pharmacy_finder/models/geometry.dart';
import 'package:pharmacy_finder/models/location.dart';
import 'package:pharmacy_finder/services/on_duty_service.dart';
import '../models/place_search.dart';
import '../services/geolocator_service.dart';
import '../services/places_service.dart';
import '../models/place.dart';

class ApplicationBloc extends ChangeNotifier {
  final placesService = PlacesService();
  final geoLocatorService = GeolocatorService();
  final onDutyService = OnDutyService();

  Position? currentLocation;
  List<PlaceSearch> searchResults = [];
  Place? cityLocation;
  List<Place> pharmacies = [];
  List<Place> allPharmacies = [];
  bool searchWithCurrent = false;

  String selectedChip = "All";

  ApplicationBloc();

  searchPlaces(String? searchQuery) async {
    searchResults = await placesService.getAutoComplete(searchQuery);
    if (searchQuery == null) {
      searchResults = [];
    }
    notifyListeners();
  }

  setCityLocation(String placeId) async {
    cityLocation = await placesService.getCityLocation(placeId);
    searchResults = [];
    selectedChip = "All";
    notifyListeners();
  }

  setCurrentLocation() async {
    currentLocation = await geoLocatorService.getLocation();
    selectedChip = "All";
    cityLocation = Place(
      name: '',
      openNow: false,
      rating: null,
      userRatingCount: null,
      vicinity: '',
      distance: null,
      phoneNumber: '',
      image: '',
      geometry: Geometry(
          location:
              Location(currentLocation!.latitude, currentLocation!.longitude)),
    );
    notifyListeners();
  }

  setPharmacies({required double lat, required double lng}) async {
    allPharmacies = await placesService.getPharmacies(lat: lat, lng: lng);
    allPharmacies.sort((a, b) => a.distance!.compareTo(b.distance as num));
    List<dynamic> onDutyPharmacies = await onDutyService.getPharmacyDuties(
        lat: cityLocation!.geometry.location.lat,
        lng: cityLocation!.geometry.location.lng);
    List onDuty = [];
    List onDutyNow = [];
    for (var element in onDutyPharmacies) {
      onDuty.add(element['phone']);
      if (element['onDutyNow']) {
        onDutyNow.add(element['phone']);
      }
    }
    for (var element in allPharmacies) {
      element.onDuty = onDuty.contains(element.phoneNumber);
      element.openNow = onDutyNow.contains(element.phoneNumber);
      element.onDutyNow = onDutyNow.contains(element.phoneNumber);
    }
    pharmacies = allPharmacies;
    notifyListeners();
  }

  toggleChoiceChip(String value) async {
    selectedChip = value;

    if (selectedChip == "All") {
      pharmacies = allPharmacies;
    } else if (selectedChip == "Open") {
      pharmacies = allPharmacies.where((i) => i.openNow).toList();
    } else if (selectedChip == "On duty") {
      pharmacies = allPharmacies.where((i) => i.onDuty).toList();
    }
    notifyListeners();
  }

  setLocationPref(bool pref) {
    searchWithCurrent = pref;
    notifyListeners();
  }
}
