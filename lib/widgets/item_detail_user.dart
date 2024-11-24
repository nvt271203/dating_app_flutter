import 'package:chat_dating_app/tools/tools_colors.dart';
import 'package:chat_dating_app/tools/tools_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../models/Person.dart';

class ItemDetailUser extends StatefulWidget {
  const ItemDetailUser(
      {super.key, required this.person, required this.showBar});

  final Person person;
  final bool showBar;

  @override
  State<ItemDetailUser> createState() => _ItemDetailUserState();
}

class _ItemDetailUserState extends State<ItemDetailUser> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('detail: ${widget.person.toString()}');
    print('detail: ${widget.person.hobbiesList?.length}');
    print('detail: ${widget.person.hobbiesList?[0].title}');

    // FirebaseAuth.instance.currentUser!.uid != widget.person.id.toString()

    print('idUserCurrent: ${FirebaseAuth.instance.currentUser!.uid}');
    print('idUserDifferent: ${widget.person.id.toString()}');
    print('idUserDetail: ${widget.person.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.showBar
            ? AppBar(
                // Tiêu đề AppBar nếu showBar là true
                title: Text('Chi tiết người dùng'),
              )
            : null, // Không hiển thị AppBar nếu showBar là false
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              ToolsColors.primary.withOpacity(0.5),
              Colors.white
            ])),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    FadeInImage(
                      placeholder: MemoryImage(kTransparentImage),
                      image: const AssetImage(
                          'assets/images/son_tung_mtp.jpg'),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                        bottom: -40,
                        left: 100,
                        right: 100,
                        height: 150,
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white, width: 2)),
                          // child: const CircleAvatar(foregroundImage: AssetImage('assets/images/avt_anh-son-tung-mtp.jpg'),),
                          child: CircleAvatar(
                            foregroundImage:
                                // AssetImage('assets/images/girl.jpg'),
                                NetworkImage(
                              widget.person.img.toString(),
                            ),

                            // backgroundImage: NetworkImage(widget.person.img.toString(),
                          ),
                        ))
                  ],
                ),

                Container(
                  
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        widget.person.name.toString(),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                      Text(
                        '1k Nguời yêu thích',
                        style:
                        TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                      ),

                      // nếu ko phải người dùng hiện tại mới cho nhấn yêu thích và nhắn tin.
                      if(FirebaseAuth.instance.currentUser!.uid != widget.person.id.toString())
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0), // Bo góc container ngoài
                              color: Colors.white, // Màu nền cho container ngoài
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 5,
                                  offset: Offset(0, 2), // Độ lệch bóng
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Phần tử 1: Icon thả tim + chữ yêu thích (Button)
                                TextButton(
                                  onPressed: () {
                                    // Logic khi nhấn vào button "Yêu thích"
                                    print('Yêu thích đã được nhấn');
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0), // Bo góc phần tử
                                      color: Colors.red.withOpacity(0.2), // Màu nền phần tử 1
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                        ),
                                        SizedBox(width: 8), // Khoảng cách giữa icon và chữ
                                        Text(
                                          'Yêu thích',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Phần tử 2: Icon nhắn tin + chữ nhắn tin (Button)
                                TextButton(
                                  onPressed: () {
                                    // Logic khi nhấn vào button "Nhắn tin"
                                    print('Nhắn tin đã được nhấn');
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0), // Bo góc phần tử
                                      color: Colors.blue.withOpacity(0.2), // Màu nền phần tử 2
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.message,
                                          color: Colors.blue,
                                        ),
                                        SizedBox(width: 8), // Khoảng cách giữa icon và chữ
                                        Text(
                                          'Nhắn tin',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      SizedBox(
                        height: 30,
                      ),
                      

                    ],
                  ),
                ),


                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                width: 2, color: ToolsColors.primary)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 30),
                              child: Row(
                                children: [
                                  Text(
                                    'Giới tính  -  ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    // widget.person.hobbiesList![0].title,
                                    // widget.person.hobbiesList![0].title,
                                    widget.person.sex.toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        color: ToolsColors.primary),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 20),
                              child: Row(
                                children: [
                                  Text(
                                    'Ngày sinh  -  ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    // ToolsFormat.formatter(widget.person.birthDay!).toString(), // Dòng này lỗi, nhưng dòng phía dưới lại ko :))
                                    ToolsFormat.formatter(
                                            widget.person.birthDay ??
                                                DateTime.now())
                                        .toString(),

                                    style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        color: ToolsColors.primary),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 20),
                              child: Row(
                                children: [
                                  Text(
                                    'Nghề nghiệp  -  ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Sinh Viên',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        color: ToolsColors.primary),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 20),
                              child: Row(
                                children: [
                                  Text(
                                    'Số điện thoại  -  ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.person.phone.toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        color: ToolsColors.primary),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 20),
                              child: Row(
                                children: [
                                  Text(
                                    'Địa chỉ  -  ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.person.address!.city.toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        color: ToolsColors.primary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: -25,
                      left: 50,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                            color: ToolsColors.primary,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          'Thông tin cá nhân',
                          style: TextStyle(
                              color: Colors.white, fontStyle: FontStyle.italic),
                        ),
                      ),
                    )
                  ],
                ),

                //========================================================Sở thích
                SizedBox(
                  height: 40,
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            width: 2,
                            color: ToolsColors.primary,
                          ),
                        ),
                        width: double.infinity,
                        // Đảm bảo vùng chứa full màn hình theo chiều ngang
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // for (final item in widget.person.hobbiesList!)
                            SizedBox(height: 20,),
                            Wrap(
                              // spacing: 16.0, // Khoảng cách giữa các phần tử ngang
                              // runSpacing: 16.0, // Khoảng cách giữa các dòng
                              alignment: WrapAlignment.spaceEvenly, // Căn giữa các phần tử theo chiều ngang
                              children: widget.person.hobbiesList!.map((item) {
                                return Container(
                                  margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5
                                  ),
                                  // Khoảng cách giữa các Text
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  // Khoảng cách bên trong
                                  decoration: BoxDecoration(
                                    color: ToolsColors.primary.withOpacity(0.3),
                                    // Màu nền cho Text
                                    borderRadius: BorderRadius.circular(
                                        100), // Bo góc cho từng Text
                                  ),
                                  child: Text(
                                    item.title as String,
                                    style: const TextStyle(color: Colors.black,
                                        fontStyle: FontStyle.italic,

                                    ), // Màu chữ
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 20,),

                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: -25,
                      left: 50,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                            color: ToolsColors.primary,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          'Sở thích',
                          style: TextStyle(
                              color: Colors.white, fontStyle: FontStyle.italic),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 40,
                ),

                //==========================================================Tính cách

                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            width: 2,
                            color: ToolsColors.primary,
                          ),
                        ),
                        width: double.infinity,
                        // Đảm bảo vùng chứa full màn hình theo chiều ngang
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // for (final item in widget.person.hobbiesList!)
                            SizedBox(height: 20,),
                            Wrap(
                              // spacing: 16.0, // Khoảng cách giữa các phần tử ngang
                              // runSpacing: 16.0, // Khoảng cách giữa các dòng
                              alignment: WrapAlignment.spaceEvenly, // Căn giữa các phần tử theo chiều ngang
                              children: widget.person.personalitiesList!.map((item) {
                                return Container(
                                  margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5
                                  ),
                                  // Khoảng cách giữa các Text
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  // Khoảng cách bên trong
                                  decoration: BoxDecoration(
                                    color: ToolsColors.primary.withOpacity(0.3),
                                    // Màu nền cho Text
                                    borderRadius: BorderRadius.circular(
                                        100), // Bo góc cho từng Text
                                  ),
                                  child: Text(
                                    item.title as String,
                                    style: const TextStyle(color: Colors.black,
                                      fontStyle: FontStyle.italic,

                                    ), // Màu chữ
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 20,),

                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: -25,
                      left: 50,
                      child: Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                            color: ToolsColors.primary,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          'Tính cách',
                          style: TextStyle(
                              color: Colors.white, fontStyle: FontStyle.italic),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 40,
                ),

                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                width: 2, color: ToolsColors.primary)),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 20),
                              child: Row(
                                children: [
                                  Text(
                                    'Giới tính  -  ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Nam',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        color: ToolsColors.primary),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 20),
                              child: Row(
                                children: [
                                  Text(
                                    'Tuổi  -  ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '18',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        color: ToolsColors.primary),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 20),
                              child: Row(
                                children: [
                                  Text(
                                    'Nghề nghiệp  -  ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '18',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        color: ToolsColors.primary),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 20),
                              child: Row(
                                children: [
                                  Text(
                                    'Số điện thoại  -  ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '0123456789',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        color: ToolsColors.primary),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 20),
                              child: Row(
                                children: [
                                  Text(
                                    'Địa chỉ  -  ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Gia Lai',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        color: ToolsColors.primary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: -25,
                      left: 50,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                            color: ToolsColors.primary,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          'Mục tiêu mối quan hệ',
                          style: TextStyle(
                              color: Colors.white, fontStyle: FontStyle.italic),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                width: 2, color: ToolsColors.primary)),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 20),
                              child: Row(
                                children: [
                                  Text(
                                    'Giới tính  -  ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Nam',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        color: ToolsColors.primary),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 20),
                              child: Row(
                                children: [
                                  Text(
                                    'Tuổi  -  ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '18',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        color: ToolsColors.primary),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 20),
                              child: Row(
                                children: [
                                  Text(
                                    'Nghề nghiệp  -  ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '18',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        color: ToolsColors.primary),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 20),
                              child: Row(
                                children: [
                                  Text(
                                    'Số điện thoại  -  ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '0123456789',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        color: ToolsColors.primary),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 20),
                              child: Row(
                                children: [
                                  Text(
                                    'Địa chỉ  -  ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Gia Lai',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        color: ToolsColors.primary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: -25,
                      left: 50,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                            color: ToolsColors.primary,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          'Mối quan tâm và sở thích ở đối phương',
                          style: TextStyle(
                              color: Colors.white, fontStyle: FontStyle.italic),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ));
  }
}
