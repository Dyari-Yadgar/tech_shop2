import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tech_shop/Auth/login.dart';
import 'package:tech_shop/Auth/forgotpassword.dart';
import 'package:tech_shop/widgetstyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tech_shop/main.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  Future signInWithGoogle() async {
    setState(() {
      isSignup = !isSignup;
    });
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);

    //agar user habw sign in akat, agar nabw awa boman drwstakat
    //bo away datay usery drwstkraw nafawte
    User user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) async {
      if (!value.exists) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': user.displayName,
          'email': user.email,
          'history': [],
        }).then((value) => Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (context) => BottomNavigation(),
            )));
      } else {
        Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (context) => BottomNavigation(),
            ));
      }
    });
  }

  bool isSignup = false;

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
              height: size.height * 0.20,
              child: Image.asset('assets/images/logo.jpg'),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: TextFormField(
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
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: TextFormField(
                controller: emailController,
                key: emailValid,
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Email must contain @';
                  }

                  if (!value.endsWith('.com')) {
                    return 'Email must end with .com';
                  }

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
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: TextFormField(
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
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                                  passValid.currentState!.validate() &&
                                  !isSignup) {
                                try {
                                  setState(() {
                                    isSignup = !isSignup;
                                  });
                                  UserCredential userCredential =
                                      await FirebaseAuth.instance
                                          .createUserWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passController.text,
                                  );

                                  User? user = userCredential.user;
                                  if (user == null)
                                    throw FirebaseAuthException(
                                        code: 'user-null');

                                  // Update Display Name
                                  await user.updateDisplayName(
                                      userNameController.text);

                                  // Save User Info in Firestore
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user.uid)
                                      .set({
                                    'name': user.displayName,
                                    'email': user.email,
                                    'history': [],
                                  });

                                  // Send Verification Email
                                  await user.sendEmailVerification();

                                  // Logout User After Registration
                                  await FirebaseAuth.instance.signOut();

                                  if (!mounted) return;

                                  // Show Success Dialog
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("Verify Your Email"),
                                      content: Text(
                                          "A verification email has been sent. Please check your inbox."),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.pushReplacement(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (context) =>
                                                        Login()));
                                          },
                                          child: Text("OK"),
                                        ),
                                      ],
                                    ),
                                  );
                                } on FirebaseAuthException catch (e) {
                                  if (!mounted) return;

                                  String errorMessage = "An error occurred";
                                  if (e.code == 'email-already-in-use') {
                                    errorMessage =
                                        "The email is already in use.";
                                  }

                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("Error"),
                                      content: Text(errorMessage),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.pushReplacement(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      Signup()),
                                            );
                                          },
                                          child: Text("OK"),
                                        ),
                                      ],
                                    ),
                                  );
                                } catch (e) {
                                  print("Error during account creation: $e");
                                }
                              }
                            },
                            child: isSignup
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    'Create a new account',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ))),
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
                        onPressed: () {
                          signInWithGoogle();
                        },
                        icon: Image.asset('assets/images/google.png'))
                  ],
                ),
              ],
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => ForgotPassword(),
                      ));
                },
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