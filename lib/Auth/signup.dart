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
  bool isSignup = false;
  bool isPassHide = true;

  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController phoneController =
      TextEditingController(); // New controller
  TextEditingController locationController =
      TextEditingController(); // New controller

  GlobalKey<FormFieldState<String>> emailValid = GlobalKey();
  GlobalKey<FormFieldState<String>> passValid = GlobalKey();
   GlobalKey<FormFieldState<String>> phoneValid = GlobalKey();

  Future<void> signInWithGoogle() async {
    setState(() {
      isSignup = true;
    });

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    if (googleAuth == null) return;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    User user = userCredential.user!;

    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      await userDoc.set({
        'name': user.displayName ?? '',
        'email': user.email,
        'phone': phoneController.text, // Save phone
        'location': locationController.text, // Save location
        'history': [],
        'favorites': [],
        'role': 'user',
      });
    }

    if (!mounted) return;
    Navigator.pushReplacement(
        context, CupertinoPageRoute(builder: (context) => BottomNavigation()));
  }

  Future<void> createAccountWithEmail() async {
    if (emailValid.currentState!.validate() &&
        passValid.currentState!.validate() && 
        !isSignup) {
      try {
        setState(() {
          isSignup = true;
        });

        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passController.text,
        );

        User? user = userCredential.user;
        if (user == null) throw FirebaseAuthException(code: 'user-null');

        await user.updateDisplayName(userNameController.text);

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': userNameController.text ?? '',
          'email': user.email,
          'phone': phoneController.text, // Save phone
          'location': locationController.text, // Save location
          'history': [],
          'favorites': [],
          'role': 'user',
        });

        await user.sendEmailVerification();
        await FirebaseAuth.instance.signOut();

        if (!mounted) return;
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
                  Navigator.pushReplacement(context,
                      CupertinoPageRoute(builder: (context) => Login()));
                },
                child: Text("OK"),
              ),
            ],
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;
        String errorMessage = e.code == 'email-already-in-use'
            ? "The email is already in use."
            : "An error occurred";

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Error"),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(context,
                      CupertinoPageRoute(builder: (context) => Signup()));
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
  }

  OutlineInputBorder Border() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: WidgetStyle.primary, width: 2),
      borderRadius: BorderRadius.circular(20),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Tech Shop', style: TextStyle(color: Colors.white)),
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
                  child: Image.asset('assets/images/logo.jpg')),
              SizedBox(height: 10),
              SizedBox(
                height: 45,
                child: TextFormField(
                  controller: userNameController,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    suffix: Icon(Icons.person, color: WidgetStyle.primary),
                    focusedBorder: Border(),
                    enabledBorder: Border(),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 45,
                child: TextFormField(
                  controller: emailController,
                  key: emailValid,
                  validator: (value) {
                    if (value == null || !value.contains('@'))
                      return 'Email must contain @';
                    if (!value.endsWith('.com'))
                      return 'Email must end with .com';
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Email',
                    suffix: Icon(Icons.email, color: WidgetStyle.primary),
                    focusedBorder: Border(),
                    enabledBorder: Border(),
                    errorBorder: Border(),
                    disabledBorder: Border(),
                    focusedErrorBorder: Border(),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 45,
                child: TextFormField(
                  controller: passController,
                  validator: (value) => value != null && value.length < 6
                      ? 'Must be at least 6 characters'
                      : null,
                  key: passValid,
                  obscureText: isPassHide,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    suffix: IconButton(
                      onPressed: () => setState(() => isPassHide = !isPassHide),
                      icon: Icon(
                          isPassHide ? Icons.visibility : Icons.visibility_off),
                    ),
                    focusedBorder: Border(),
                    enabledBorder: Border(),
                    errorBorder: Border(),
                    disabledBorder: Border(),
                    focusedErrorBorder: Border(),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 45,
                child: TextFormField(
                  controller: phoneController,
                  validator: (value) => value != null && value.length < 10
                      ? 'Must be at least 11 Digits'
                      : null,
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                    suffix: Icon(Icons.phone, color: WidgetStyle.primary),
                    focusedBorder: Border(),
                    enabledBorder: Border(),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 45,
                child: TextFormField(
                  controller: locationController,
                  decoration: InputDecoration(
                    hintText: 'Location',
                    suffix: Icon(Icons.location_on, color: WidgetStyle.primary),
                    focusedBorder: Border(),
                    enabledBorder: Border(),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: WidgetStyle.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: createAccountWithEmail,
                    child: isSignup
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Create a new account',
                            style:
                                TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: signInWithGoogle,
                    icon: Image.asset('assets/images/google.png'),
                  )
                ],
              ),
              TextButton(
                onPressed: () => Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => ForgotPassword())),
                child: Text('Forgot your password?',
                    style: TextStyle(color: WidgetStyle.primary)),
              ),
              Expanded(child: SizedBox()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Do you have an account? '),
                  InkWell(
                    onTap: () => Navigator.pushReplacement(context,
                        CupertinoPageRoute(builder: (context) => Login())),
                    child: Text('Login',
                        style: TextStyle(color: WidgetStyle.primary)),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
