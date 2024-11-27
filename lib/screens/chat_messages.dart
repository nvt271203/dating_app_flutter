import 'package:chat_dating_app/models/Person.dart';
import 'package:chat_dating_app/tools/tools_colors.dart';
import 'package:chat_dating_app/widgets/ItemMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_smart_reply/google_mlkit_smart_reply.dart' as mlkit;

import '../models/Message.dart';
import '../widgets/list_suggest.dart';

class ChatMessagesScreen extends StatefulWidget {
  const ChatMessagesScreen({
    super.key, required this.personReceiver,
  });

  final Person personReceiver;

  @override
  State<ChatMessagesScreen> createState() => _ChatMessagesScreenState();
}

class _ChatMessagesScreenState extends State<ChatMessagesScreen> {
  final TextEditingController _messageController = TextEditingController(); //
  bool isLoading = true;
  List<Message> messagesList = [];

  List<String>? suggestedMessagesList;
  late mlkit.SmartReply smartReply;

  void _addMessagesToSmartReply(List<Message> messagesList) {
    smartReply.clearConversation(); // Xóa cuộc hội thoại cũ

    // Phải gán lại 1 biến lưu danh sách tin nhắn, nếu ko, khi sắp xếp, nó ảnh hưởng đến tin nhắn ban đầu.
    // Tạo bản sao độc lập của danh sách
    List<Message> messageListTemp = List.from(messagesList);

    // Sắp xếp bản sao mà không ảnh hưởng đến danh sách gốc
    messageListTemp.sort((a, b) => a.time.compareTo(b.time));

    // Xóa cuộc hội thoại cũ trong Smart Reply nếu cần
    // smartReply.clearConversation();

    for (final message in messageListTemp) {
      final time = message.time.millisecondsSinceEpoch;
      // Nếu danh sách chat chứa user hiện tại -> ng dùng hiện tại.
      if(message.idUserSender.contains(FirebaseAuth.instance.currentUser!.uid)){
        print('check dk: true');
        smartReply.addMessageToConversationFromLocalUser(message.message, time);
      }else{
        print('check dk: false');
        smartReply.addMessageToConversationFromRemoteUser(message.message, time, message.idUserReceiver);
      }
    }
    _suggestMessages();
  }
  // void _addNewMessagesToSmartReply(Message message) {
  //   final time = message.time.millisecondsSinceEpoch;
  //
  //   if (message.idUserSender.contains(FirebaseAuth.instance.currentUser!.uid)) {
  //     smartReply.addMessageToConversationFromLocalUser(message.message, time);
  //   } else {
  //     smartReply.addMessageToConversationFromRemoteUser(message.message, time, message.idUserReceiver);
  //   }
  //
  //   print("Suggestions before adding new message: $suggestedMessagesList");
  //   _suggestMessages();
  //   print("Suggestions after adding new message: $suggestedMessagesList");
  // }




  void _suggestMessages() async {
    print('------suggest');

    List<String> tempListSuggest = []; // Tạo danh sách tạm

    final response = await smartReply.suggestReplies();
    print('------suggest${response.toJson()}');

    if (response.suggestions.isEmpty) {
      print('No suggestions available');
    } else {
      for (final suggestion in response.suggestions) {
        print('dataSuggestMessage: ${suggestion}');
        tempListSuggest.add(suggestion);
      }
    }

    // Cập nhật danh sách gợi ý sau khi xử lý xong
    setState(() {
      suggestedMessagesList = tempListSuggest;
    });

    print('suggestionlistSuggestMessages: $suggestedMessagesList');
  }




