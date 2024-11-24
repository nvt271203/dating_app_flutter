import 'dart:convert';
import 'dart:io';
import 'package:chat_dating_app/models/Address.dart';
import 'package:chat_dating_app/models/Person.dart';
import 'package:chat_dating_app/screens/first_options/Intro.dart';
import 'package:chat_dating_app/screens/first_options/hoppy.dart';
import 'package:chat_dating_app/screens/tabs.dart';
import 'package:chat_dating_app/tools/tools_colors.dart';
import 'package:chat_dating_app/tools/tools_format.dart';
import 'package:chat_dating_app/widgets/custom_textfield.dart';
import 'package:http/http.dart' as http;

import 'package:chat_dating_app/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//
final _auth = FirebaseAuth.instance;

class AuthStateScreen extends StatefulWidget {
  // const AuthStateScreen({super.key});// Hàm callback

  const AuthStateScreen({Key? key})
      : super(key: key);

  @override
  State<AuthStateScreen> createState() => _AuthStateScreenState();
}

class _AuthStateScreenState extends State<AuthStateScreen> {
  // void _navigatorHoppy(BuildContext context){
  //   Navigator.of(context).push(
  //       MaterialPageRoute(builder: (context) => const HoppyScreen(),)
  //   );
  // }

  Person person = Person.newPerson();

  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  // final _birthdayController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // late String _sexChoose = '';
  String _sexSelected = '';
  DateTime? _birthdaySelected;



  final _form = GlobalKey<FormState>();

  File? _selectedImage;
  String? _urlSelectedImage;

  String? _sexError;
  String? _birthdayError;


  var _isLogin = true;
  var _isAuthencating = false;

  Future<void> _uploadImageCloudinary() async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/ds3ixhrkd/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'ozxucvod'
      // ..fields['transformation'] = 'w_1000,h_1000' // Cập nhật kích thước ảnh nếu cần
      ..files.add(await http.MultipartFile.fromPath('file', _selectedImage!.path));
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);
      print("Response Map: $jsonMap");
      final url = jsonMap['url'];
      print('urlImage: $url ');
      _urlSelectedImage = url;
    }
  }



  void _submit() async {
    final isValid = _form.currentState!.validate(); // xác thực ở validator của EditText.

    // Kiểm tra đối với trạng thái đăng kí
    if(!_isLogin){
      setState(() {
        // Kiểm tra ngày sinh
        _birthdayError = person.birthDayValidate(_birthdaySelected);
        _sexError = person.sexValidate(_sexSelected);
      });
    }

    // Kiểm tra đối với trạng thái đăng kí.
    if(!_isLogin) {
      if (!isValid || _birthdayError != null || _sexError != null) {
        return; // Ngừng nếu có lỗi
      }
    }

    // Kiểm tra đối với trạng thái đăng nhập.
    if (!isValid) {
      // if (!isValid || _selectedImage == null) {
      return;
    }

    // lưu lại dữ liệu trạng thái biểu mẫu hiện tại cách nhận biết là SAVE - onSaved()
    _form.currentState!.save();

    setState(() {
      // Tắt trạng thái scrollbar
      _isAuthencating = true;
    });
    try {
      if (_isLogin) {
        final userCredentials = await _auth.signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Login success.')));

        // Gửi trạng thái đăng nhập qua callback
        // widget.onAuthStateChange('login', userCredentials.user!.uid);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => TabsCreen(),
        ));
      } else {
        // Lưu trữ dữ liệu ảnh.
        await _uploadImageCloudinary();

        if (_urlSelectedImage == null) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to retrieve image URL.')));

          setState(() {
            _isAuthencating = false;
          });

          return;
        }


        // Quá trình đăng kí.
        final userCredentials = await _auth.createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);





// ++++++++++++++++++++++++++
        // person = Person(_emailController.text, _nameController.text,
        //     _phoneController.text, _urlSelectedImage);
        // person.id = userCredentials.user!.uid;
        // await person.storePerson(); // upload data FireStore
