import 'package:chat_dating_app/widgets/item_detail_user.dart';
import 'package:chat_dating_app/widgets/item_intro_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/Person.dart';
import '../../tools/tools_colors.dart';

class GridSecond extends StatefulWidget {
  const GridSecond({super.key});

  @override
  State<GridSecond> createState() => _GridSecondState();
}

class _GridSecondState extends State<GridSecond> {
  bool isGetData = true;

  // final _listItem = [
  //   Image.asset('assets/images/son_tung_mtp.jpg'),
  //   Image.asset('assets/images/son_tung_mtp.jpg'),
  //   Image.asset('assets/images/son_tung_mtp.jpg'),
  //   Image.asset('assets/images/son_tung_mtp.jpg'),
  //   Image.asset('assets/images/son_tung_mtp.jpg'),
  // ];
  List<Person> _listItem = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFilterListUsersNotUserCurrent();
  }
  void getFilterListUsersNotUserCurrent() {
    final usersCollection = FirebaseFirestore.instance.collection('users');

    usersCollection.snapshots().listen((querySnapshot) {
      // Duyệt qua danh sách và loại bỏ người dùng hiện tại
      final List<Person> filteredUsers = querySnapshot.docs
          .where((doc) =>
      doc.id !=
          FirebaseAuth
              .instance.currentUser!.uid) // Loại bỏ người dùng hiện tại
          .map((doc) => Person.fromMap(doc
          .data()!)) // Chuyển đổi dữ liệu Firestore thành đối tượng Person
          .toList();

      // Xử lý danh sách filteredUsers theo nhu cầu
      print('Filtered users count: ${filteredUsers.length}');
      for (var user in filteredUsers) {
        print('User: ${user.toString()}');
      }

      setState(() {
        _listItem = filteredUsers;
        isGetData = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isGetData) {
      return const Center(
        child:
            CircularProgressIndicator(), // Hiển thị thanh tiến trình khi đang tải dữ liệu
      );
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                padding:  EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Giảm padding ngang để cân đối hơn
                decoration:  BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ToolsColors.primary,
                      Colors.white,
                    ],
                  ),
                ),
                child: const Align(
                  alignment: Alignment.centerLeft, // Căn trái nội dung văn bản
                  child: Text(
                    'Gợi ý',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),),
            ),
            Container(
              margin: EdgeInsets.only(right: 20),
              height: 44, // Chiều cao của icon "More"
              width: 44, // Đảm bảo kích thước vuông
              decoration: BoxDecoration(
                  color: ToolsColors.primary.withOpacity(0.2), // Màu nền icon
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 2, color: ToolsColors.primary)// Bo góc
              ),
              child:  Icon(
                Icons.filter_alt_sharp, // Biểu tượng menu
                color: ToolsColors.primary, // Màu icon
              ),
            ),

          ],
        ),

        Padding(
          padding: const EdgeInsets.all(10.0),
          child: GridView(
            physics: const NeverScrollableScrollPhysics(),
            // Tắt cuộn riêng cho GridView
            shrinkWrap: true,
            // WARNING: BẮT BUỘC PHẢI CÓ--- Cho phép GridView hiển thị đầy đủ trong `SingleChildScrollView`

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                // số cột
                childAspectRatio: 2 / 2.5,
                // Tỉ lệ chiều rộng / chiều dài
                crossAxisSpacing: 10,
                // khoảng cách các phần tử trong cùng 1 cột dọc
                mainAxisSpacing: 10),
            // khoảng cách các phần tử trong cùng 1 hàng
            children: [
              for (final item in _listItem)
                ItemIntroUser(
                  person: item,
                ),
            ],
          ),
        )
      ],
    );
  }
}
