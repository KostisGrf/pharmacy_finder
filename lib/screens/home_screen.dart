import 'package:flutter/material.dart';
import 'package:pharmacy_finder/screens/results_screen.dart';
import 'package:provider/provider.dart';
import '../blocs/application_bloc.dart';
import '../models/location.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:loader_overlay/loader_overlay.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  mapPharmacies(BuildContext context, applicationBloc) async {
    await Provider.of<ApplicationBloc>(context, listen: false).setPharmacies(
        lat: applicationBloc.cityLocation.geometry.location.lat,
        lng: applicationBloc.cityLocation.geometry.location.lng);
  }

  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext mainContext) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LoaderOverlay(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/images/pharmacy.png'),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                  Colors.grey.withOpacity(0.6), BlendMode.dstOver),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Pharmacy Finder",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'SquarePeg',
                      fontSize: 60.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 30.0,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: TextField(
                    controller: _textEditingController,
                    onChanged: (value) {
                      Provider.of<ApplicationBloc>(context, listen: false)
                          .searchPlaces(value);
                    },
                    decoration: InputDecoration(
                      hintText: "Search Location",
                      contentPadding: const EdgeInsets.all(10.0),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none),
                    ),
                  ),
                ),
                Stack(
                  children: [
                    Column(
                      children: [
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(children: <Widget>[
                          Expanded(
                            child: Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                child: const Divider(
                                  color: Colors.black,
                                  height: 36,
                                  thickness: 2.0,
                                )),
                          ),
                          const Text("OR"),
                          Expanded(
                            child: Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                child: const Divider(
                                  color: Colors.black,
                                  height: 36,
                                  thickness: 2.0,
                                )),
                          ),
                        ]),
                        const SizedBox(
                          height: 20.0,
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 25.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              )),
                          onPressed: () async {
                            context.loaderOverlay.show();
                            applicationBloc.setLocationPref(true);
                            await Provider.of<ApplicationBloc>(context,
                                    listen: false)
                                .setCurrentLocation();

                            await mapPharmacies(context, applicationBloc);
                            context.loaderOverlay.hide();
                            Navigator.pushNamed(mainContext, '/results_screen');
                          },
                          icon: const Icon(
                            // FontAwesomeIcons.locationArrow,
                            Icons.room,
                            size: 24.0,
                            color: Colors.black,
                          ),
                          label: const Text(
                            'Near me',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (applicationBloc.searchResults.isNotEmpty)
                      Column(
                        children: [
                          const SizedBox(
                            height: 5.0,
                          ),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(20.0),
                              height: 250,
                              width: MediaQuery.of(context).size.width / 1.2,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: ListView.separated(
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                        onTap: () async {
                                          _textEditingController.clear();
                                          mainContext.loaderOverlay.show();
                                          applicationBloc
                                              .setLocationPref(false);
                                          await Provider.of<ApplicationBloc>(
                                                  context,
                                                  listen: false)
                                              .setCityLocation(applicationBloc
                                                  .searchResults[index]
                                                  .placeId);
                                          await mapPharmacies(
                                              context, applicationBloc);
                                          mainContext.loaderOverlay.hide();
                                          Navigator.pushNamed(
                                              mainContext, '/results_screen');
                                        },
                                        title: Text(
                                          applicationBloc
                                              .searchResults[index].description,
                                          style: const TextStyle(fontSize: 18),
                                        ));
                                  },
                                  separatorBuilder: (context, index) {
                                    return const Divider(
                                      color: Colors.grey,
                                      thickness: 2.0,
                                    );
                                  },
                                  itemCount:
                                      applicationBloc.searchResults.length),
                            ),
                          ),
                        ],
                      )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