// ++++++++++++++++++++++++++++++
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'id': userCredentials.user!.uid,
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'img': _urlSelectedImage,
          'sex': _sexSelected,
          'birthday': _birthdaySelected
        });



        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Register success.')));
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => IntroScreen(idPerson: userCredentials.user!.uid, namePerson: _nameController.text),
        ));

        // widget.onAuthStateChange('register');
        // widget.onAuthStateChange('register', userCredentials.user!.uid);
      }
    } on FirebaseException catch (error) {
      if (error.code == 'mail-already-in-use') {}
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'Authencation failed!')));
    }

    setState(() {
      _isAuthencating = false;
    });
  }

  void _presentDatePicker() async{
    final now = DateTime.now();
    final firstDay = DateTime(now.year - 100, now.month, now.day);
    final pickedDate = await showDatePicker(context: context, firstDate: firstDay, lastDate: now);
    setState(() {
      _birthdaySelected = pickedDate;
    });
  }

  void resetDataDefault(){
    _phoneController.clear();
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // if(!_isLogin){
    //   resetDataDefault();
    // }

    return Scaffold(
      backgroundColor: Color(0xFFD7DDF3),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 30, bottom: 20, left: 20, right: 20),
                width: 200,
                child: Image.asset('assets/images/bg_dating_app.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Form(
                        key: _form,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Trong TH register ms hiển thị avt để hiển thị ảnh
                            if (!_isLogin)
                              UserImagePicker(
                                onPickedImage: (pickedImage) {
                                  _selectedImage = pickedImage;
                                },
                              ),
                            // Trong TH register ms hiển thị tên để đăng kí
                            if (!_isLogin)
                              CustomTextfield(
                                controler: _nameController,
                                hintText: "User Name",
                                keyboardType: TextInputType.text,
                                prefixIcon: Icon(Icons.person),
                                validator: (value) {
                                  // person.nameValidate(_nameController.text);
                                  return person
                                      .nameValidate(_nameController.text);
                                },
                              ),
                            if (!_isLogin)
                              const SizedBox(
                                height: 15,
                              ),
                            if (!_isLogin)
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.center,  // Căn giữa các phần tử bên trong nó
                                    padding: EdgeInsets.symmetric(horizontal: 16),  // Thêm padding nếu cần
                                    decoration: BoxDecoration(
                                      color: ToolsColors.primary.withOpacity(0.1),
                                      border: Border.all(color: ToolsColors.primary,width: 2),
                                      borderRadius: BorderRadius.circular(50),

                                    ),
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      dropdownColor: Colors.white, // Màu nền danh sách itemDropdown
                                      value:  _sexSelected.isEmpty ? null : _sexSelected,
                                      hint: Center(
                                        child: Text('Choose Sex', style: TextStyle(
                                          fontSize: 14
                                        ),),
                                      ),
                                      style: TextStyle(
                                        color: Colors.black
                                      ),
                                        items: sex.map(
                                          (item) {
                                            return DropdownMenuItem(
                                                child: Text(item), value: item);
                                          },
                                        ).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _sexSelected = value!;
                                          });
                                        },),
                                  ),
                                  SizedBox(width: 10,),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      decoration: BoxDecoration(
                                        color: ToolsColors.primary.withOpacity(0.1),
                                        border: Border.all(color: ToolsColors.primary, width: 2),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: TextButton.icon(
                                        onPressed: () {
                                          _presentDatePicker();
                                        },
                                        label: Text(
                                          _birthdaySelected == null
                                              ? "Choose BirthDay"
                                              : ToolsFormat.formatter(_birthdaySelected!).toString(),
                                          style: TextStyle(color: ToolsColors.primary),
                                        ),
                                        icon: const Icon(Icons.calendar_month),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                            // SHow error
                            if(!_isLogin)
                            if(_birthdayError!= null || _sexError != null)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  if (_sexError != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        _sexError!,
                                        style: TextStyle(color: ToolsColors.error, fontSize: 12),
                                      ),
                                    ),

                                  if (_birthdayError != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        _birthdayError!,
                                        style: TextStyle(color: ToolsColors.error, fontSize: 12),
                                      ),
                                    ),

                                ],
                              ),


                            if (!_isLogin)
                              const SizedBox(
                                height: 15,
                              ),
                            if (!_isLogin)
                              CustomTextfield(
                                controler: _phoneController,
                                hintText: "Phone Number",
                                keyboardType: TextInputType.text,
                                prefixIcon: Icon(Icons.phone),
                                validator: (value) {
                                  return person
                                      .phoneValidate(_phoneController.text);
                                },
                              ),

                            if (!_isLogin)
                              const SizedBox(
                                height: 15,
                              ),
                            CustomTextfield(
                              controler: _emailController,
                              hintText: "Email Address",
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icon(Icons.email),
                              validator: (value) {
                                return person
                                    .emailValidate(_emailController.text);
                              },
                            ),

                            const SizedBox(
                              height: 15,
                            ),
                            CustomTextfield(
                              controler: _passwordController,
                              hintText: "Password",
                              keyboardType: TextInputType.visiblePassword,
                              prefixIcon: Icon(Icons.password),
                              validator: (value) {
                                return person
                                    .passwordValidate(_passwordController.text);
                              },
                            ),

                            const SizedBox(
                              height: 15,
                            ),
                            if (_isAuthencating)
                              const CircularProgressIndicator(),
                            if (!_isAuthencating)
                              ElevatedButton(
                                  onPressed: _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ToolsColors.primary,
                                  ),
                                  child: Text(_isLogin ? 'Login' : 'Signup', style: TextStyle(
                                    color: Colors.white
                                  ),)),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                                child: Text(_isLogin
                                    ? 'Create an account'
                                    : 'I already have an account'))
                          ],
                        )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
