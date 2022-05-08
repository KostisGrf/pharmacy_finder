import 'package:flutter/material.dart';
import 'package:pharmacy_finder/blocs/application_bloc.dart';

class FilledOutlineText extends StatelessWidget {
  const FilledOutlineText({
    Key? key,
    required this.applicationBloc, required this.index,
  }) : super(key: key);

  final ApplicationBloc applicationBloc;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 30,
      alignment: Alignment.center,
      child: (applicationBloc
              .pharmacies[index].openNow)
          ? Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(Icons.access_time),
                Text(
                  "Open",
                ),
              ],
            )
          : Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
              children: const [
                  Icon(Icons.access_time),
                  Text("Closed"),
                ]),
      decoration: BoxDecoration(
          color: applicationBloc
                  .pharmacies[index].openNow
              ? Colors.green[400]
              : Colors.red,
          borderRadius:
              BorderRadius.circular(30.0)),
    );
  }
}