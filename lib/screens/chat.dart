// import 'package:chat_dating_app/widgets/chat_message.dart';
// import 'package:chat_dating_app/widgets/new_message.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
//
// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//
//   List<String> _suggestedMessages = [];// danh sách gợi ý ban đầu sẽ trống.
//   // Hàm này sẽ nhận danh sách gợi ý từ `ChatMessage`
//   void handleSuggestedMessages(List<String> suggestedMessages) {
//     print('Suggested Messages: $suggestedMessages');
//     // Xử lý dữ liệu ở đây (ví dụ: cập nhật trạng thái, hiển thị gợi ý, v.v.)
//
//
//   //   -------- Bước different -> gửi dữ liệu qua newMessage.
//     setState(() {
//       _suggestedMessages = suggestedMessages;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Flutter chat.'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               FirebaseAuth.instance.signOut();
//             },
//             icon: Icon(
//               Icons.exit_to_app,
//               color: Theme
//                   .of(context)
//                   .colorScheme
//                   .primary,
//             ),
//           )
//         ],
//       ),
//       body: Column(
//         children: [ChatMessage(rederListSuggest: handleSuggestedMessages), NewMessage(suggestedMessages: _suggestedMessages,)],
//       ),
//     );
//   }
// }
