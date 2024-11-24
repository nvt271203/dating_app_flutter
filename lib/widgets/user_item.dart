import 'package:chat_dating_app/screens/update_chat_user.dart';
import 'package:flutter/material.dart';

class UserItem extends StatelessWidget {
  final String userId;
  final String userName;
  final String userImageUrl;

  const UserItem({
    super.key,
    required this.userId,
    required this.userName,
    required this.userImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, ChatUserScreen.route(userId));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(userImageUrl),
            ),
            const SizedBox(width: 16),
            Text(
              userName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}