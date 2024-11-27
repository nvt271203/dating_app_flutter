// import 'package:chat_dating_app/widgets/func_home/grid_second.dart';
// import 'package:chat_dating_app/widgets/func_home/slider_home.dart';
import 'package:flutter/material.dart';

import '../../tools/tools_colors.dart';
import '../../widgets/func_nav_home/grid_second.dart';
import '../../widgets/func_nav_home/slider_home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80), // Chiều cao AppBar
        child: Container(
          padding: const EdgeInsets.only(
            top: 40, // Khoảng cách đến thanh trạng thái
            left: 16,
            right: 16,
            bottom: 10,
          ),
          decoration: BoxDecoration(
            color: ToolsColors.primary, // Màu nền AppBar
          ),
          child: Row(
            children: [
              // Icon "More"
              Container(
                height: 44, // Chiều cao của icon "More"
                width: 44, // Đảm bảo kích thước vuông
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5), // Màu nền icon
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 2, color: Colors.white)// Bo góc
                ),
                child: const Icon(
                  Icons.menu, // Biểu tượng menu
                  color: Colors.white, // Màu icon
                ),
              ),
              const SizedBox(width: 16), // Khoảng cách giữa icon và thanh tìm kiếm
              // Thanh tìm kiếm
              Expanded(
                child: Container(
                  height: 44, // Đặt chiều cao bằng với icon "More"
                  padding: const EdgeInsets.symmetric(horizontal: 12), // Padding trong thanh tìm kiếm
                  decoration: BoxDecoration(
                    color: Colors.white, // Màu nền thanh tìm kiếm
                    borderRadius: BorderRadius.circular(15), // Bo góc
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search, // Icon tìm kiếm bên trái
                        color: Colors.grey, // Màu icon
                      ),
                      const SizedBox(width: 8), // Khoảng cách giữa icon và hint
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search...', // Nội dung gợi ý
                            hintStyle: const TextStyle(color: Colors.grey), // Màu hint
                            border: InputBorder.none, // Ẩn đường viền TextField
                          ),
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
      body: SingleChildScrollView(  // Bọc toàn bộ phần body trong SingleChildScrollView để cuộn
        child: Column(
          children: [
            SliderHome(),
            GridSecond(),  // GridSecond sẽ hiển thị mà không cần sử dụng Expanded
          ],
        ),
      ),
    );
  }
}
