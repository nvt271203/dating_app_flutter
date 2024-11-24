import 'package:chat_dating_app/datas/hoppy_list.dart';
import 'package:chat_dating_app/models/Address.dart';
import 'package:chat_dating_app/models/CheckboxObject.dart';
import 'package:chat_dating_app/providers/hobbies_provider.dart';
import 'package:chat_dating_app/screens/first_options/personality.dart';
import 'package:chat_dating_app/tools/tools_colors.dart';
import 'package:chat_dating_app/widgets/item_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HobbyScreen extends StatefulWidget {
  const HobbyScreen({super.key, required this.idPerson, required this.address});
  final String idPerson;
  final Address address;
  @override
  State<HobbyScreen> createState() => _HobbyScreenState();
}

class _HobbyScreenState extends State<HobbyScreen> {
  final checkBoxAllHoppy = CheckboxObject(title: 'Chọn tất cả');


  @override
  void initState() {
    super.initState();
    // Reset lại tất cả các giá trị checkbox khi trang được mở lại
    resetCheckBoxState();
  }
  void resetCheckBoxState() {
    setState(() {
      // Reset "Chọn tất cả" checkbox về false
      checkBoxAllHoppy.value = false;
      // Reset tất cả các item trong hoppyList về false
      hobbyList.forEach((element) {
        element.value = false;
      });
    });
  }

  void onCheckAllItem(CheckboxObject statusItem) {
    var statusCurrent = !statusItem.value;
    setState(() {
      statusItem.value = statusCurrent;
      hobbyList.forEach((element) => element.value = statusCurrent,);
    });
  }
  void onCheckItem(CheckboxObject statusItem) {
    var statusCurrent = !statusItem.value;
    setState(() {
      statusItem.value = statusCurrent;
      if(!statusCurrent){
        checkBoxAllHoppy.value = false;
      }else{
        final allListCheckbox = hobbyList.every((item) => item.value);
        checkBoxAllHoppy.value = allListCheckbox;
      }
    });
  }
  void _submit(){

    // Lọc các mục đã được chọn - toList để lấy ra 1 danh sách, where để lọc theo điều kiện nào đó - item là duyệt qua từng con của list, và chỉ lấy con có value.
    final selectedHobbiesList = hobbyList.where((item) => item.value).toList();

    // Kiểm tra nếu không có mục nào được chọn
    if (selectedHobbiesList.isEmpty) {
      // Hiển thị thông báo nếu cần
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng chọn ít nhất một sở thích!')),
      );
      return;
    }

    // In danh sách các mục đã chọn ra console (debug)
    for (var hobby in selectedHobbiesList) {
      print('Selected Hobby: ${hobby.title}');
    }

    // Thực hiện hành động lưu trữ (ví dụ gửi lên server hoặc lưu vào local)
    // Ví dụ: Navigator chuyển sang màn hình tiếp theo
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PersonalityScreen(idPerson: widget.idPerson, address: widget.address ,selectedHobbiesList: selectedHobbiesList),
    ));



  }



  @override
  Widget build(BuildContext context) {
    // final hobbies = ref.watch(hobbiesProvider);


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
              'Sở thích của bạn như thế nào',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            ListTile(
              onTap: () {
                onCheckAllItem(checkBoxAllHoppy);
              },
              leading: Checkbox(
                value: checkBoxAllHoppy.value,
                onChanged: (value) {
                  onCheckAllItem(checkBoxAllHoppy);
                },
              ),
              title: Text(
                checkBoxAllHoppy.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            Divider(),
            // Dùng ListView.builder để render danh sách hoppyList
            // ListView.builder(
            //   shrinkWrap: true,  // Đảm bảo ListView không chiếm toàn bộ không gian
            //   physics: NeverScrollableScrollPhysics(), // Tắt cuộn trong ListView
            //
            //   itemCount: hoppyList.length,
            //   itemBuilder: (context, index) {
            //     final item = hoppyList[index];
            //     return ListTile(
            //       onTap: () => onCheckItem(item),
            //       // leading: Checkbox(
            //       //   value: item.value,
            //       //   onChanged: (value) => onCheckItem(item),
            //       // ),
            //       title: ItemTitle(title: item.title, isChecked: item.value, ),
            //     );
            //   },
            // ),


            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 16.0, // Khoảng cách giữa các phần tử ngang
                  runSpacing: 16.0, // Khoảng cách giữa các dòng
                  alignment: WrapAlignment.spaceEvenly, // Căn giữa các phần tử theo chiều ngang
                  children: hobbyList.map((item) {
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
