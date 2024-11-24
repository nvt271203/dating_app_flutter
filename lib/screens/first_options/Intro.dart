import 'package:chat_dating_app/screens/first_options/hoppy.dart';
import 'package:chat_dating_app/tools/tools_colors.dart';
import 'package:chat_dating_app/widgets/location_input.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({
    super.key,
    required this.idPerson,
    required this.namePerson,
  });

  final String idPerson;
  final String namePerson;

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  void _navigatorHobby(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      // builder: (context) => HobbyScreen(idPerson: widget.idPerson,),
      builder: (context) => LocationScreen(idPerson: widget.idPerson,),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Xin chào ${widget.namePerson}',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // Căn giữa theo trục dọc
            crossAxisAlignment: CrossAxisAlignment.center,
            // Căn giữa theo trục ngang
            children: [
              // Text(
              //   'Chào mừng bạn đến với hành trình tìm kiếm một nữa kia của bạn nha, ${widget.name}',
              //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              //   textAlign: TextAlign.center, // Căn giữa văn bản
              // ),
              // const SizedBox(
              //   height: 16,
              // ),
              // Image.asset('assets/images/bg_dating_app.png'),

              Text(
                'Đồng hành cùng mình để tìm kiếm một nữa kia của bạn nha, \n ${widget.namePerson} !',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.center, // Căn giữa văn bản
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'Liệu thói quen của người ấy có phù hợp với bạn không? Bạn hãy chia sẻ trước để mọi người có thể hiểu thêm về bạn nè.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
                // Căn giữa văn bản
              ),
              SizedBox(height: 24,),

              TextButton(
                onPressed: () {
                  _navigatorHobby(context);
                },
                child: Text(
                  'Bắt đầu nào',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: ToolsColors.primary, // Màu nền
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0), // Padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0), // Bo viền
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
