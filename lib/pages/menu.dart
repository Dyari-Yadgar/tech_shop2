import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tech_shop/pages/aboutapp.dart';
import 'package:tech_shop/pages/aboutus.dart';
import 'package:tech_shop/pages/pcbuild.dart';
import 'package:tech_shop/pages/profile.dart';
import 'package:tech_shop/widgetstyle.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
          ),
          centerTitle: true,
          title: Text(
            'Tech Shop',
            style: TextStyle(
              color: WidgetStyle.white,
            ),
          ),
          backgroundColor: WidgetStyle.primary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          actions: [
            SizedBox(
              width: 40,
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: size.height * 0.20,
              child: Image.asset('assets/images/logo.jpg'),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => Profile(),
                          ));
                    },
                    icon: Icon(
                      Icons.settings,
                      color: WidgetStyle.primary,
                      size: 20,
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => Profile(),
                          ));
                    },
                    child: Text(
                      'Profile Settings',
                      style:
                          TextStyle(color: WidgetStyle.primary, fontSize: 18),
                    )),
              ],
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => PcBuild(),
                          ));},
                    icon: FaIcon(
                      FontAwesomeIcons.computer,
                      color: WidgetStyle.primary,
                      size: 20,
                    )),
                TextButton(
                    onPressed: () {Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => PcBuild(),
                          ));},
                    child: Text(
                      'Custom Pc Build',
                      style:
                          TextStyle(color: WidgetStyle.primary, fontSize: 18),
                    )),
              ],
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => AboutUs(),
                          ));
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.circleInfo,
                      color: WidgetStyle.primary,
                      size: 20,
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => AboutUs(),
                          ));
                    },
                    child: Text(
                      'About Us',
                      style:
                          TextStyle(color: WidgetStyle.primary, fontSize: 18),
                    )),
              ],
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => AboutApp(),
                          ));},
                    icon: FaIcon(
                      FontAwesomeIcons.info,
                      color: WidgetStyle.primary,
                      size: 20,
                    )),
                TextButton(
                    onPressed: () {Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => AboutApp(),
                          ));},
                    child: Text(
                      'About Application',
                      style:
                          TextStyle(color: WidgetStyle.primary, fontSize: 18),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
