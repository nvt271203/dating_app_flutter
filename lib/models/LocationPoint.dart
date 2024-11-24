// import 'package:chat_dating_app/models/Person.dart';
// import 'package:latlong2/latlong.dart';
//
// class LocationPoint {
//   Person person;
//   LatLng? _latLng;
//   double lat;
//   double lng;
//
//   LocationPoint({required this.person, required this.lat, required this.lng});
//   // Setter
//   set latLng(LatLng? value) {
//     _latLng = new LatLng(lat, lng); // Gán giá trị cho _latLng
//   }
// }
import 'package:chat_dating_app/models/Person.dart';
import 'package:latlong2/latlong.dart';

class LocationPoint {
  Person person;
  LatLng latLng;


  LocationPoint({required this.person, required this.latLng});
}