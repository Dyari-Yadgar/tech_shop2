import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tech_shop/widgetstyle.dart';

class ProfEdit extends StatefulWidget {
  const ProfEdit({super.key});

  @override
  State<ProfEdit> createState() => _ProfEditState();
}

class _ProfEditState extends State<ProfEdit> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  GlobalKey<FormFieldState<String>> emailValid = GlobalKey();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Enter a new name',
                suffix: Icon(
                  Icons.person,
                  color: WidgetStyle.primary,
                ),
                border: OutlineInputBorder(),
                focusedBorder: Border(),
                enabledBorder: Border(),
                errorBorder: Border(),
                disabledBorder: Border(),
                focusedErrorBorder: Border(),
              ),
            ),
            SizedBox(height: 30), // Space before the button

            // Email TextField
            TextFormField(
              controller: emailController,
              validator: (value) {
                return value != null &&
                        (!value.contains('@') ||
                            value[0] == '@' ||
                            value[value.length - 1] == '@')
                    ? 'Wrong email address'
                    : null;
              },
              key: emailValid,
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
            SizedBox(height: 20),

            // Name TextField
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: 'Enter a new location',
                suffix: FaIcon(
                  Icons.location_on,
                  color: WidgetStyle.primary,
                ),
                border: OutlineInputBorder(),
                focusedBorder: Border(),
                enabledBorder: Border(),
                errorBorder: Border(),
                disabledBorder: Border(),
                focusedErrorBorder: Border(),
              ),
            ),
            SizedBox(height: 20),

            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Enter a new phone number',
                suffix: Icon(
                  Icons.phone,
                  color: WidgetStyle.primary,
                ),
                border: OutlineInputBorder(),
                focusedBorder: Border(),
                enabledBorder: Border(),
                errorBorder: Border(),
                disabledBorder: Border(),
                focusedErrorBorder: Border(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final String newName = nameController.text.trim();
                  final String uid = auth.currentUser!.uid;

                  if (newName.isNotEmpty) {
                    try {
                      await firestore.collection('users').doc(uid).update({
                        'name': newName,
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Name updated successfully!')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to update name: $e')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter a valid name.')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: WidgetStyle.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'Edit',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
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
