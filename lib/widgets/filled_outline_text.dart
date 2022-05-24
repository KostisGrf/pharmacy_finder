import 'package:flutter/material.dart';
import 'package:pharmacy_finder/blocs/application_bloc.dart';

class FilledOutlineText extends StatelessWidget {
  const FilledOutlineText({
    Key? key,
    required this.icon,
    required this.text,
    required this.color,
  }) : super(key: key);

  
  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 30,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(icon),
          Text(text),
        ],
      ),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(30.0)),
    );
  }
}
