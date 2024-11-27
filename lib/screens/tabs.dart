import 'package:chat_dating_app/screens/bottom_bar/chats.dart';
import 'package:chat_dating_app/screens/bottom_bar/profile.dart';
import 'package:chat_dating_app/screens/bottom_bar/home.dart';
import 'package:chat_dating_app/screens/bottom_bar/users.dart';
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
      activePage = const ChatsScreen();
    }
    if (_selectedPageIndex == 3) {
      // activePageTitel = 'List User';
      activePage = const UserScreen();
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
          items: [
            // Danh sách các item tab.
            BottomNavigationBarItem(icon: const Icon(Icons.home), label: 'Home', backgroundColor: ToolsColors.primary),
            BottomNavigationBarItem(icon: const Icon(Icons.ac_unit), label: 'World',backgroundColor: ToolsColors.primary),
            BottomNavigationBarItem(icon: const Icon(Icons.chat), label: 'Chats',backgroundColor: ToolsColors.primary),
            BottomNavigationBarItem(icon: const Icon(Icons.supervised_user_circle), label: 'Users', backgroundColor: ToolsColors.primary),
            BottomNavigationBarItem(icon: const Icon(Icons.person), label: 'Profile', backgroundColor: ToolsColors.primary),
          ]),
    );
  }
}
