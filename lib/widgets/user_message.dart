import 'package:chat_dating_app/models/Chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_smart_reply/google_mlkit_smart_reply.dart';

import 'MessageBubble.dart';
class UserMessage extends StatefulWidget {
  const UserMessage({super.key, required this.idUserReceiver, required this.rederListSuggest});
  final String idUserReceiver;

  final Function(List<String>) rederListSuggest; // Nhận callback từ cha để return suggest

  @override
  State<UserMessage> createState() => _UserMessageState();
}
class _UserMessageState extends State<UserMessage> {
  final authUser = FirebaseAuth.instance.currentUser!;
  bool _isMessagesProcessed = false; // Thêm biến đánh dấu

  bool _hasSuggestedMessages = false;

  late final Function(List<String>) rederListSuggest;

  List<String> listSuggestMessages = [];
  // tạo 1 đối tượng gợi ý tin nhắn tự động.
  late SmartReply smartReply;
  @override
  void initState() {
    // TODO: implement initState
    // _hasSuggestedMessages
    super.initState();
    smartReply = SmartReply();
  }

  void _suggestMessages() async{
    // smartReply.addMessageToConversationFromLocalUser('Hôm nay bạn thế nào', DateTime.now().millisecondsSinceEpoch);
    // smartReply.addMessageToConversationFromRemoteUser('Hôm nay tôi buồn', DateTime.now().millisecondsSinceEpoch, 'userId');


    //
    // Xóa các gợi ý trước đó nếu có, sau đó sẽ gán lại sau khi có gợi ý mới
    listSuggestMessages.clear();
    print('Cleared');
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

  void _addMessagesToSmartReply(List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredMessages, List<QueryDocumentSnapshot<Map<String, dynamic>>> filterSenderMessages) {

    // Kiểm tra nếu danh sách tin nhắn thay đổi, chỉ gọi SmartReply khi có tin nhắn mới
    if (filteredMessages.isEmpty || _hasSuggestedMessages) return;   //_hasSuggestedMessages == true là cút. chỉ k return khi = false
    // if (filteredMessages.isEmpty) return;
    //
    // if (_hasSuggestedMessages) return
    // if (loadMessages.isEmpty) return;


// // Bỏ qua các gợi ý cũ và chỉ thêm khi có tin nhắn mới
//     _hasSuggestedMessages = false;    // Clear all old messages in Smart Reply before adding new ones
//

    smartReply.clearConversation();
    // _addMessagesToSmartReply(filteredMessages, filterSenderMessages);// Thêm các tin nhắn vào Smart Reply
    // final timestamp = DateTime.now().millisecondsSinceEpoch;

    for (final sampleMessage in filteredMessages.reversed) {
      print("dataMessage: ${sampleMessage.data()['message']}\n");

      //
      // final time = sampleMessage.data()['timeCreated'];
      // final timestamp = time.DateTime.now().millisecondsSinceEpoch;

      final time = sampleMessage.data()['timeCreated'] as Timestamp;
      final timestamp = time.millisecondsSinceEpoch;


      // final timestamp = DateTime.now().millisecondsSinceEpoch;
      print("dataMessageTime: ${timestamp}\n");

      // print("data: ${chat.message}\n");
      // print("data: ${chat.message}\n");

      // Nếu danh sách chat chứa user hiện tại -> ng dùng hiện tại.
      if(filterSenderMessages.contains(sampleMessage)){
        print('check dk: true');
        smartReply.addMessageToConversationFromLocalUser(sampleMessage.data()['message'], timestamp);
      }else{
        print('check dk: true');
        smartReply.addMessageToConversationFromRemoteUser(sampleMessage.data()['message'], timestamp, widget.idUserReceiver);
      }

    }



    // // Add 10 sample messages for Smart Reply
    // final List<Map<String, dynamic>> sampleMessages = [
    //   {'message': 'How are you today?', 'isLocal': true},
    //   {'message': 'I feel sad today', 'isLocal': false, 'userId': 'user1'},
    //   {'message': 'Do you want to hang out?', 'isLocal': true},
    //   // {'message': 'I’m busy', 'isLocal': false, 'userId': 'user1'},
    //   // {'message': 'When are you free?', 'isLocal': true},
    //   // {'message': 'This weekend', 'isLocal': false, 'userId': 'user1'},
    //   // {'message': 'I’ll wait for you', 'isLocal': true},
    //   // {'message': 'Thank you', 'isLocal': false, 'userId': 'user1'},
    //   // {'message': 'No problem', 'isLocal': true},
    //   // {'message': 'See you later', 'isLocal': false, 'userId': 'user1'},
    // ];



    // Đánh dấu là đã gợi ý tin nhắn để tránh gọi lại vô tận======================================================================================



    // Sử dụng WidgetsBinding để gọi _suggestMessages sau khi xây dựng xong
    // Thay vì gọi setState ngay lập tức, hãy lên lịch gọi nó sau khi giai đoạn xây dựng hoàn tất
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Đánh dấu là đã có gợi ý tin nhắn sau khi hoàn thành việc xây dựng widget
      setState(() {
        _suggestMessages();

        _hasSuggestedMessages = true;
      });
      // Gọi hàm gợi ý tin nhắn sau khi thêm tin nhắn
    });

//     // ===============================================================
//     _suggestMessages();

