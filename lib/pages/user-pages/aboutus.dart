import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tech_shop/widgetstyle.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Adds spacing from edges
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centers vertically
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Centers horizontally
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: WidgetStyle.white
                  ),
                  child: Text(
                    'Welcome to Tech Shop, your one-stop destination for high-quality computers, laptops, accessories, and custom PC builds. '
                    'We are passionate about technology and committed to providing the best products and services to our customers.',
                    textAlign: TextAlign.center, // Centers text
                    style: TextStyle(
                      color: WidgetStyle.primary, // Applies primary color
                      fontSize: 18, // Adjusts readability
                      fontWeight: FontWeight.w500, // Slightly bold for emphasis
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
