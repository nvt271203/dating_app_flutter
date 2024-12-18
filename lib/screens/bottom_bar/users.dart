import 'package:chat_dating_app/tools/tools_colors.dart';
import 'package:chat_dating_app/widgets/item_detail_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/Person.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _ListUserScreenState();
}

class _ListUserScreenState extends State<UserScreen> {
  bool isLoading = true; // Biến để kiểm tra trạng thái loading
  List<Person> _listItem = [];

  @override
  void initState() {
    super.initState();
    getFilterListUsersNotUserCurrent();
  }

  void getFilterListUsersNotUserCurrent() {
    final usersCollection = FirebaseFirestore.instance.collection('users');

    usersCollection.snapshots().listen((querySnapshot) {
      final List<Person> filteredUsers = querySnapshot.docs
          .where((doc) => doc.id != FirebaseAuth.instance.currentUser!.uid)
          .map((doc) => Person.fromMap(doc.data()!))
          .toList();

      setState(() {
        _listItem = filteredUsers;
        isLoading = false; // Dữ liệu đã được tải xong, thay đổi trạng thái
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gợi ý bạn bè'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Hiển thị thanh tiến trình khi đang tải dữ liệu
          : Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ToolsColors.primary.withOpacity(0.8),
              Colors.white,
            ],
          ),
        ), child: ListView.builder(
                    itemCount: _listItem.length,
                    itemBuilder: (context, index) {
            final person = _listItem[index];
            return Padding(
              padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
              child: GestureDetector(
                onTap: () {
                  // Điều hướng tới trang chi tiết người dùng khi nhấn vào vùng chứa phần tử
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemDetailUser(person: person, showBar: true),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    // color: ToolsColors.primary.withOpacity(0.2), // Màu nền
                    color: Colors.white, // Màu nền
                    border: Border.all(width: 1, color: ToolsColors.primary.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(20.0), // Bo góc ngoài
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 4, offset: Offset(0, 2))], // Tạo bóng mờ
                  ),
                  child: Row(
                    children: [
                      // Avatar người dùng
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(person.img.toString()), // Giả sử bạn có avatarUrl
                      ),
                      const SizedBox(width: 12), // Khoảng cách giữa avatar và thông tin

                      // Thông tin người dùng
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                person.sex == 'Female' ? Icons.female : Icons.male, // Chọn biểu tượng dựa trên giới tính
                                  color: person.sex == 'Female' ? Colors.pinkAccent : Colors.blue
                                  , // Màu icon
                        ),
                                Text(
                                  '${person.age}',
                                  // '${'17 tuoi'}, ${person.name.toString()}',
                                  style: TextStyle(
                                    color: person.sex == 'Female' ? Colors.pinkAccent : Colors.blue,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  ' - ${person.name.toString()}',
                                  // '${'17 tuoi'}, ${person.name.toString()}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            // Tên và tuổi người dùng
                            // Địa chỉ người dùng
                            Text(
                              person.address!.city ?? 'No address provided', // Hiển thị địa chỉ hoặc thông báo không có
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
                    },
                  ),
          ),
    );
  }
}
