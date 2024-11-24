import 'package:chat_dating_app/models/Person.dart';
import 'package:chat_dating_app/tools/tools_colors.dart';
import 'package:chat_dating_app/widgets/item_detail_user.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemIntroUser extends StatefulWidget {
  const ItemIntroUser({super.key, required this.person});

  final Person person;
  @override
  State<ItemIntroUser> createState() => _ItemIntroUserState();
}

class _ItemIntroUserState extends State<ItemIntroUser> {
  void _navigatorDetailUser(BuildContext context){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ItemDetailUser(person: widget.person, showBar: true,),)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // bo góc
      ),
      clipBehavior: Clip.hardEdge,
      // bất kì phần tử nào tràn ra ngoài đều bị cắt.
      elevation: 20,

      // Đổ bóng
      child: InkWell(
        onTap: () => _navigatorDetailUser(context),
        child: Stack(
          children: [
            Positioned.fill( // ---------- Dùng để chiếm full kích thước theo cha
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                // image: const AssetImage('assets/images/son_tung_mtp.jpg'),
                image: NetworkImage(widget.person.img.toString()),
                fit: BoxFit.cover, // Ảnh sẽ phủ đầy Card
                width: double.infinity,

                alignment: Alignment.center, // Căn giữa ảnh
              ),
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,

                child: Container(
                  color: ToolsColors.primary.withOpacity(0.6),
                  padding: EdgeInsets.all(5),

                  child: Column(
                    children: [
                      const SizedBox(height: 5,),
                       Text(
                        widget.person.name.toString(),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Căn đều các phần tử
                        children: [
                          Container(
                            width: 35, // Chiều rộng của nút
                            height: 35, // Chiều cao của nút
                            decoration: BoxDecoration(
                              color: Colors.white, // Màu nền
                              borderRadius: BorderRadius.circular(10), // Bo góc
                            ),
                            child: IconButton(
                              onPressed: () {},
                              iconSize: 20,
                              icon: const Icon(Icons.add_reaction),
                              color: Colors.brown, // Màu biểu tượng
                            ),
                          ),
                          Container(
                            width: 35, // Chiều rộng của nút
                            height: 35, // Chiều cao của nút
                            decoration: BoxDecoration(
                              color: Colors.white, // Màu nền
                              borderRadius: BorderRadius.circular(10), // Bo góc
                            ),
                            child: IconButton(
                              onPressed: () {},
                              iconSize: 20,
                              icon: const Icon(Icons.message),
                              color: Colors.teal, // Màu biểu tượng
                            ),
                          ),
                          Container(
                            width: 35, // Chiều rộng của nút
                            height: 35, // Chiều cao của nút
                            decoration: BoxDecoration(
                              color: Colors.white, // Màu nền
                              borderRadius: BorderRadius.circular(10), // Bo góc
                            ),
                            child: IconButton(
                              onPressed: () {},
                              iconSize: 20,
                              icon: const Icon(Icons.favorite_border),
                              color: Colors.red, // Màu biểu tượng
                            ),
                          )

                        ],
                      ),
                      const SizedBox(height: 10,),

                    ],
                  ),
                )),
            Positioned(
                top: 0,

                right: 0,
                height: 30,
                child: Container(
                  decoration: BoxDecoration(
                    color: ToolsColors.primary.withOpacity(0.6), // Màu nền
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10), // Bo góc dưới bên trái
                    ),
                  ),
                  child:  Row(
                    children: [
                      SizedBox(width: 10,),

                      Text(
                        '20t',
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),

                      SizedBox(width: 10,),
                      Text(
                        widget.person.address!.city.toString(),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(width: 10,),

                    ],
                  ),
                ))

          ],
        ),
      ),
    );
  }
}
