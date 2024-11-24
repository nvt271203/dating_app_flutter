// import 'package:chat_dating_app/datas/hoppy_list.dart';
// import 'package:chat_dating_app/models/CheckboxObject.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// class HobbiesStatusNotifier extends StateNotifier<List<CheckboxObject>> {
//
//   // Khởi tạo với danh sách ban đầu
//   HobbiesStatusNotifier(List<CheckboxObject> initialHobbies) : super(initialHobbies); // (supper) phải cùng kiểu dữ liệu muốn quản lý.  // Phương thức để thay đổi trạng thái của CheckboxObject
//
//   // Phương thức để reset lại trạng thái checkbox
//   void resetCheckBoxState() {
//     state = state.map((item) => item.copyWith(value: false)).toList();
//   }
//
//   // Phương thức chọn tất cả checkbox
//   void selectAllItems() {
//     state = [
//       for (var item in state) item.copyWith(value: true), // chọn tất cả checkbox
//     ];
//   }
//
//   // Phương thức chọn hoặc bỏ chọn một checkbox
//   void toggleItem(CheckboxObject item) {
//     state = [
//       // Kiểm tra xem phần từ
//       for (var existingItem in state)
//         if (existingItem.title == item.title)
//           existingItem.copyWith(value: !existingItem.value) // thay đổi trạng thái của item
//         else
//           existingItem,
//     ];
//   }
//
//   // Phương thức để kiểm tra xem tất cả checkbox đã được chọn chưa
//   bool get isAllSelected {
//     return state.every((item) => item.value);
//   }
// }
// final hobbiesStatusProvider = StateNotifierProvider<HobbiesStatusNotifier, List<CheckboxObject>>(
//   (ref) {
//     return HobbiesStatusNotifier();
//   },
// ); //StateProvider quản lý trạng thái thay đổi