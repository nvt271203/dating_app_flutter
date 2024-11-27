import 'dart:ui';

class ToolsColors {
  //-------------Xanh dương
  static Color primary = Color(0xFF2D99AE);
  //-------------Hồng cam
  // static const Color primary = Color(0xFFFE6C6C);
  //--------------Lam
  // static const Color primary = Color(0xFF006064);
  //--------------Hồng
  // static const Color primary = Color(0xFFE91263);

  // static const Color secondary = Color(0xFF00CCFF);
  static const Color background = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF000000);
  static const Color error = Color(0xFFBD2424);

  // Phương thức để cập nhật màu primary
  static void updatePrimaryColor(Color newColor) {
    primary = newColor;
  }
}
