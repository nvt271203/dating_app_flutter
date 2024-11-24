import 'package:chat_dating_app/widgets/location_input.dart';
import 'package:flutter/material.dart';
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Địa chỉ của bạn'),
      ),
      body: const Column(
        children: [
          // Text('Map'),
          // LocationInput()
        ],
      ),
    );
  }
}
