import 'package:chat_dating_app/models/Address.dart';
import 'package:chat_dating_app/models/LocationPoint.dart';
import 'package:chat_dating_app/models/Person.dart';
import 'package:chat_dating_app/tools/tools_colors.dart';
import 'package:chat_dating_app/widgets/item_detail_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class WorldScreen extends StatefulWidget {
  const WorldScreen({super.key});

  @override
  State<WorldScreen> createState() => _WorldScreenState();
}

class _WorldScreenState extends State<WorldScreen> {
  late String idPersonCurrent;
  late Person personCurrent;
  bool isLoading = true;
  // Danh sách marker
  final List<Marker> _markers = [];
  // Danh sách tọa độ mẫu cho các marker

  @override
  void initState() {
    super.initState();
    // _initializeMarkers(); // Thêm marker ngay khi khởi tạo




    idPersonCurrent = FirebaseAuth.instance.currentUser!.uid;

    final userReference = FirebaseFirestore.instance
        .collection('users')
        .doc(idPersonCurrent)
        .snapshots();

    userReference.listen((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
          // Chuyển đổi snapshot thành Person
          personCurrent = Person.fromMap(snapshot.data()!); // Sử dụng phương thức fromMap để khởi tạo đối tượng Person
          print('person: ${snapshot.data()}');
          print('person: ${personCurrent.address?.toMap()}');
          print('person: ${personCurrent.address?.lat}');
          print('person: ${personCurrent.address?.lng}');
          print('person: ${personCurrent.address!.city}');


          // Sau khi đã có thông tin của user hiện tại - lọc các danh sách người dùng khác dựa trên city của user hiện tại
          getFilterListUsersByCity(personCurrent.address!.city as String);


        // setState(() {
        //   isLoading = false; // Cập nhật isLoading khi dữ liệu đã tải xong
        // });
      }

    });
  }
//---------------------

  void getFilterListUsersByCity(String city) {
    final userQuery = FirebaseFirestore.instance
        .collection('users')
        .where('address.city', isEqualTo: city)  // Lọc theo trường `city` trong `address`
        .snapshots();  // Dùng snapshots() để theo dõi thay đổi theo thời gian

    userQuery.listen((querySnapshot) {
      final filterListUsersByCity = querySnapshot.docs.map((doc) {
        return Person.fromMap(doc.data()); // Chuyển đổi mỗi tài liệu thành đối tượng Person
      }).toList();

      // Cấu hình danh sách các người dùng theo point
      configListUser(filterListUsersByCity);

      // _initializeMarkers();

      // print('Number of users in $city: ${filterListUsersByCity.length}');
      // // In ra thông tin của từng người dùng
      // for (var user in filterListUsersByCity) {
      //   print('User Name: ${user.name}');
      //   print('City: ${user.address?.city}');
      //   print('Latitude: ${user.address?.lat}');
      //   print('Longitude: ${user.address?.lng}');
      // }


      // Cập nhật trạng thái hoặc hiển thị danh sách


    });

  }
    void configListUser(List<Person> filterListUsersByCity) {
      List<LocationPoint> _markerCoordinates = [];
      for (var item in filterListUsersByCity){
        LocationPoint locationPoint = LocationPoint(person: item, latLng: new LatLng(item.address!.lat, item.address!.lng));
        _markerCoordinates.add(locationPoint);
      }
      print('_markerCoordinates.length${_markerCoordinates.length}');
      for(var item in _markerCoordinates){
        // print('_markerCoordinates${item.person.name}');
        // print('_markerCoordinates${item.latLng}');
      }
      setState(() {
        isLoading = false;
      });
        // Hiển thị các point của mọi người
      _initializeMarkers(_markerCoordinates);
    }

// Hàm xử lý danh sách người dùng


  // void getCityPersonCurrent(String idPersonCurrent) async{
  //   final userReference = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(idPersonCurrent)
  //       .snapshots();
  //   userReference.listen((snapshot) {
  //     if (snapshot.exists && snapshot.data() != null) {
  //       setState(() {
  //         // Chuyển đổi snapshot thành Person
  //         person = Person.fromMap(snapshot
  //             .data()!);
  //         print('dataPerson${person.}');
  //
  //         // Sử dụng phương thức fromMap để khởi tạo đối tượng Person
  //         isLoading = false; // Cập nhật isLoading khi dữ liệu đã tải xong
  //       });
  //     }
  //   });
  // }


