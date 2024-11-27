import 'package:chat_dating_app/models/CheckboxObject.dart';
import 'package:chat_dating_app/models/Hoppy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'CheckboxObject.dart';
import 'Address.dart';

const sex = ['Female', 'Male'];

class Person {
  String? id;
  String? email;
  String? name;
  String? phone;
  String? img;
  String? password;
  Address? address;
  DateTime? birthday;
  String? sex;
  List<CheckboxObject>? hobbiesList;
  List<CheckboxObject>? personalitiesList;

  // Address address;
  // String? _passwordConfirm;
  DateTime? _birthDay;

  // Person(this.email, this.name, this.phone, this.img, this.address);
  Person(this.id, this.email, this.name, this.phone, this.img, this.sex, this.birthday, this.address, this.hobbiesList, this.personalitiesList);

  Future storePerson() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set({
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'img': img
    });
  }
  factory Person.fromMap(Map<String, dynamic> data) {
    return Person(// Gán giá trị mặc định nếu null
      data['id'] ?? '',
      data['email'] ?? '',
      data['name'] ?? '',
      data['phone']?.toString() ?? '',
      data['img'] ?? '',
      data['sex'] ?? '',
      data['birthday'] is Timestamp
          ? (data['birthday'] as Timestamp).toDate()
          : DateTime.tryParse(data['birthday'] ?? '') ?? DateTime.now(), // Nếu không phải Timestamp, parse chuỗi hoặc gán ngày hiện tại
      data['address'] != null
          ? Address.fromMap(data['address'])
          : null, // Xử lý address nếu null

      (data['hobbies'] as List<dynamic>?) // Xử lý danh sách hobbiesList
          ?.map((e) => CheckboxObject.fromMap(e as Map<String, dynamic>))
          .toList() ??
          [], // Nếu null, gán danh sách rỗng
      (data['personal'] as List<dynamic>?) // Xử lý danh sách personalitiesList
          ?.map((e) => CheckboxObject.fromMap(e as Map<String, dynamic>))
          .toList() ??
          [], // Nếu null, gán danh sách rỗng
    );
  }

  // // Phương thức từ Map
  // factory Person.fromMap(Map<String, dynamic> data) {
  //   final addressData = data['address'] as Map<String, dynamic>?; // Lấy nested map từ address
  //   final address = addressData != null
  //       ? Address(
  //     lat: (data['lat'] as num?)?.toDouble() ?? 0.1,
  //     lng: (data['lng'] as num?)?.toDouble() ?? 0.1,
  //       road: addressData['road'],
  //       suburb: addressData['suburb'],
  //       city: addressData['city'],
  //       quarter: addressData['quarter'],
  //   )
  //       : null;
  //
  //   return Person(
  //     data['email'],
  //     data['name'],
  //     data['phone'],
  //     data['img'],
  //     address: address,
  //   )
  //     ..id = data['id']; // Gán id từ Map vào đối tượng
  // }


  factory Person.newPerson() {
    return Person(null, null, null, null, null, null, null, null, null, null);
  }

  int? get age {
    if (birthday == null) return null; // Nếu không có ngày sinh, trả về null
    final now = DateTime.now();
    int age = now.year - birthday!.year;
    if (now.month < birthday!.month || (now.month == birthday!.month && now.day < birthday!.day)) {
      age--; // Giảm tuổi đi 1 nếu chưa đến ngày sinh nhật trong năm nay
    }
    return age;
  }
  // String? get name => name;
  // set name(String? value) {
  //   name = value;
  // }
  //
  // String? get phone => phone;
  //
  // set phone(String? value) {
  //   phone = value;
  // } // bool isValid() => emailIsValid && passwordIsValid &&

  String? emailValidate(String value) {
    if (value == null || value
        .trim()
        .isEmpty)
      return 'Value is Empty';
    // if(email.is)
  }
  String? sexValidate(String? value) {
    if (value == null || value
        .trim()
        .isEmpty)
      return 'Please select your sex.';
    return null;  // Đúng sẽ return về null
    // if(email.is)
  }

  String? birthDayValidate(DateTime? value) {
    if (value == null) {
      return 'Please select your birth date.';
    }
    return null; // Không có lỗi
  }


  String? nameValidate(String name) {
    if (name == null || name
        .trim()
        .isEmpty)
      return 'Name not empty!';
  }

  String? phoneValidate(String value) {
    if (value == null || value
        .trim()
        .isEmpty)
      return 'Phone not empty!';
    if (value.length != 10)
      return 'Phone number is less than 10 characters!';
  }

  // String? birthDayValidate(String value) {
  //   if (value == null || value
  //       .trim()
  //       .isEmpty)
  //     return 'Birthday is Empty';
  // }

  String? passwordValidate(String value) {
    if (value == null || value
        .trim()
        .isEmpty)
      return 'Password is Empty';
    if (value.length < 6)
      return 'Password is Weak';
  }

  String? confirmPasswordValidate(String value, String confirmValue) {
    if (value == null || confirmValue == null || confirmValue
        .trim()
        .isEmpty)
      return 'Password not empty!';
    if (!value.contains(confirmValue))
      return 'Password not match!';
  }


  DateTime? get birthDay => _birthDay;

  set birthDay(DateTime? value) {
    _birthDay = value;
  }


  String? get passwordPerson => password;

  set passwordPerson(String? value) {
    password = value;
  }

  // String? get email => _email;
  // set email(String? value) {
  //   _email = value;
  // }
  //
  // String? get id => _id;
  // set id(String? value) {
  //   _id = value;
  // }

  @override
  String toString() {
    return 'Person{id: $id, email: $email, name: $name, phone: $phone, img: $img, sex: $sex, birthday: $birthday, address: $address, hobbiesList: $hobbiesList, personalitiesList: $personalitiesList}';
  }



// String? get imgPerson => _img;
//
// set imgPerson(String? value) {
//   _img = value;
// }
}

