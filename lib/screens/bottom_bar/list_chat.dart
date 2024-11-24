import 'package:flutter/material.dart';
class ListChatScreen extends StatefulWidget {
  const ListChatScreen({super.key});

  @override
  State<ListChatScreen> createState() => _ListChatState();
}

class _ListChatState extends State<ListChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(child: const Text('Frame List Chat'));
  }
}
