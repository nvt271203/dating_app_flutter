import 'package:flutter/material.dart';
class HeaderUser extends StatelessWidget {
  const HeaderUser({super.key, required this.nameUser, required this.avatar, });
  final String nameUser;
  final String avatar;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(
            avatar,
          ),
          radius: 23,
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(nameUser),
        )
      ],
    );
  }
}
