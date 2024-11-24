import 'package:intl/intl.dart';

class ToolsFormat{
  static String formatter (DateTime birthday){
    return DateFormat('dd/MM/yyyy').format(birthday);

  }
}