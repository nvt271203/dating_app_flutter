// import 'dart:ffi';

import 'package:chat_dating_app/models/Address.dart';
import 'package:chat_dating_app/screens/first_options/hoppy.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../tools/tools_colors.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key, required this.idPerson});

  final String idPerson;

  @override
  State<LocationScreen> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationScreen> {
  var _isGettingLocation = false;
  LatLng? _currentLatLng;
  Address? address;
  String _address = '';
  double? lat;
  double? lng;

  void _navigatorScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => HobbyScreen(
        idPerson: widget.idPerson,
        address: address!,
      ),
      // builder: (context) => LocationScreen(),
    ));
  }

  void _submit() {
    if (address == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vui lòng chọn địa chỉ của bạn nhé!')));
      return;
    }
    _navigatorScreen(context);
  }

  void _getCurrentLocation() async {
    loc.Location location = loc.Location();

    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;
    loc.LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
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

    lat = locationData.latitude as double?;
    lng = locationData.longitude as double?;

    if (lat == null || lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Latitude or longitude is null')),
      );
      return;
    }

    setState(() {
      _currentLatLng = LatLng(lat! as double, lng! as double);
    });

    await _getAddressFromNominatim(lat! as double, lng! as double);
  }

  Future<void> _getAddressFromNominatim(
      double latitude, double longitude) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=$latitude&lon=$longitude&format=json&addressdetails=1');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['address'] != null) {


          print('address${data['address']}');
          // print('display${data['display_name']}');
          // var address = data['address'];
          // String street = address['road'] ?? 'Unknown street';
          // String locality = address['city'] ?? address['town'] ?? address['village'] ?? 'Unknown locality';
          // String country = address['country'] ?? 'Unknown country';



          address = Address(
              road: data['address']['road'],
              quarter: data['address']['quarter'],
              suburb: data['address']['suburb'],
              city: data['address']['city'],
              lat: latitude,
              lng: longitude);

          setState(() {
              print('address${address.toString()}');
            // _address = '$street, $locality, $country';
            _address = data['display_name'];
            // print()
          });
        } else {
          print('No address found.');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    Widget previewContent = Padding(
      padding: EdgeInsets.all(24.0),
      child: Text(
        'Nhấn "Lấy vị trí" để cập nhật vị trí của bạn nhé.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: ToolsColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );

    if (_currentLatLng != null) {
      previewContent = FlutterMap(
        options: MapOptions(
          initialCenter: _currentLatLng!,
          initialZoom: 15.0,
          onTap: (tapPosition, point) {
            setState(() {
              _currentLatLng = point;
              print('point${_currentLatLng}');
              _getAddressFromNominatim(point.latitude, point.longitude);
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            additionalOptions: const {
              'attribution': '© OpenStreetMap contributors'
            },
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _currentLatLng!,
                width: 30,
                height: 30,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 30,
                ),
              ),
            ],
          ),
        ],
      );
    }

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Địa chỉ của bạn'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Vui lòng cho mình biết địa chỉ, để mọi người có thể tìm thấy bạn dễ hơn nhé !',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 10),
                      child: Container(
                        height: 170,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 1, color: ToolsColors.primary),
                          borderRadius: BorderRadius.circular(10),
                          color: ToolsColors.primary.withOpacity(0.2),
                        ),
                        child: previewContent,
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      decoration: BoxDecoration(
                        color: ToolsColors.primary,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: TextButton.icon(
                        onPressed: _getCurrentLocation,
                        icon: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Lấy vị trí',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (_currentLatLng != null && _address.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: ToolsColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text(
                              'Địa chỉ của bạn',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: ToolsColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              _address, // Hiển thị địa chỉ
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity, // Đặt chiều rộng full màn hình
                  decoration: BoxDecoration(
                      // color: Colors.teal.withOpacity(opacity)
                      ),
                  child: TextButton(
                    onPressed: () {
                      _submit();
                      // _navigatorPersonality(context);
                    },
                    child: Text(
                      'Tiếp tục',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: ToolsColors.primary, // Màu nền
                      padding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 24.0), // Padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0), // Bo viền
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
