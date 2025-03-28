import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tech_shop/Auth/login.dart';
import 'package:tech_shop/widgetstyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  GlobalKey<FormFieldState<String>> emailValid = GlobalKey();
  GlobalKey<FormFieldState<String>> passValid = GlobalKey();

  bool isPassHide = true;
  @override
  Widget build(BuildContext context) {
    @override
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Tech Shop',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: WidgetStyle.primary,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: size.height * 0.3,
              child: Image.asset('assets/images/logo.jpg'),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: userNameController,
              decoration: InputDecoration(
                hintText: 'Username',
                suffix: Icon(
                  Icons.person,
                  color: WidgetStyle.primary,
                ),
                focusedBorder: Border(),
                enabledBorder: Border(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: emailController,
              key: emailValid,
              validator: (value) {
                // Check if value is null or doesn't contain '@'
                if (value == null || !value.contains('@')) {
                  return 'Email must contain @';
                }

                // Check if value ends with '.com'
                if (!value.endsWith('.com')) {
                  return 'Email must end with .com';
                }

                // If both checks pass, return null (valid email)
                return null;
              },
              decoration: InputDecoration(
                hintText: 'Email',
                suffix: Icon(
                  Icons.email,
                  color: WidgetStyle.primary,
                ),
                focusedBorder: Border(),
                enabledBorder: Border(),
                errorBorder: Border(),
                disabledBorder: Border(),
                focusedErrorBorder: Border(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: passController,
              validator: (value) => value != null && value.length < 6
                  ? 'it must be at least 6 characters long'
                  : null,
              key: passValid,
              obscureText: isPassHide,
              decoration: InputDecoration(
                hintText: 'Password',
                suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        isPassHide = !isPassHide;
                      });
                    },
                    icon: Icon(
                      isPassHide ? Icons.visibility : Icons.visibility_off,
                    )),
                focusedBorder: Border(),
                enabledBorder: Border(),
                errorBorder: Border(),
                disabledBorder: Border(),
                focusedErrorBorder: Border(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: WidgetStyle.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            )),
                        onPressed: () async {
                          if (emailValid.currentState!.validate() &&
                              passValid.currentState!.validate()) {
                            try {
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: emailController.text,
                                      password: passController.text)
                                  .then((value) async {
                                await FirebaseAuth.instance.currentUser!
                                    .updateDisplayName(userNameController.text)
                                    .then((value) async {
                                  User user =
                                      FirebaseAuth.instance.currentUser!;
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user.uid)
                                      .set({
                                    'name': user.displayName,
                                    'email': user.email,
                                    'history': [],
                                  });
                                }).then((value) async {
                                  await FirebaseAuth.instance.currentUser!
                                      .sendEmailVerification()
                                      .then((value) async {
                                    await FirebaseAuth.instance.signOut();
                                  });
                                });
                              });
                            } catch (e) {
                              // ignore: avoid_print
                              print("Error during account creation: $e");
                            }

                            Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => Login(),
                                ));
                          }
                        },
                        child: Text(
                          'Create a new account',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ))),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            TextButton(
                onPressed: () {},
                child: Text(
                  'Forgot your password?',
                  style: TextStyle(color: WidgetStyle.primary),
                )),
            Expanded(child: SizedBox()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Do you have account? '),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => Login(),
                        ));
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: WidgetStyle.primary),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }

  OutlineInputBorder Border() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: WidgetStyle.primary, width: 2),
      borderRadius: BorderRadius.circular(20),
    );
  }
}
