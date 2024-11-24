import 'package:chat_dating_app/models/User.dart';
import 'package:chat_dating_app/widgets/user_message.dart';
import 'package:chat_dating_app/widgets/header_user.dart';
import 'package:chat_dating_app/widgets/new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatUserScreen extends StatefulWidget {
  final String userIdReceiver;

  static route(String userIdReceiver) => MaterialPageRoute(
        builder: (context) => ChatUserScreen(userIdReceiver: userIdReceiver),
      );

  const ChatUserScreen({super.key, required this.userIdReceiver});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatUserScreen> {
  late User user;
  bool isLoading = true; // Thêm biến này để kiểm tra trạng thái tải dữ liệu

  List<String> _suggestedMessages = []; // danh sách gợi ý ban đầu sẽ trống.
  // Hàm này sẽ nhận danh sách gợi ý từ `ChatMessage`
  void handleSuggestedMessages(List<String> suggestedMessages) {
    print('Suggested Messages: $suggestedMessages');
    // Xử lý dữ liệu ở đây (ví dụ: cập nhật trạng thái, hiển thị gợi ý, v.v.)

    //   -------- Bước different -> gửi dữ liệu qua newMessage.
    setState(() {
      _suggestedMessages = suggestedMessages;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("idUserClicked:${widget.userIdReceiver}");

    final userReference = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userIdReceiver)
        .snapshots();

    userReference.listen((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        setState(() {
          // Chuyển đổi snapshot thành User
          user = User.fromMap(snapshot.data()! as Map<String, dynamic>);

          isLoading = false; // Cập nhật isLoading khi dữ liệu đã tải xong
          // user = userReference as User;
        });
      }
    });
  }

  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [
    {
      "name": "User A",
      "message": "Hi there!",
      "image": "https://i.pravatar.cc/300"
    },
    {
      "name": "User B",
      "message": "Hello! How are you?",
      "image": "https://i.pravatar.cc/301"
    },
  ];

  void _sendMessage() {
    if (_controller.text.isEmpty) return;

    setState(() {
      _messages.add({
        "name": "You",
        "message": _controller.text,
        "image": "https://i.pravatar.cc/300?img=3"
      });
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          title: Row(
            children: [
              isLoading
                  ? const CircularProgressIndicator() // Hiển thị loading khi đang tải
                  : Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              user.avatar), // Sử dụng NetworkImage từ URL
                        ),
                        const SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, ),
                          child: Text(user.userName,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          UserMessage(idUserReceiver: widget.userIdReceiver, rederListSuggest: handleSuggestedMessages, ),

          NewMessage(idUserReceiver: widget.userIdReceiver,
              suggestedMessages: _suggestedMessages.isEmpty
                  ? [
                    'Hello',
                    'Nice to chat with you',
                    'May I know your name'
                    ]
                  : _suggestedMessages)
          // HeaderUser(nameUser: user.userName, avatar: user.avatar),

          // Expanded(
          //   child: ListView.builder(
          //     reverse: true,
          //     itemCount: _messages.length,
          //     itemBuilder: (context, index) {
          //       final message = _messages[index];
          //       final bool isMe = message["name"] == "You";
          //       return ListTile(
          //         leading: isMe
          //             ? null
          //             : CircleAvatar(
          //           backgroundImage: NetworkImage(message["image"]!),
          //         ),
          //         title: Text(
          //           message["name"]!,
          //           style: TextStyle(
          //             fontWeight: isMe ? FontWeight.bold : FontWeight.normal,
          //           ),
          //         ),
          //         subtitle: Text(message["message"]!),
          //         trailing: isMe
          //             ? CircleAvatar(
          //           backgroundImage: NetworkImage(message["image"]!),
          //         )
          //             : null,
          //       );
          //     },
          //   ),
          // ),
          // Divider(height: 1),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: TextField(
          //           controller: _controller,
          //           decoration: const InputDecoration(
          //             hintText: "Enter a message",
          //             border: OutlineInputBorder(),
          //           ),
          //         ),
          //       ),
          //       IconButton(
          //         icon: Icon(Icons.send),
          //         onPressed: _sendMessage,
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