  _openDialogListSuggest() {
    // Kiểm tra nếu danh sách tin nhắn rỗng
    final List<String> currentSuggestList = messagesList.isEmpty
        ? ['How are you today ?', 'Nice to meet you !', 'Can I have your name ?'] // Gợi ý mặc định
        : (suggestedMessagesList ?? []); // Gợi ý từ SmartReply hoặc danh sách rỗng


    showModalBottomSheet(
        context: context,
        builder: (ctx) =>
            ListSuggest(
              // suggestList: suggestList, onItemSelected: _itemSelected
                suggestList: currentSuggestList
                , onItemSelected: _itemSelected
            ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.zero), // Bỏ bo góc
        )
    );
  }
  _itemSelected(String item) {
      _messageController.text = item;
      _sendMessage();

  }


  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      final newMessage = Message(
        idUserSender: FirebaseAuth.instance.currentUser!.uid,
        idUserReceiver: widget.personReceiver.id.toString(),
        message: _messageController.text,
        time: Timestamp.now().toDate(),
      );

      setState(() {
        messagesList.add(newMessage); // Thêm tin nhắn mới vào danh sách
      });

      FirebaseFirestore.instance.collection('messages').add({
        'message': newMessage.message,
        'time': Timestamp.now(),
        'idUserSender': newMessage.idUserSender,
        'idUserReceiver': newMessage.idUserReceiver,
      }).then((_) {
        // Sau khi gửi tin nhắn thành công, cập nhật Smart Reply
        _addMessagesToSmartReply(messagesList);
        _suggestMessages(); // Gọi lại hàm gợi ý tin nhắn
      }).catchError((error) {
        print('Error sending message: $error');
      });

      // Xóa nội dung nhập sau khi gửi
      _messageController.clear();
    }
  }



  @override
  void initState() {
    super.initState();
    smartReply = mlkit.SmartReply();

    // Lắng nghe tin nhắn mới từ Firestore theo thời gian thực
    FirebaseFirestore.instance
        .collection('messages')
        .orderBy('time', descending: true) // Lấy tin nhắn mới nhất trước
        .snapshots() // Sử dụng snapshots() để lắng nghe thay đổi
        .listen((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        // Dữ liệu mới từ Firestore
        List<Message> loadedMessages = querySnapshot.docs.map((doc) {
          return Message.fromFirestore(doc.data() as Map<String, dynamic>);
        }).toList();

        // Lọc tin nhắn theo người dùng hiện tại và người nhận
        List<Message> filteredMessages = loadedMessages.where((itemMessage) {
          return (itemMessage.idUserSender ==
              FirebaseAuth.instance.currentUser!.uid &&
              itemMessage.idUserReceiver == widget.personReceiver.id) ||
              (itemMessage.idUserReceiver ==
                  FirebaseAuth.instance.currentUser!.uid &&
                  itemMessage.idUserSender == widget.personReceiver.id);
        }).toList();

        print('filteredMessages: ${filteredMessages.length}');
        setState(() {
          messagesList = filteredMessages; // Cập nhật danh sách tin nhắn
          isLoading = false;
        });

        // Cập nhật Smart Reply với các tin nhắn mới
        _addMessagesToSmartReply(filteredMessages); // Gọi lại để cập nhật tin nhắn gợi ý
      } else {
        print('No messages found.');
      }
    }, onError: (error) {
      print('Error fetching messages: $error');
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Ảnh đại diện
            CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(widget.personReceiver.img.toString()),
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(width: 12.0),
            // Tên người dùng
            Text(
              widget.personReceiver.name.toString(),
              style: TextStyle(fontSize: 18.0),
            ),
            const Spacer(),
          ],
        ),
      ),
      body: Column(
        children: [
          // Phần tin nhắn
          isLoading
              ? Expanded(
                  child: Center(child: const CircularProgressIndicator()))
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      reverse: true,
                      itemCount: messagesList.length,
                      itemBuilder: (context, index) {
                        final chatMessage = messagesList[index];
                        final nextChatMessage = index + 1 < messagesList.length
                            ? messagesList[index + 1]
                            : null;

                        final currentMessageUserId = messagesList[index].idUserSender;
                        final nextMessageUserId = nextChatMessage != null
                            ? nextChatMessage.idUserSender
                            : null;

                        final nextUserIsSame =
                            nextMessageUserId == currentMessageUserId;

                        if (nextUserIsSame) {
                          // Tin nhắn tiếp theo có phải là của người này nhắn không
                          return Itemmessage.next(
                            message: chatMessage.message,
                            isMe: FirebaseAuth.instance.currentUser!.uid == currentMessageUserId,
                          );
                        } else {
                          // Xác định người nhắn.
                          return Itemmessage.first(
                            userImage: widget.personReceiver.img,
                            username: widget.personReceiver.name,
                            message: chatMessage.message,
                            isMe: FirebaseAuth.instance.currentUser!.uid == currentMessageUserId,
                          );
                        }
                      },
                    ),
                  ),
                ),
          Container(
            decoration: BoxDecoration(color: ToolsColors.primary),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Gợi ý tin nhắn
                  IconButton(
                    onPressed: _openDialogListSuggest,
                    // onPressed: (){},
                    icon: Icon(Icons.featured_play_list),
                    color: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                  ),
                  // const SizedBox(width: 8.0),
                  // Vùng nhập tin nhắn
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      // Gắn controller vào TextField
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        filled: true,
                        // Kích hoạt màu nền
                        fillColor: Colors.white,
                        // Màu nền là màu trắng,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  // Nút gửi tin nhắn
                  IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => _sendMessage(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
