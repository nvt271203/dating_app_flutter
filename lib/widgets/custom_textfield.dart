import 'package:flutter/material.dart';

class CustomTextfield extends StatefulWidget {
  final TextEditingController controler;
  final TextInputType? keyboardType;
  final bool? isObscureText;
  final String? obscureCharacter;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?) validator; // Thêm validator

  const CustomTextfield(
      {super.key,
      required this.controler,
      required this.hintText,
      required this.validator,
      this.keyboardType = TextInputType.text,
      this.isObscureText = false,
      this.obscureCharacter = "*",
      this.prefixIcon,
      this.suffixIcon,
      });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  // Biến lưu trữ trạng thái màu của icon
  Color _iconColor = Colors.black;

  // Hàm thay đổi màu icon khi nhấn
  void _changeIconColor() {
    setState(() {
      // Đổi màu giữa xanh và đỏ
      _iconColor = _iconColor == Colors.black ? Colors.blue : Colors.black;
    });
  }
  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   widget.controler.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double wight = MediaQuery.of(context).size.width;

    return TextFormField(
      validator: widget.validator,
      cursorColor: Colors.blue,
      controller: widget.controler,
      keyboardType: widget.keyboardType,
      obscureText: widget.isObscureText!,
      obscuringCharacter: widget.obscureCharacter!,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(top: 12),
        constraints: BoxConstraints(
          maxWidth: wight,
          maxHeight: height
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 14
        ),
        prefixIcon: widget.prefixIcon,
        // suffixIcon: widget.suffixIcon,
          suffixIcon: widget.suffixIcon != null
              ? IconButton(
            icon: Icon(
              Icons.visibility,
              color: _iconColor, // Đặt màu cho icon
            ),
            onPressed: _changeIconColor, // Gọi hàm thay đổi màu icon
          )
              : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: Colors.black,
            width: 1.0
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
              color: Colors.blue,
              width: 2.0
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
              color: Colors.black,
              width: 1.0
          ),
        )
      ),



    );
  }
}
