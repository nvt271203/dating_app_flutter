import 'package:chat_dating_app/tools/tools_colors.dart';
import 'package:flutter/material.dart';

// A MessageBubble for showing a single chat message on the ChatScreen.
class Itemmessage extends StatelessWidget {
  const Itemmessage.first({
    super.key,
    required this.userImage,
    required this.username,
    required this.message,
    required this.isMe,
  }) : isFirstInSequence = true;

  const Itemmessage.next({
    super.key,
    required this.message,
    required this.isMe,
  })  : isFirstInSequence = false,
        userImage = null,
        username = null;

  final bool isFirstInSequence;
  final String? userImage;
  final String? username;
  final String message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nếu không phải tin nhắn của bạn, thêm khoảng trống giả thay cho avatar.
        if (!isMe)
          userImage != null
              ? CircleAvatar(
            backgroundImage: NetworkImage(userImage!),
            backgroundColor: theme.colorScheme.primary.withAlpha(180),
            radius: 23,
          )
              : const SizedBox(width: 46), // Khoảng trống giả khi không có avatar.

        if (!isMe && userImage != null) const SizedBox(width: 10), // Khoảng cách giữa avatar và tin nhắn.

        Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (isFirstInSequence && username != null && !isMe)
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 4),
                child: Text(
                  username!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                color: isMe
                    ? ToolsColors.primary.withOpacity(0.5)
                    : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: !isMe && isFirstInSequence
                      ? Radius.zero
                      : const Radius.circular(12),
                  topRight: isMe && isFirstInSequence
                      ? Radius.zero
                      : const Radius.circular(12),
                  bottomLeft: const Radius.circular(12),
                  bottomRight: const Radius.circular(12),
                ),
              ),
              constraints: const BoxConstraints(maxWidth: 200),
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 14,
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 4,
              ),
              child: Text(
                message,
                style: TextStyle(
                  height: 1.3,
                  color: isMe
                      ? Colors.black87
                      : Colors.black,
                ),
                softWrap: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
