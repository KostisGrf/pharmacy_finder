import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pharmacy_finder/blocs/application_bloc.dart';
import 'package:pharmacy_finder/services/marker_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    final details = ModalRoute.of(context)!.settings.arguments as Map;
    final pharmacy = applicationBloc.pharmacies[details['index']];
    final markerService = MarkerService();
    var marker = markerService.getSingleMarker(pharmacy);

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            child: Container(
              width: double.maxFinite,
              height: height / 2.41,
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: pharmacy.image != null
                        ? NetworkImage(
                            "https://maps.googleapis.com/maps/api/place/photo?maxwidth=1000&photo_reference=${pharmacy.image}&key=${FlutterConfig.get('API_KEY')}")
                        : const AssetImage('assets/images/default_pharmacy.jpg')
                            as ImageProvider),
              ),
            ),
          ),
          Positioned.fill(
            left: 0,
            right: 0,
            top: (height / 2.41) - 20,
            child: Container(
              padding: EdgeInsets.only(
                  left: width / 20, right: width / 20, top: height / 20),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30)),
                  color: Colors.white),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pharmacy.name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.green.withOpacity(0.8),
                          size: 25.0,
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          pharmacy.vicinity,
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.6)),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    pharmacy.rating != null
                        ? Row(
                            children: [
                              RatingBar.builder(
                                initialRating: pharmacy.rating as double,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 25,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (double value) {},
                              ),
                              Text("(${pharmacy.rating})",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.4),
                                      fontSize: 16))
                            ],
                          )
                        : Row(),
                    SizedBox(
                      height: 40.0,
                    ),
                  ]),
            ),
          ),
          Positioned.fill(
            left: 0,
            right: 0,
            top: (height / 1.6),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(pharmacy.geometry.location.lat,
                      pharmacy.geometry.location.lng),
                  zoom: 16.0),
              zoomGesturesEnabled: true,
              markers: marker,
            ),
          )
        ],
      ),
    );
  }
}


//  Expanded(
//           child: GoogleMap(
//             initialCameraPosition: CameraPosition(
//                 target: LatLng(pharmacy.geometry.location.lat,
//                     pharmacy.geometry.location.lng),
//                 zoom: 16.0),
//             zoomGesturesEnabled: true,
//           ),
//         )