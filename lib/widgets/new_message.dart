// import 'dart:ffi';

import 'package:chat_dating_app/widgets/list_suggest.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_smart_reply/google_mlkit_smart_reply.dart';

class NewMessage extends StatefulWidget {
  // const NewMessage({super.key});
  // final List<String> suggestList;
  // final List<String> suggestList = [];
  final List<String> suggestedMessages;
  final String idUserReceiver;
  const NewMessage({Key? key, required this.suggestedMessages,required this.idUserReceiver}) : super(key: key);
  @override
  State<NewMessage> createState() => _NewMessageScreenState();
}

class _NewMessageScreenState extends State<NewMessage> {
  var _messageController = TextEditingController();
  String strItemSelected = ''; // Biến để lưu phần tử đc chọn từ new_message


  // final List<String> suggestList = [
  //   'Monkey D Luffy',
  //   'Roronoa Zoro',
  //   'Vinsmoke Sanji'
  // ];

  _itemSelected(String item) {
    setState(() {
      strItemSelected = item;
      print("itemSelected:  ${strItemSelected}");

      _submidMessageSuggest(strItemSelected);
    });
  }
  void _submidMessageSuggest(String strItemSelected) async{
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({

      'message': strItemSelected,
      'timeCreated': Timestamp.now(),
      'idSender': user.uid,
      'idReceiver': widget.idUserReceiver,

    });
  }


  void _submitMessage() async {
    final enterMessage = _messageController.text;
    if (enterMessage
        .trim()
        .isEmpty) {
      return;
    }
    //send message to firebase
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({
      // 'message': enterMessage,
      // 'created': Timestamp.now(),
      // 'userId': user.uid,
      // 'userName': userData.data()!['userName'],
      // 'userImage': userData.data()!['avatar'],
      'message': enterMessage,
      'timeCreated': Timestamp.now(),
      'idSender': user.uid,
      'idReceiver': widget.idUserReceiver,

    });

    // // For local user.
    // final smartReply = SmartReply();
    // smartReply.addMessageToConversationFromLocalUser(
    //     _messageController.text, DateTime.now().microsecondsSinceEpoch);

    // ẩn bàn phím khi gửi.
    FocusScope.of(context).unfocus();
    _messageController.clear();
  }

  _openDialogListSuggest() {
    showModalBottomSheet(
      // isScrollControlled: true,

      context: context,
      builder: (ctx) =>
          ListSuggest(
              // suggestList: suggestList, onItemSelected: _itemSelected
              suggestList: widget.suggestedMessages, onItemSelected: _itemSelected

    ),


    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.zero), // Bỏ bo góc
    )
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, bottom: 10, right: 5),
      child: Row(
        children: [
          IconButton(
            onPressed: _openDialogListSuggest,
            icon: Icon(Icons.featured_play_list),
            color: Theme
                .of(context)
                .colorScheme
                .primary,
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(labelText: 'Send a message...'),
            ),
          ),
          IconButton(
            onPressed: _submitMessage,
            icon: Icon(Icons.send),
            color: Theme
                .of(context)
                .colorScheme
                .primary,
          ),
        ],
      ),
    );
  }



}
