import 'package:flutter/material.dart';
import '../models/location.dart';
import 'package:provider/provider.dart';
import '../blocs/application_bloc.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({Key? key}) : super(key: key);

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: Text("test")));
  }
}
