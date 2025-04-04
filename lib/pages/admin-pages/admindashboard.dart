import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tech_shop/main.dart';
import 'package:tech_shop/pages/user-pages/aboutapp.dart';
import 'package:tech_shop/pages/user-pages/aboutus.dart';
import 'package:tech_shop/pages/user-pages/pcbuild.dart';
import 'package:tech_shop/pages/user-pages/profile.dart';
import 'package:tech_shop/widgetstyle.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(),
    );
  }
}
