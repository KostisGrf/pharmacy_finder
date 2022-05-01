class PlaceSearch {
  final String placeId;
  final String description;

  PlaceSearch({required this.placeId, required this.description});

  factory PlaceSearch.fromJson(Map<String, dynamic> json) {
    return PlaceSearch(
        placeId: json['place_id'], description: json['description']);
  }
}
