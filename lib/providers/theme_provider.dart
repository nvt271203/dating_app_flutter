import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Lớp StateNotifier để quản lý trạng thái màu
class ThemeNotifier extends StateNotifier<Color> {
  ThemeNotifier() : super(const Color(0xFF2D99AE)); // Màu mặc định

  void updatePrimaryColor(Color newColor) {
    state = newColor; // Cập nhật trạng thái
  }
}

// Khai báo StateNotifierProvider
final themeProvider = StateNotifierProvider<ThemeNotifier, Color>(
      (ref) => ThemeNotifier(),
);
