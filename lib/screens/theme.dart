import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';

class ThemeScreen extends ConsumerWidget {
  final List<Color> colors = [
    const Color(0xFF2D99AE),
    const Color(0xFFFE6C6C),
    const Color(0xFF006064),
    const Color(0xFFE91263),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Theo dõi trạng thái của themeProvider
    final themeState = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tùy biến giao diện'),
        backgroundColor: themeState,
      ),
      body: ListView.builder(
        itemCount: colors.length,
        itemBuilder: (context, index) {
          final color = colors[index];

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: color,
            ),
            title: Text(
              'Màu ${index + 1}',
              style: TextStyle(color: color),
            ),
            onTap: () {
              // Cập nhật màu bằng ThemeNotifier
              ref.read(themeProvider.notifier).updatePrimaryColor(color);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Bạn đã chọn màu mới!',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: color,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
