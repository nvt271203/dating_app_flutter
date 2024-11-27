import 'package:chat_dating_app/screens/theme.dart';
import 'package:flutter/material.dart';

import '../tools/tools_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Hàm xử lý sự kiện nhấn vào item
  void _onItemTapped(String title) {
    // Tùy vào tiêu chí nhấn, bạn có thể thực hiện hành động
    // Ví dụ: mở màn hình cài đặt tương ứng
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Bạn đã chọn: $title'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt'),
      ),
      body: Column(
        children: [
          // Thông tin cá nhân
          InkWell(
            onTap: () => _onItemTapped('Thông tin cá nhân'),
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              // Thêm padding để tạo khoảng cách rộng hơn
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, color: ToolsColors.primary),
                      // Sử dụng màu primary cho icon bên trái
                      SizedBox(width: 10),
                      Text('Thông tin cá nhân', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios,
                      size: 16, color: ToolsColors.primary),
                  // Sử dụng màu primary cho icon mũi tên
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            // Thêm padding cho đường phân cách
            child: Divider(color: Colors.grey),
          ),

          // Quyền riêng tư
          InkWell(
            onTap: () => _onItemTapped('Quyền riêng tư'),
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              // Thêm padding để tạo khoảng cách rộng hơn
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lock, color: ToolsColors.primary),
                      // Sử dụng màu primary cho icon bên trái
                      SizedBox(width: 10),
                      Text('Quyền riêng tư', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios,
                      size: 16, color: ToolsColors.primary),
                  // Sử dụng màu primary cho icon mũi tên
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            // Thêm padding cho đường phân cách
            child: Divider(color: Colors.grey),
          ),

          // Ngôn ngữ và Khu vực
          InkWell(
            onTap: () => _onItemTapped('Ngôn ngữ và Khu vực'),
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              // Thêm padding để tạo khoảng cách rộng hơn
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.language, color: ToolsColors.primary),
                      // Sử dụng màu primary cho icon bên trái
                      SizedBox(width: 10),
                      Text('Ngôn ngữ và Khu vực',
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios,
                      size: 16, color: ToolsColors.primary),
                  // Sử dụng màu primary cho icon mũi tên
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            // Thêm padding cho đường phân cách
            child: Divider(color: Colors.grey),
          ),

          // Chế độ giao diện
          InkWell(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ThemeScreen(),
            )),
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              // Thêm padding để tạo khoảng cách rộng hơn
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.brightness_6, color: ToolsColors.primary),
                      // Sử dụng màu primary cho icon bên trái
                      SizedBox(width: 10),
                      Text('Tùy biến giao diện', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios,
                      size: 16, color: ToolsColors.primary),
                  // Sử dụng màu primary cho icon mũi tên
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            // Thêm padding cho đường phân cách
            child: Divider(color: Colors.grey),
          ),

          // Hỗ trợ và phản hồi
          InkWell(
            onTap: () => _onItemTapped('Hỗ trợ và phản hồi'),
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              // Thêm padding để tạo khoảng cách rộng hơn
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.support, color: ToolsColors.primary),
                      // Sử dụng màu primary cho icon bên trái
                      SizedBox(width: 10),
                      Text('Hỗ trợ và phản hồi',
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios,
                      size: 16, color: ToolsColors.primary),
                  // Sử dụng màu primary cho icon mũi tên
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
