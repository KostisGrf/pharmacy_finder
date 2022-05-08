import 'package:flutter/material.dart';
import 'package:pharmacy_finder/constraints.dart';
import 'package:provider/provider.dart';
import '../blocs/application_bloc.dart';
import 'package:pharmacy_finder/widgets/filled_outline_text.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({Key? key}) : super(key: key);

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
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
                              Navigator.pushNamed(context, '/details_screen',arguments: {
                                'index':index,
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
                                FilledOutlineText(
                                  applicationBloc: applicationBloc,
                                  index: index,
                                ),
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
          onPressed: () {},
          label: const Text("Map"),
          icon: const Icon(Icons.map_outlined),
          backgroundColor: Colors.green,
        ));
  }
}