    // Thay vì gọi setState ngay lập tức, hãy lên lịch gọi nó sau khi giai đoạn xây dựng hoàn tất
    // WidgetsBinding.instance.addPostFrameCallback((_) {
      // Đánh dấu là đã có gợi ý tin nhắn sau khi hoàn thành việc xây dựng widget

      // Gọi hàm gợi ý tin nhắn sau khi thêm tin nhắn
    // });
    //
// // =========================================================================


    // Call suggestion function after adding messages
    // Nếu thêm cái này phát nữa, sẽ gợi ý tin nhắn lần 2.
    // _suggestMessages();
  }


    @override
    Widget build(BuildContext context) {
      return Expanded(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chat')
              .orderBy('timeCreated', descending: true)
              .snapshots(),
          builder: (context, chatSnapshots) {
            // Đặt lại _hasSuggestedMessages = false trước khi cập nhật giao diện


          if (chatSnapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
            return const Center(
              child: Text('No messages found.'),
            );
          }

          if (chatSnapshots.hasError) {
            return const Center(
              child: Text('Something went wrong...'),
            );
          }


          // ======= Get data chat ==========
          final loadMessages = chatSnapshots.data!.docs;

          // Lọc tin nhắn theo điều kiện người gửi và người nhận trong 1 phòng chat.
          final filteredMessages = loadMessages.where((doc) {
            final chatMessage = doc.data();
            final currentUserId = authUser.uid;
            final receiverId = widget.idUserReceiver;

            // Kiểm tra nếu tin nhắn phù hợp với điều kiện
            return (chatMessage['idSender'] == currentUserId && chatMessage['idReceiver'] == receiverId) ||
                (chatMessage['idReceiver'] == currentUserId && chatMessage['idSender'] == receiverId);
          }).toList();
          print('listMessage${filteredMessages.length}');





          //SUGGEST--- Kiểm tra tin nhắn hiện tại, người gửi là ai--Phục vụ phân loại thêm suggest.
          final filterSenderMessages = filteredMessages.where((doc) {
            final chatMessage = doc.data();
            final currentUserId = authUser.uid;
            // Kiểm tra nếu tin nhắn phù hợp với điều kiện
            return chatMessage['idSender'] == currentUserId;
          }).toList();
          // print('Tin nhắn người gửi hiện tại:${filterSenderMessages.length}');




          // sau khi đã get dữ liệu chat -> upload lên suggest
          // filteredMessages là danh sách tin nhắn 2 ng dùng, filterSenderMessages là tin nhắn ng gửi

          // _addMessagesToSmartReply(filteredMessages, filterSenderMessages);// Thêm các tin nhắn vào Smart Reply
// Sử dụng addPostFrameCallback để gọi _addMessagesToSmartReply sau khi StreamBuilder hoàn tất
            if (!_isMessagesProcessed && filteredMessages.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _addMessagesToSmartReply(filteredMessages, filterSenderMessages);
                setState(() {
                  _isMessagesProcessed = true; // Đánh dấu là đã xử lý
                });
              });
            }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              reverse: true,
              itemCount: filteredMessages.length,
              itemBuilder: (context, index) {
                final chatMessage = filteredMessages[index].data();
                final nextChatMessage = index + 1 < filteredMessages.length
                    ? filteredMessages[index + 1].data()
                    : null;

                final currentMessageUserId = chatMessage['idSender'];
                final nextMessageUserId = nextChatMessage != null
                    ? nextChatMessage['idSender']
                    : null;

                final nextUserIsSame =
                    nextMessageUserId == currentMessageUserId;

                if (nextUserIsSame) {
                  // Tin nhắn tiếp theo có phải là của người này nhắn không
                  return MessageBubble.next(
                    message: chatMessage['message'],
                    isMe: authUser.uid == currentMessageUserId,
                  );
                } else {
                  // Xác định người nhắn.
                  return MessageBubble.first(
                    userImage: chatMessage['userImage'],
                    username: chatMessage['userName'],
                    message: chatMessage['message'],
                    isMe: authUser.uid == currentMessageUserId,
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
