import 'package:flutter/material.dart';

class Bottombar extends StatefulWidget {
  @override
  _BottombarState createState() => _BottombarState();
}

class _BottombarState extends State<Bottombar> {
  Size get s => MediaQuery.of(context).size;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            width: (1002 * s.width) / 1080,
            height: (180 * s.height) / 2340,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Color(0xff84B799).withOpacity(0.15),
                width: 6,
              ),
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: Color(0xff84B799).withOpacity(0.5),
                  offset: Offset(0, -30),
                  blurRadius: 60,
                ),
              ],
            ),
            child: Stack(
              overflow: Overflow.visible,
              children: [
                Container(
                  width: (1002 * s.width) / 1080,
                  height: (180 * s.height) / 2340,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(items.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          items.forEach((e) {
                            e.isSelected = false;
                          });
                          setState(() {
                            items[index].isSelected = true;
                          });
                        },
                        child: BottomBarItem(
                          item: items[index],
                        ),
                      );
                    }),
                  ),
                ),
                plusIcon(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget plusIcon() {
    return Positioned(
      top: -40,
      left: (((1002 * s.width) / 1080) - 64) / 2,
      child: Container(
        width: 64,
        height: 64,
        child: Center(
          child: Image.asset(
            "assets/images/profil.png",
            width: 24,
            height: 24,
          ),
        ),
        decoration: BoxDecoration(
          color: Color(0xff84B799),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black.withOpacity(0.1),
            width: 5,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xff84B799),
              offset: Offset(0, 16),
              blurRadius: 28,
            ),
          ],
        ),
      ),
    );
  }
}

class BottomBarItemModel {
  String img;
  bool isSelected;

  BottomBarItemModel(this.img, this.isSelected);
}

class BottomBarItem extends StatelessWidget {
  final BottomBarItemModel item;

  const BottomBarItem({Key key, this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    return Container(
      width: (78 * s.width) / 1080,
      height: (78 * s.width) / 1080,
      child: Image.asset(
        item.img,
        color: item.isSelected ? Color(0xff84B799) : Colors.grey[300],
        fit: BoxFit.cover,
      ),
    );
  }
}

List<BottomBarItemModel> items = [
  BottomBarItemModel("assets/images/home.png", true),
  BottomBarItemModel("assets/images/plant.png", false),
  BottomBarItemModel("assets/images/notification.png", false),
  BottomBarItemModel("assets/images/person.png", false),
];
