import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pharmacy_finder/services/marker_service.dart';
import 'package:provider/provider.dart';

import '../blocs/application_bloc.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    final markerService = MarkerService();

    var markers = markerService.getMarkers(applicationBloc.pharmacies);
    return SafeArea(
      child: Scaffold(
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
              target: LatLng(
                  applicationBloc.cityLocation!.geometry.location.lat,
                  applicationBloc.cityLocation!.geometry.location.lng),
              zoom: 14.5),
          zoomGesturesEnabled: true,
          markers: Set<Marker>.of(markers),
        ),
      ),
    );
  }
}
