import 'package:chat_dating_app/widgets/func_home/grid_second.dart';
import 'package:chat_dating_app/widgets/func_home/slider_home.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const SingleChildScrollView(  // Bọc toàn bộ phần body trong SingleChildScrollView để cuộn
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
