import 'dart:io';

import 'package:flutter/material.dart';

import '../../Models/car_model.dart';

class Viewpcscreen extends StatefulWidget {
  final Cars cars;
  const Viewpcscreen({required this.cars, super.key});

  @override
  State<Viewpcscreen> createState() => _ViewpcscreenState();
}

class _ViewpcscreenState extends State<Viewpcscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("POLUTION CERTIFICATE"),
      ),
      body: Center(
        child: Container(
          child: InteractiveViewer(
            child: Image(
              image: FileImage(File(widget.cars.pcImage)),
            ),
          ),
        ),
      ),
    );
  }
}
