import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chat_dating_app/datas/hoppy_list.dart';

final hobbiesProvider = Provider((ref){
  return hobbyList;
});