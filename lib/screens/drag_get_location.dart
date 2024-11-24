import 'package:chat_dating_app/models/PlaceLocation.dart';
import 'package:chat_dating_app/tools/tools_colors.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class DragGetLocationScreen extends StatefulWidget {
  const DragGetLocationScreen({super.key});

  @override
  State<DragGetLocationScreen> createState() => _LocationInputState();
}

class _LocationInputState extends State<DragGetLocationScreen> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;
  String get locationImage {
    if(_pickedLocation == null){
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center$lat,$lng=&zoom=16&size=600x300&maptype=roadmap &markers=color:red%7Clabel:S%7C40.702147,-74.015794&markers=color:green%7Clabel:G%7C40.711614,-74.012318 &markers=color:red%7Clabel:C%7C$lat,$lng &key=AIzaSyDNjq11hvjAi0NTVjoylbXOEdb4Rtu14fc';
  }


  void _getCurrentLocation() async {

    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Clicked')));

    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();

    setState(() {
      _isGettingLocation = false;
    });

    print(locationData.latitude);
    print(locationData.longitude);
    final lat = locationData.latitude;
    final lng = locationData.longitude;
    if (lat == null || lng ==  null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('lat null or lng null')));
      return;
    }

    final url = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyDNjq11hvjAi0NTVjoylbXOEdb4Rtu14fc');
    final response = await http.get(url);
    final resData = json.decode(response.body);

    if (resData['results'] == null || resData['results'].isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không tìm thấy địa chỉ cho tọa độ này.')),
      );
      return;
    }
    final address = resData['results'][0]['formatted_address'];

    // final address = resData['results'][0]['formatted_address'];
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('diachi: ${address}')));

    setState(() {
      _pickedLocation = PlaceLocation(latitude: lat, longitude: lng, address: address);
      _isGettingLocation = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    Widget previewContent = const Text('No location Selcted', style: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
        fontSize: 16
    ),);

    if(_pickedLocation != null){
      previewContent = Image.network(locationImage, fit: BoxFit.cover,width: double.infinity,height: double.infinity);
    }

    // Nếu trạng thái true thì cho hiện thanh tiến trình như đang xử lý.
    if (_isGettingLocation){
      previewContent = const CircularProgressIndicator();
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Container(
            height: 170,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: ToolsColors.primary),
                borderRadius: BorderRadius.circular(10)
            ),
            child: previewContent,
          ),
        ),
        Row(
          children: [
            TextButton.icon(onPressed: _getCurrentLocation,
              icon: Icon(Icons.location_on),
              label: Text('Get current location'),),
            TextButton.icon(onPressed: () {},
              icon: Icon(Icons.map),
              label: Text('Select location on map'),)
          ],
        )
      ],
    );
  }
}

