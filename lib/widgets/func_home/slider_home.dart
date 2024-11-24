import 'package:chat_dating_app/tools/tools_colors.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SliderHome extends StatefulWidget {
  const SliderHome({super.key});

  @override
  State<SliderHome> createState() => _SliderHomeState();
}

// 1 phải import carouse_slider -> sau đi imort thì kéo thư viện vào
// 2 phải import smooth_page_indication -> tạo dãi trạng thái slider -> sau khi import thì import thư viện vào
class _SliderHomeState extends State<SliderHome> {
  // 2 tạo list item để hiển thị slider
  final _listItem = [
    Image.asset('assets/images/son_tung_mtp.jpg'),
    Image.asset('assets/images/son_tung_mtp.jpg'),
    Image.asset('assets/images/son_tung_mtp.jpg'),
    Image.asset('assets/images/son_tung_mtp.jpg'),
    Image.asset('assets/images/son_tung_mtp.jpg'),
  ];

  // 3 lưu trữ index của slider đc chọn
  int myCurrentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            ToolsColors.primary.withOpacity(0.5),
            Colors.white,

          ])
        ),
        child: Column(
          children: [

            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text('Slider intro', style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18
              ),),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    height: 250,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    // Hiệu ứng chuyển động(nhanh ở đầu và chậm khi kết thúc)
                    autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                    // tgian chuyển đổi 1s
                    autoPlayInterval: const Duration(seconds: 2),
                    enlargeCenterPage: true,
                    // true: slide hiện tại đc phóng to, false sẽ bằng nhau
                    aspectRatio: 2.0,
                    // Tỉ lệ khung hình chiều rộng so vs height
                    onPageChanged: (index, reason) {
                      setState(() {
                        myCurrentIndex = index;
                      });
                    },
                    viewportFraction: 0.6, // Điều chỉnh tỷ lệ hiển thị mỗi item
                    scrollPhysics: BouncingScrollPhysics(), // Mượt mà hơn khi kéo
                  ),
                  items: _listItem,
                ),
              ),
            ),
            SizedBox(height: 10,),
            AnimatedSmoothIndicator(
              activeIndex: myCurrentIndex,
              count: _listItem.length,
              effect: const WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                spacing: 7,
                dotColor: Colors.grey,
                activeDotColor: Colors.black,
                paintStyle: PaintingStyle.fill
              ),
            ),
            SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }
}
