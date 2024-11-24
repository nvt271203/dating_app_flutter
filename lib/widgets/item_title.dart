import 'package:chat_dating_app/tools/tools_colors.dart';
import 'package:flutter/material.dart';
class ItemTitle extends StatelessWidget {
  const ItemTitle({super.key, required this.title, required this.isChecked});
  final String title;
  final bool isChecked;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: isChecked ? ToolsColors.primary.withOpacity(0.1) : Colors.grey.withOpacity(0.1), // Màu nền dựa trên trạng thái
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isChecked ? ToolsColors.primary : Colors.grey, // Màu viền
            width: 2, // Độ dày viền
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(title, style: TextStyle(
            color: isChecked ? ToolsColors.primary : Colors.black,
          ),),
        ),
    );
  }
}
