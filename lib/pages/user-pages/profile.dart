import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tech_shop/pages/user-pages/profileedit.dart';
import 'package:tech_shop/widgetstyle.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore instance = FirebaseFirestore.instance;
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
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20)),
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
            body: FutureBuilder(
              future: instance.collection('users').doc(user!.uid).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.data == null) {
                  return Center(
                      child: Text('User not found',
                          style: TextStyle(fontSize: 18, color: Colors.red)));
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      // Profile Icon with styling
                      Center(
                        child: FaIcon(
                          Icons.person,
                          color: WidgetStyle.primary, // Custom primary color
                          size: 100, // Bigger icon for better visibility
                        ),
                      ),
                      SizedBox(height: 20),

                      // User Name
                      Column(
                        children: [
                          Center(
                            child: Text(
                              snapshot.data!['name'] as String,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 10), 
                          Container(
                            width: MediaQuery.of(context).size.width *
                                0.6, 
                            height: 2, 
                            color: WidgetStyle.primary, 
                          ),
                          SizedBox(height: 20),
                        ],
                      )

                      ,
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height *
                                0.02, 
                            horizontal: MediaQuery.of(context).size.width *
                                0.05, 
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white, 
                            borderRadius:
                                BorderRadius.circular(10), 
                            border: Border.all(
                              color: WidgetStyle.primary, 
                              width: 2, 
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.email,
                                color: WidgetStyle
                                    .primary,
                                size: MediaQuery.of(context).size.width *
                                    0.06, 
                              ),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.04), 
                              Text(
                                '${snapshot.data!['email']}',
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.05,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      // User Location
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height *
                                0.02, 
                            horizontal: MediaQuery.of(context).size.width *
                                0.05, 
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white, 
                            borderRadius:
                                BorderRadius.circular(10), 
                            border: Border.all(
                              color: WidgetStyle.primary, 
                              width: 2, 
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: WidgetStyle
                                    .primary, 
                                size: MediaQuery.of(context).size.width *
                                    0.06, 
                              ),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.04), 
                              Text(
                                '${snapshot.data!['location']}',
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.05, 
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                    
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height *
                                0.02,
                            horizontal: MediaQuery.of(context).size.width *
                                0.05,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white, 
                            borderRadius:
                                BorderRadius.circular(10), 
                            border: Border.all(
                              color: WidgetStyle.primary, 
                              width: 2, 
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.phone,
                                color: WidgetStyle
                                    .primary, 
                                size: MediaQuery.of(context).size.width *
                                    0.06, 
                              ),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.04),
                              Text(
                                '${snapshot.data!['phone']}',
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.05, 
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

          
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            iconColor: WidgetStyle.primary,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                           Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => ProfEdit(),
                          ));
                          },
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: WidgetStyle.primary,
                                backgroundColor: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                );
              },
            )));
  }
}
