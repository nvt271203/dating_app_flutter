class CheckboxObject {
  String title;
  bool value;

  CheckboxObject({required this.title, this.value = false});
// Phương thức toMap để chuyển đổi thành Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'value': value,
    };
  }
  // Phương thức fromMap để chuyển đổi từ Map sang CheckboxObject
  factory CheckboxObject.fromMap(Map<String, dynamic> map) {
    return CheckboxObject(
      title: map['title'] ?? '',
      value: map['value'] ?? false,
    );
  }

  // Phương thức copyWith
  CheckboxObject copyWith({
    String? title,
    bool? value,
  }) {
    return CheckboxObject(
      title: title ?? this.title,
      // Sử dụng giá trị mới nếu được truyền vào, nếu không giữ nguyên giá trị hiện tại
      value: value ?? this.value,
    );
  }
}
// Lỗi xảy ra vì bạn đang sử dụng các trường _title và _value với dấu gạch dưới _,
// điều này có nghĩa là chúng là biến private (riêng tư) trong lớp CheckboxModal.
// Tuy nhiên, trong constructor của lớp, bạn đang cố gắng truyền tham số vào
// nhưng lại không thể truy cập chúng ngoài lớp vì chúng được khai báo là private.
