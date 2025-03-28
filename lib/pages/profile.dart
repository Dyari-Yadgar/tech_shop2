import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech_shop/Auth/login.dart';
import 'package:tech_shop/main.dart';
import 'package:tech_shop/widgetstyle.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String username = '';
  String email = '';
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  bool isEdite = false;
  bool isLogin = false;

  getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String storedUsername = pref.getString('username') ?? '';
    email = pref.getString('email') ?? '';
    username = pref.getString('username') ?? '';
    isLogin = pref.getBool('isLogin') ?? false;
    emailController.text = email;
    usernameController.text = username;

    setState(() {
      username = storedUsername;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.data == null) {
              return Center(
                child: TextButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: WidgetStyle.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => Login(),
                          ));
                    },
                    child: Text('Login')),
              );
            } else {
              User? user = FirebaseAuth.instance.currentUser;
              emailController.text = user!.email ?? '';
              usernameController.text = user!.displayName ?? '';
              return Column(
                children: [
                  Container(
                    height: size.height / 2 - 40,
                    decoration: BoxDecoration(color: WidgetStyle.primary),
                    child: Stack(
                      children: [
                        Container(
                          height: size.height / 2 - 50,
                        ),
                        Positioned.fill(
                            top: 10,
                            child: Container(
                              width: size.width,
                              height: size.height / 2 - 7,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          decoration: BoxDecoration(
                                            color: WidgetStyle.primary,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Icon(
                                            Icons.arrow_back,
                                            color: Colors.white,
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                      Expanded(child: SizedBox()),
                                      Text(
                                        'Profile',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 40),
                                      ),
                                      Expanded(child: SizedBox()),
                                      SizedBox(
                                        width: 35,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          SharedPreferences pref =
                                              await SharedPreferences
                                                  .getInstance();
                                          pref.setBool('isLogin', false);
                                          isLogin = false;
                                          setState(() {});
                                        },
                                        child: Container(
                                            height: 52,
                                            width: 35,
                                            decoration: BoxDecoration(
                                              color: WidgetStyle.primary,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: IconButton(
                                              onPressed: () async {
                                                await FirebaseAuth.instance
                                                    .signOut();
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  CupertinoPageRoute(
                                                      builder: (context) =>
                                                          BottomNavigation()),
                                                );
                                              },
                                              icon: Icon(
                                                Icons.logout,
                                                color: Colors.white,
                                                size: 40,
                                              ),
                                            )),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Icon(
                                      Icons.person,
                                      size: 80,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Text(
                                    user.displayName.toString(),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 40),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  Container(
                    width: size.width,
                    height: size.height * 0.4,
                    decoration: BoxDecoration(
                        color: WidgetStyle.primary,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(50))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 25),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(child: SizedBox()),
                              SizedBox(
                                height: 30,
                                width: 30,
                              ),
                              Text(
                                'Information',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 35),
                              ),
                              Expanded(child: SizedBox()),
                              SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isEdite = !isEdite;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Username : ',
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30),
                              ),
                              Flexible(
                                child: TextFormField(
                                  enabled: isEdite,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                  controller: usernameController,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Email : ',
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30),
                              ),
                              Flexible(
                                child: TextFormField(
                                  enabled: isEdite,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                  controller: emailController,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Visibility(
                              child: SizedBox(
                            width: 130,
                            height: 40,
                            child: TextButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                onPressed: () async {
                                  if (emailController.text == email &&
                                      usernameController.text == username) {
                                    setState(() {
                                      isEdite = !isEdite;
                                    });
                                  } else {
                                    SharedPreferences pref =
                                        await SharedPreferences.getInstance();
                                    pref.setString(
                                        'email', emailController.text);
                                    pref.setString(
                                        'username', usernameController.text);
                                    email = emailController.text;
                                    username = usernameController.text;
                                    setState(() {
                                      isEdite = !isEdite;
                                    });
                                  }
                                },
                                child: Text('Edit')),
                          )),
                          Expanded(child: SizedBox())
                        ],
                      ),
                    ),
                  )
                ],
              );
            }
          }),
    ));
  }
}
