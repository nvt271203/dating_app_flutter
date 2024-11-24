import 'package:chat_dating_app/widgets/item_suggest.dart';
import 'package:flutter/material.dart';

class ListSuggest extends StatelessWidget {
  const ListSuggest({
    super.key,
    required this.suggestList, required this.onItemSelected,

  });

  final List<String> suggestList;
  final Function(String) onItemSelected; // Định nghĩa Function nhận String làm tham số
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true, // chiều cao list bọc theo các phần tử
      itemCount: suggestList.length,
      itemBuilder: (context, index) {
        // ItemSuggest(suggest: suggestList[index]  // thay vì truyền vào 1 item, ta sẽ lắng nge 1 item
        return GestureDetector(
          onTap: () {
            String selectedItem = suggestList[index];
            // print("itemClicked:  ${selectedItem}");

            onItemSelected(selectedItem); // Gọi hàm callback khi nhấn item

            Navigator.of(context).pop(); // Ẩn bottom dialog sau mỗi lần nhấn.
          },
          child: ItemSuggest(suggest: suggestList[index]),
        );
      },
    );
  }
}
