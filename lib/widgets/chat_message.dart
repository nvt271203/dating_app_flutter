import 'dart:ffi';

import 'package:chat_dating_app/widgets/MessageBubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_smart_reply/google_mlkit_smart_reply.dart';

class ChatMessage extends StatefulWidget {
  // const ChatMessage({super.key,});
  //----------------------------------
  const ChatMessage({Key? key, required this.rederListSuggest}) : super(key: key);
  final Function(List<String>) rederListSuggest; // Nhận callback từ cha
  // -------------------------------------
  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  final authUser = FirebaseAuth.instance.currentUser!;
  bool _hasSuggestedMessages = false;

  late final Function(List<String>) rederListSuggest;

  List<String> listSuggestMessages = [];
  // tạo 1 đối tượng gợi ý tin nhắn tự động.
  late SmartReply smartReply;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    smartReply = SmartReply();
  }
  // void _suggestMessages(String messgae) async{
  //   smartReply.addMessageToConversationFromLocalUser(messgae, DateTime.now().millisecondsSinceEpoch);
  //   // smartReply.addMessageToConversationFromRemoteUser(chatMessage['message'], DateTime.now().millisecondsSinceEpoch, 'userId');
  //
  //   final response = await smartReply.suggestReplies();
  //
  //   if (response.suggestions.isEmpty) {
  //     print('No suggestions available');
  //   } else {
  //     for (final suggestion in response.suggestions) {
  //       print('suggestion: $suggestion');
  //
  //     }
  //   }
  // }

  void _suggestMessages() async{
    // smartReply.addMessageToConversationFromLocalUser('Hôm nay bạn thế nào', DateTime.now().millisecondsSinceEpoch);
    // smartReply.addMessageToConversationFromRemoteUser('Hôm nay tôi buồn', DateTime.now().millisecondsSinceEpoch, 'userId');


    //
    // Xóa các gợi ý trước đó nếu có, sau đó sẽ gán lại sau khi có gợi ý mới
    listSuggestMessages.clear();
    // suggestionlistSuggestMessages.clear();

    final response = await smartReply.suggestReplies();



    if (response.suggestions.isEmpty) {
      print('No suggestions available');
    } else {
      for (final suggestion in response.suggestions) {
        print('suggestion: $suggestion');
        listSuggestMessages.add(suggestion);
        // listSuggestMessage
      }
      print('suggestionlistSuggestMessages: $listSuggestMessages');

      // Gọi callback để gửi dữ liệu
      widget.rederListSuggest(listSuggestMessages);

    }
  }
  void _addMessagesToSmartReply(List<QueryDocumentSnapshot<Map<String, dynamic>>> loadMessages) {

    // Kiểm tra nếu danh sách tin nhắn thay đổi, chỉ gọi SmartReply khi có tin nhắn mới
    if (loadMessages.isEmpty || _hasSuggestedMessages) return;
    // if (loadMessages.isEmpty) return;


    // Clear all old messages in Smart Reply before adding new ones
    smartReply.clearConversation();

    // Add 10 sample messages for Smart Reply
    final List<Map<String, dynamic>> sampleMessages = [
      {'message': 'How are you today?', 'isLocal': true},
      {'message': 'I feel sad today', 'isLocal': false, 'userId': 'user1'},
      {'message': 'Do you want to hang out?', 'isLocal': true},
      // {'message': 'I’m busy', 'isLocal': false, 'userId': 'user1'},
      // {'message': 'When are you free?', 'isLocal': true},
      // {'message': 'This weekend', 'isLocal': false, 'userId': 'user1'},
      // {'message': 'I’ll wait for you', 'isLocal': true},
      // {'message': 'Thank you', 'isLocal': false, 'userId': 'user1'},
      // {'message': 'No problem', 'isLocal': true},
      // {'message': 'See you later', 'isLocal': false, 'userId': 'user1'},
    ];

    for (final sampleMessage in sampleMessages) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      if (sampleMessage['isLocal']) {
        smartReply.addMessageToConversationFromLocalUser(sampleMessage['message'], timestamp);
      } else {
        smartReply.addMessageToConversationFromRemoteUser(sampleMessage['message'], timestamp, sampleMessage['userId']);
      }
    }


    // Đánh dấu là đã gợi ý tin nhắn để tránh gọi lại vô tận======================================================================================

    // Thay vì gọi setState ngay lập tức, hãy lên lịch gọi nó sau khi giai đoạn xây dựng hoàn tất
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Đánh dấu là đã có gợi ý tin nhắn sau khi hoàn thành việc xây dựng widget
      setState(() {
        _hasSuggestedMessages = true;
      });
      // Gọi hàm gợi ý tin nhắn sau khi thêm tin nhắn
      _suggestMessages();
    });




    // Call suggestion function after adding messages
    // Nếu thêm cái này phát nữa, sẽ gợi ý tin nhắn lần 2.
    // _suggestMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        // Tạo 1 request sắp xếp theo tên.
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('created', descending: true)
            .snapshots(),
        builder: (context, chatSnapshots) {
          if (chatSnapshots.connectionState == ConnectionState.waiting) {
            //= trạng thái chờ đợi
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
            //.has data(có dữ liệu k)
            return const Center(
              child: Text('No messages found.'),
            );
          }

          if (chatSnapshots.hasError) {
            // có lỗi k
            return const Center(
              child: Text('Some thing went wrong...'),
            );
          }

          // nếu k thỏa cái đk failse trên kia thì get dữ liệu về.
          final loadMessages = chatSnapshots.data!.docs;

          _addMessagesToSmartReply(loadMessages);// Thêm các tin nhắn vào Smart Reply

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
                reverse: true, // lật toàn bộ 90'
                itemCount: loadMessages.length,
                itemBuilder: (context, index) {

                  print("coutNumberDisplay: 1" );

                  final chatMessage = loadMessages[index]
                      .data(); //chứa thể hiện 1 tin nhắn hiện tại
                  final nextChatMessage = index + 1 <
                          loadMessages
                              .length // chứa thể hiện 1 tinh nhắn tiếp theo
                      ? loadMessages[index + 1].data()
                      : null;

                  final currentMessageUserId = chatMessage['userId'];
                  final nextMessageUserId = nextChatMessage != null
                      ? nextChatMessage['userId']
                      : null;

                  final nextUserIsSame =
                      nextMessageUserId == currentMessageUserId;

                  // if (index + 1 == loadMessages.length){
                  // if (index == loadMessages.length - 1) {
//                   if (true) {
//
//                     // print("suggestion: ${chatMessage['message']}");
//                     // smartReply.addMessageToConversationFromLocalUser('Trời hôm nay mưa to quá', DateTime.now().millisecondsSinceEpoch);
//                     // smartReply.addMessageToConversationFromRemoteUser('Cần thận khi ra ngoài nhé', DateTime.now().millisecondsSinceEpoch, 'userId')
//
// // Duyệt qua tất cả tin nhắn và thêm chúng vào SmartReply
//                     for (var message in loadMessages) {
//                       final chatMessage = message.data();
//
//                       DateTime time = chatMessage['created'].toDate();
//                       if (chatMessage['userId'] == authUser.uid) {
//                         print('dataMessageSend: ${chatMessage['message']}');
//                         // smartReply.addMessageToConversationFromLocalUser(
//                         //     chatMessage['message'], DateTime.now().millisecondsSinceEpoch);
//                         smartReply.addMessageToConversationFromLocalUser(chatMessage['message'], time.millisecondsSinceEpoch);
//
//                       } else {
//                         print('dataMessagReceiver: ${chatMessage['message']}');
//
//                         // smartReply.addMessageToConversationFromRemoteUser(
//                         //     chatMessage['message'], DateTime.now().millisecondsSinceEpoch, chatMessage['userId']);
//                         smartReply.addMessageToConversationFromRemoteUser(chatMessage['message'], time.millisecondsSinceEpoch, chatMessage['userId']);
//                       }
//                     }
//                       _suggestMessages();
//
//
//                     // _suggestMessages();
//                     // For local user.
//                     //   _suggestMessages(chatMessage['message']);
//                   }

                  if (nextUserIsSame) {
                    //Nếu tin nhắn tiếp theo là của người dùng
                    return MessageBubble.next(
                        message: chatMessage['message'],
                        isMe: authUser.uid == currentMessageUserId);
                  } else {
                    //Nếu tin nhắn tiếp theo là của 1 người khác.
                    return MessageBubble.first(
                        userImage: chatMessage['userImage'],
                        username: chatMessage['userName'],
                        message: chatMessage['message'],
                        isMe: authUser.uid == currentMessageUserId);
                  }


                }),
          );
        },
      ),
    );
  }

}