// Danh sách tọa độ mẫu cách nhau khoảng 1km
//   final List<LatLng> _markerCoordinates = [
//     LatLng(16.0471, 108.2068), // Điểm gốc (Đà Nẵng)
//     LatLng(16.0481, 108.2068), // Cách khoảng 1km về phía Bắc
//     LatLng(16.0461, 108.2068), // Cách khoảng 1km về phía Nam
//     LatLng(16.0471, 108.2078), // Cách khoảng 1km về phía Đông
//     LatLng(16.0471, 108.2058), // Cách khoảng 1km về phía Tây
//   ];

  // void showInfor(){
  //   ScaffoldMessenger.of(context).clearSnackBars();
  //   ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Click!')));
  // }
  void showInfor(Person person) {
    // ScaffoldMessenger.of(context).clearSnackBars();
    // ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Click!'))
    // );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text('Đây là ${person.name} ' ?? 'Tên người dùng',
          // style: TextStyle(
          //   fontWeight: FontWeight.bold
          // ),),


          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),

              // Avatar người dùng
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                  person.img != null && person.img!.isNotEmpty
                      ? person.img!
                      : 'https://artena.vn/wp-content/uploads/2024/10/baby-cute.jpg', // Avatar mặc định
                ),
              ),
              SizedBox(height: 10),
              // Tên người dùng
              Text(person.name ?? 'Tên không có sẵn', style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ItemDetailUser(person: person, showBar: true,),
                  ));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding xung quanh text và icon
                  decoration: BoxDecoration(
                    color: ToolsColors.primary, // Màu nền
                    borderRadius: BorderRadius.circular(30), // Bo tròn góc
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Xem chi tiết ',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.arrow_right_alt,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              )

              // Nút điều hướng
              // ElevatedButton(
              //   onPressed: () {
              //     // Thực hiện điều hướng đến trang khác, ví dụ: Trang chi tiết người dùng
              //     // Navigator.push(
              //     //   context,
              //     //   MaterialPageRoute(
              //     //     builder: (context) => UserDetailScreen(userId: coord.person.id),
              //     //   ),
              //     // );
              //   },
              //   child: Text('Xem chi tiết'),
              // ),
            ],
          ),
        );
      },
    );
  }


  // Hàm tự động thêm marker vào bản đồ
  void _initializeMarkers(List<LocationPoint> markerCoordinates) {
    //_markerCoordinates được thay thế bằng danh mới có 2 thuộc tính mới.
    for (var coord in markerCoordinates) {
      _markers.add(
        Marker(
          point: coord.latLng,   //coord.point
          width: 40,
          height: 40,
          child: GestureDetector(
            child:  Container(
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.pinkAccent),
                borderRadius: BorderRadius.circular(50)
              ),
              child: ClipOval(
                child: Image.network(     //coord.infor.image
                  // 'https://artena.vn/wp-content/uploads/2024/10/baby-cute.jpg',
                  coord.person.img != null && coord.person.img!.isNotEmpty
                      ? coord.person.img!
                      : 'https://artena.vn/wp-content/uploads/2024/10/baby-cute.jpg', // URL mặc định nếu img là null hoặc rỗng
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const CircularProgressIndicator();
                  },
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error, size: 50, color: Colors.red),
                ),),),
            onTap: (){
              showInfor(coord.person);
            },   //  Bọc 1 column ở ngoài chứa cái tên ở trong
          ),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bản đồ với Marker tự động'),
        centerTitle: true,
      ),
      body:
      isLoading ? Center(child: CircularProgressIndicator()) :
      FlutterMap(
        options: MapOptions(
          // initialCenter: LatLng(16.0471, 108.2068), // Trung tâm bản đồ (ví dụ: Đà Nẵng)
          initialCenter: LatLng(personCurrent.address!.lat, personCurrent.address!.lng), // Trung tâm bản đồ (ví dụ: Đà Nẵng)
          initialZoom: 12.0, // Zoom ban đầu
        ),
        children: [
          // Lớp bản đồ nền (Street Map)
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            additionalOptions: const {
              'attribution': '© OpenStreetMap contributors',
            },
          ),
          // Lớp marker
          MarkerLayer(
            markers: _markers,
          ),
        ],
      )
      ,
    );
  }




}



