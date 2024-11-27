import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String idUserSender;
  String idUserReceiver;
  String message;
  DateTime time;

  Message(
      {required this.idUserSender,
      required this.idUserReceiver,
      required this.message,
      required this.time});

// Chuyển đổi từ dữ liệu Firestore thành Message
  factory Message.fromFirestore(Map<String, dynamic> data) {
    return Message(
      idUserSender: data['idUserSender'] ?? '',
      idUserReceiver: data['idUserReceiver'] ?? '',
      message: data['message'] ?? '',
      time: (data['time'] as Timestamp).toDate(), // Hoặc sử dụng .toDate() để lấy DateTime
      // time: data['time'] ?? '',
    );
  }}
