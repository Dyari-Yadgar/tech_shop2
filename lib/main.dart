import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:tech_shop/WidgetStyle.dart';
import 'package:tech_shop/pages/admin-pages/adminmenu.dart';
import 'package:tech_shop/pages/user-pages/checkOut.dart';

import 'package:tech_shop/pages/user-pages/menu.dart';

import 'pages//user-pages/homepage2.dart';
import 'pages//user-pages/favorite.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// import 'package:provider_installer/provider_installer.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await ProviderInstaller.installProviders();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tech Shop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BottomNavigation(),
    );
  }
}

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  static int pageindex = 1;
  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  List pages = [favorite(), HomePage2(), checkOut()];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove default back button if any
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
        leading: Builder(
          builder: (context) => IconButton(
            iconSize: 35,
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
          backgroundColor: Colors.white,
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

             
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Menu(); 
              }

              var userRole = snapshot.data!.get('role');

              
              if (userRole == null) {
                return Menu(); 
              }

              if (userRole == 'admin') {
                return AdminMenu(); 
              } else {
                return Menu(); 
              }
            },
          )),
      body: pages.elementAt(BottomNavigation.pageindex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_outlined), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined), label: 'Cards'),
        ],
        selectedItemColor: WidgetStyle.primary,
        unselectedItemColor: WidgetStyle.primary.withOpacity(0.2),
        currentIndex: BottomNavigation.pageindex,
        onTap: (value) {
          setState(() {
            BottomNavigation.pageindex = value;
          });
        },
      ),
    ));
  }
}
