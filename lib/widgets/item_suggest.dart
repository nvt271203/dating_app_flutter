import 'package:flutter/material.dart';
class ItemSuggest extends StatelessWidget {
  const ItemSuggest({super.key, required this.suggest});
  final String suggest;
  @override
  Widget build(BuildContext context) {
    return Card(

      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(child: Text(suggest)),
      ),
    );
  }
}
