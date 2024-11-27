import 'package:chat_dating_app/screens/chat_messages.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Thêm thư viện intl
import '../../models/Message.dart';
import '../../models/Person.dart';
import '../../tools/tools_colors.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  late List<Message> lastMessages = [];
  late List<Person> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    fetchLastMessages();
  }

  void fetchLastMessages() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance
        .collection('messages')
        .orderBy('time', descending: true)
        .snapshots()
        .listen((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        Map<String, Message> latestMessages = {};

        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          String idUserSender = data['idUserSender'];
          String idUserReceiver = data['idUserReceiver'];

          if (idUserSender == currentUserId || idUserReceiver == currentUserId) {
            String chatPartnerId = idUserSender == currentUserId
                ? idUserReceiver
                : idUserSender;

            if (!latestMessages.containsKey(chatPartnerId)) {
              latestMessages[chatPartnerId] = Message.fromFirestore(data);
            }
          }
        }

        List<Message> lastMessagesList = latestMessages.values.toList();

        setState(() {
          lastMessages = lastMessagesList;
        });
        fetchUsersFromLastMessages();
      } else {
        print('Không có tin nhắn nào.');
      }
    });
  }

  void fetchUsersFromLastMessages() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    Set<Person> usersSet = {};

    for (Message message in lastMessages) {
      String chatPartnerId = message.idUserSender == currentUserId
          ? message.idUserReceiver
          : message.idUserSender;

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(chatPartnerId)
          .get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
        Person user = Person.fromMap(userData);

        usersSet.add(user);
      }
    }

    setState(() {
      filteredUsers = usersSet.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ToolsColors.primary.withOpacity(0.8),
              Colors.white,
            ],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(15.0),
          itemCount: lastMessages.length,
          itemBuilder: (context, index) {
            final message = lastMessages[index];
            final chatPartnerId = message.idUserSender == FirebaseAuth.instance.currentUser!.uid
                ? message.idUserReceiver
                : message.idUserSender;

            final user = filteredUsers.firstWhere(
                  (user) => user.id == chatPartnerId,
              orElse: () => Person.newPerson(),
            );

            // Chuyển đổi Timestamp thành DateTime
            DateTime messageTime = message.time.toLocal();

            // Dùng DateFormat để hiển thị thời gian theo định dạng có AM/PM
            String formattedTime = DateFormat('h:mm').format(messageTime);  // h:mm a -> giờ:phút AM/PM

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 7.0),
              child: GestureDetector(
                onTap: () {
                  // Điều hướng đến màn hình chat với người này
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatMessagesScreen(personReceiver: user),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Màu nền
                    border: Border.all(width: 1, color: ToolsColors.primary.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(20.0), // Bo góc ngoài
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 4, offset: Offset(0, 2))], // Tạo bóng mờ
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30.0,
                        backgroundImage: NetworkImage(user.img ?? 'default_image_url'),
                        backgroundColor: Colors.grey[200],
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name ?? 'Loading...',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${message.idUserSender == FirebaseAuth.instance.currentUser!.uid ? 'You' : user.name}: ${message.message}',
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                // Thêm thời gian tin nhắn với AM/PM
                                Text(
                                  formattedTime,
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
