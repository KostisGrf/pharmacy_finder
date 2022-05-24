import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pharmacy_finder/constants.dart';
import 'package:provider/provider.dart';
import '../blocs/application_bloc.dart';
import 'package:pharmacy_finder/widgets/filled_outline_text.dart';
import 'package:pharmacy_finder/widgets/filled_outline_button.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({Key? key}) : super(key: key);

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Pharmacies"),
          backgroundColor: Colors.green,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 10,
                color: Colors.green,
                padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FillOutlineButton(
                      press: () {
                        applicationBloc.toggleChoiceChip("All");
                      },
                      text: "All",
                      isFilled: applicationBloc.selectedChip == "All",
                    ),
                    FillOutlineButton(
                      press: () {
                        applicationBloc.toggleChoiceChip("Open");
                      },
                      text: "Open",
                      isFilled: applicationBloc.selectedChip == "Open",
                    ),
                    FillOutlineButton(
                      press: () {
                        applicationBloc.toggleChoiceChip("On duty");
                      },
                      text: "On duty",
                      isFilled: applicationBloc.selectedChip == "On duty",
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Card(
                        child: ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, '/details_screen',
                                  arguments: {
                                    'index': index,
                                  });
                            },
                            title: Text(
                              applicationBloc.pharmacies[index].name,
                              style: const TextStyle(
                                fontSize: 22.0,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  applicationBloc.pharmacies[index].vicinity,
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 15.0),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    applicationBloc.pharmacies[index].openNow
                                        ? const FilledOutlineText(
                                            text: "Open",
                                            color: Colors.green,
                                            icon: Icons.access_time)
                                        : const FilledOutlineText(
                                            text: "Closed",
                                            color: Colors.red,
                                            icon: Icons.access_time,
                                          ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    if (applicationBloc
                                        .pharmacies[index].onDuty)
                                      const FilledOutlineText(
                                          text: "On duty",
                                          color: Colors.blue,
                                          icon: Icons.more_time)
                                  ],
                                )
                              ],
                            ),
                            trailing: (applicationBloc.searchWithCurrent)
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      applicationBloc.pharmacies[index]
                                                  .distance! >=
                                              1
                                          ? Text(
                                              "${applicationBloc.pharmacies[index].distance!.toStringAsFixed(2)}km",
                                              style: kDistanceText,
                                            )
                                          : Text(
                                              "${(applicationBloc.pharmacies[index].distance! * 1000).toInt()}m",
                                              style: kDistanceText),
                                    ],
                                  )
                                : Column()));
                  },
                  itemCount: applicationBloc.pharmacies.length,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, '/map_screen');
          },
          label: const Text("Map"),
          icon: const Icon(Icons.map_outlined),
          backgroundColor: Colors.green,
        ));
  }
}
