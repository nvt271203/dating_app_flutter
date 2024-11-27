import 'package:chat_dating_app/screens/auth.dart';
import 'package:chat_dating_app/screens/bottom_bar/world.dart';
import 'package:chat_dating_app/screens/first_options/Intro.dart';
import 'package:chat_dating_app/screens/first_options/hoppy.dart';
import 'package:chat_dating_app/screens/first_options/map.dart';
import 'package:chat_dating_app/screens/splash.dart';
import 'package:chat_dating_app/screens/tabs.dart';
import 'package:chat_dating_app/tools/tools_colors.dart';
import 'package:chat_dating_app/widgets/location_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

// var kColorScheme = ColorScheme.fromSeed(seedColor: const Color.fromARGB(200, 204, 222, 255));
// var kColorScheme = ColorScheme.fromSeed(seedColor: Color(0xFF00CCFF));
var kColorScheme = ColorScheme.fromSeed(seedColor: Color(0xFF2D99AE));
// var kColorScheme = ColorScheme.fromSeed(seedColor: Colors.redAccent);
var kColorSchemeWhite = ColorScheme.fromSeed(seedColor: Colors.white);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  var currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat Dating App",
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: ToolsColors.primary,
          foregroundColor: Colors.black,
        ),
        textTheme: ThemeData().textTheme.copyWith(
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color: kColorScheme.onSecondaryContainer,
            fontSize: 16,
          ),
        ),
      ),
      home: currentUser != null
          ? TabsCreen()  // Nếu có người dùng hiện tại thì hiển thị TabsScreen
          : AuthStateScreen(),  // Nếu không có người dùng hiện tại thì hiển thị AuthStateScreen
    );
  }
}