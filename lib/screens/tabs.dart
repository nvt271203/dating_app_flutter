import 'package:chat_dating_app/screens/bottom_bar/profile.dart';
import 'package:chat_dating_app/screens/bottom_bar/home.dart';
import 'package:chat_dating_app/screens/bottom_bar/list_chat.dart';
import 'package:chat_dating_app/screens/update_list_user.dart';
import 'package:chat_dating_app/screens/bottom_bar/world.dart';
import 'package:chat_dating_app/tools/tools_colors.dart';
import 'package:flutter/material.dart';

class TabsCreen extends StatefulWidget {
  const TabsCreen({super.key});

  @override
  State<TabsCreen> createState() => _TabsCreenState();
}

class _TabsCreenState extends State<TabsCreen> {
  int _selectedPageIndex = 0;

  void _selectedPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const HomeScreen();
    // var activePageTitel = 'Home\n-Search-Filter-Introduce-Slider-Function';

    if (_selectedPageIndex == 1) {
      // activePageTitel = 'List Chat';
      activePage = const WorldScreen();
    }
    if (_selectedPageIndex == 2) {
      // activePageTitel = 'World';
      activePage = const WorldScreen();
    }
    if (_selectedPageIndex == 3) {
      // activePageTitel = 'List User';
      activePage = const ListUserScreen();
    }
    if (_selectedPageIndex == 4) {
      // activePageTitel = '';
      activePage = const ProfileScreen();
    }

    return Scaffold(
      body: activePage, // Loại frame sẽ đc hiển thị
      bottomNavigationBar: BottomNavigationBar(
          onTap: _selectedPage,
          //index của frame
          type: BottomNavigationBarType.fixed, // Luôn hiển thị nhãn
          // type: BottomNavigationBarType.shifting,
          // Chuyển sang chế độ "shifting"
          currentIndex: _selectedPageIndex,
          backgroundColor: ToolsColors.primary,
          //Biều thị item đc nhấn.
          selectedItemColor: Colors.white,

          // Màu khi được chọn
          unselectedItemColor: Colors.black.withOpacity(0.4),
          // Màu không được chọn
          items: const [
            // Danh sách các item tab.
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home', backgroundColor: Color(0xFF2D99AE)),
            BottomNavigationBarItem(icon: Icon(Icons.ac_unit), label: 'World',backgroundColor: Color(0xFF2D99AE)),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Messages',backgroundColor: Color(0xFF2D99AE)),
            BottomNavigationBarItem(
                icon: Icon(Icons.supervised_user_circle), label: 'Users', backgroundColor: Color(0xFF2D99AE)),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ]),
    );
  }
}
