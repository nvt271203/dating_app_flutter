import 'package:chat_dating_app/main.dart';
import 'package:chat_dating_app/models/Person.dart';
import 'package:chat_dating_app/screens/settings.dart';
import 'package:chat_dating_app/widgets/item_detail_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = false;
  Person? person;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final currentUser  = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // Nếu không có người dùng hiện tại, xử lý việc điều hướng hoặc hiển thị thông báo lỗi.
      print("Người dùng chưa đăng nhập!");
      return;
    }

    setState(() {
      isLoading = true;
    });
    final userReference = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .snapshots();

    userReference.listen((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        setState(() {
          // Chuyển đổi snapshot thành Person
          person = Person.fromMap(snapshot
              .data()!); // Sử dụng phương thức fromMap để khởi tạo đối tượng Person
          isLoading = false; // Cập nhật isLoading khi dữ liệu đã tải xong
        });
      }

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: isLoading
        //     ? const CircularProgressIndicator()
        //     // : Center(child: Text(nameUser)),
        //     : Center(child: Text('Hồ sơ người dùng')),
        leading: IconButton(
          icon: const Icon(Icons.settings), // Biểu tượng cài đặt
          onPressed: () {
            // Hành động khi nhấn nút cài đặt
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SettingsScreen(),));
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => AuthStateScreen(),
              ));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding xung quanh text và icon
              decoration: BoxDecoration(
                color: Colors.white, // Màu nền
                borderRadius: BorderRadius.circular(30), // Bo tròn góc
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Đăng Xuất',
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.exit_to_app,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          )


          // IconButton(
          //   onPressed: () {
          //     FirebaseAuth.instance.signOut();
          //     // Điều hướng về màn hình AuthStateScreen sau khi đăng xuất
          //     Navigator.of(context).pushReplacement(
          //       MaterialPageRoute(builder: (context) => const MyApp()),
          //     );
          //   },
          //   icon: Icon(
          //     Icons.exit_to_app,
          //     color: Theme
          //         .of(context)
          //         .colorScheme
          //         .primary,
          //   ),
          // )

        ],
      ),

      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : person != null
          ? ItemDetailUser(person: person!, showBar: false,)
          : Center(child: Text('Thông tin người dùng không có')),


    );
  }
}
