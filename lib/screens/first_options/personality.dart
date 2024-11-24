import 'package:chat_dating_app/datas/hoppy_list.dart';
import 'package:chat_dating_app/models/Address.dart';
import 'package:chat_dating_app/screens/tabs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/CheckboxObject.dart';
import '../../tools/tools_colors.dart';
import '../../widgets/item_title.dart';
class PersonalityScreen extends StatefulWidget {
  const PersonalityScreen({super.key, required this.idPerson,required this.address ,required this.selectedHobbiesList});
  final String idPerson;
  final Address address;
  final List<CheckboxObject> selectedHobbiesList;

  @override
  State<PersonalityScreen> createState() => _PersonalityScreenState();
}

class _PersonalityScreenState extends State<PersonalityScreen> {
  var _isUploadData = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // In danh sách các mục đã chọn ra console (debug)
    for (var hobby in widget.selectedHobbiesList) {
      print('SelectedHobbyBefore: ${hobby.title}');
      print('SelectedHobbyBefore: ${widget.idPerson}');

    }
  }
  final checkBoxAll = CheckboxObject(title: 'Chọn tất cả');
  // void _navigatorPersonality(BuildContext context) {
  //   Navigator.of(context).push(MaterialPageRoute(
  //     builder: (context) => PersonalityScreen(idPerson: widget.idPerson,),
  //   ));
  // }

  void onCheckAllItem(CheckboxObject statusItem) {
    var statusCurrent = !statusItem.value;
    setState(() {
      statusItem.value = statusCurrent;
      personalityList.forEach((element) => element.value = statusCurrent,);
    });
  }
  void onCheckItem(CheckboxObject statusItem) {
    var statusCurrent = !statusItem.value;
    setState(() {
      statusItem.value = statusCurrent;
      if (!statusCurrent) {
        checkBoxAll.value = false;
      } else {
        final allListCheckbox = personalityList.every((item) => item.value);
        checkBoxAll.value = allListCheckbox;
      }
    });
  }

  void _submit() async{
    setState(() {
      _isUploadData = true;
    });

    // Gửi dữ liệu địa chỉ lên Firestore
    // final selectedAddress = widget.address.toMap();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.idPerson)  // Tài liệu người dùng
        .set({
      'address': widget.address.toMap(),  // Lưu danh sách sở thích vào trường 'hobbies'
      // Bạn có thể thêm các trường khác ở đây như 'personalities', nếu cần
    },
        SetOptions(merge: true)
    );  // Dùng merge để không ghi đè dữ liệu cũ


    //Chỉ lưu các List thuộc đối tượng CheckBox, nhưng vì lưu trữ dữ liệu dưới dạng 1 Object nên phải đổi về toMap.
    final selectedHobbiesStore = widget.selectedHobbiesList
        .where((hobby) => hobby.value)  // Chỉ lấy những sở thích được chọn
        .map((hobby) => hobby.toMap())  // Chuyển đổi đối tượng thành Map
        .toList();  // Chuyển thành danh sách
    // Gửi dữ liệu lên Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.idPerson)  // Tài liệu người dùng
        .set({
      'hobbies': selectedHobbiesStore,  // Lưu danh sách sở thích vào trường 'hobbies'
      // Bạn có thể thêm các trường khác ở đây như 'personalities', nếu cần
    },
        SetOptions(merge: true)
    );  // Dùng merge để không ghi đè dữ liệu cũ



    final selectedPersonalitiesList = personalityList.where((item) => item.value).toList(); // Lấy ra các phần tử được chọn true
    final selectedPersonalitiesStore = selectedPersonalitiesList
        .where((personal) => personal.value)  // Chỉ lấy những sở thích được chọn
        .map((personal) => personal.toMap())  // Chuyển đổi đối tượng thành Map
        .toList();  // Chuyển thành danh sách
    // Gửi dữ liệu lên Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.idPerson)  // Tài liệu người dùng
        .set({
      'personal': selectedPersonalitiesStore,  // Lưu danh sách sở thích vào trường 'hobbies'
      // Bạn có thể thêm các trường khác ở đây như 'personalities', nếu cần
    },
        SetOptions(merge: true)
    );  // Dùng merge để không ghi đè dữ liệu cũ




    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('This is Clicked')));
    // setState(() {
    //   _isUploadData = false;
    // });


    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const TabsCreen(),
    ));

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: TextButton(
                onPressed: () {},
                child: Text(
                  'Bỏ qua',
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.5)
                  ),
                )),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Tính cách của bạn là gì',
              // 'Mình có thể biết tính cách của bạn đc k',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            ListTile(
              onTap: () {
                onCheckAllItem(checkBoxAll);
              },
              leading: Checkbox(
                value: checkBoxAll.value,
                onChanged: (value) {
                  onCheckAllItem(checkBoxAll);
                },
              ),
              title: Text(
                checkBoxAll.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            Divider(),


            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 16.0, // Khoảng cách giữa các phần tử ngang
                  runSpacing: 16.0, // Khoảng cách giữa các dòng
                  alignment: WrapAlignment.spaceEvenly, // Căn giữa các phần tử theo chiều ngang
                  children: personalityList.map((item) {
                    return GestureDetector(
                      onTap: () => onCheckItem(item),
                      child: ItemTitle(
                        title: item.title,
                        isChecked: item.value,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),


            //-----------button---------
            if (_isUploadData)
              const CircularProgressIndicator(),
            if (!_isUploadData)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity, // Đặt chiều rộng full màn hình
                decoration: BoxDecoration(
                  // color: Colors.teal.withOpacity(opacity)
                ),
                child: TextButton(
                  onPressed: () {
                    // _navigatorPersonality(context);
                    _submit();
                  },
                  child: Text(
                    'Tiếp tục',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: ToolsColors.primary, // Màu nền
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0), // Padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), // Bo viền
                    ),
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
