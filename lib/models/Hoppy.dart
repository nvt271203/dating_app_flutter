import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
const uuid = Uuid();

class Hobby{
  final String? id;
  final String name;

  Hobby({required this.name}) : id = uuid.v4();
}