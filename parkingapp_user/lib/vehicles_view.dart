import 'package:flutter/material.dart';

class VehiclesView extends StatelessWidget {
  const VehiclesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: const Text("Fordon", style: TextStyle(fontWeight: FontWeight.bold))
    );
  }
}