import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tech_shop/model/itemmodel.dart';
import 'package:tech_shop/pages/user-pages/itemview.dart';
import 'package:tech_shop/WidgetStyle.dart';

class favorite extends StatefulWidget {
  const favorite({super.key});

  @override
  State<favorite> createState() => _favoriteState();
}

class _favoriteState extends State<favorite> {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  List<String> favoriteIds = []; // To store the list of favorite item IDs
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  // Load the favorite items of the currently logged-in user
  Future<void> _loadFavorites() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc =
            await instance.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          // Get the list of favorite item IDs from Firestore
          List<dynamic> favorites = userDoc['favorites'] ?? [];
          setState(() {
            favoriteIds = List<String>.from(favorites);
            isLoading = false; // Once data is fetched, stop loading
          });
        }
      } catch (e) {
        // Handle error if any
        print('Error fetching favorites: $e');
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false; // Stop loading if no user is logged in
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding:
              const EdgeInsets.only(bottom: 5, left: 10, right: 10, top: 20),
          child: isLoading
              ? const Center(
                  child:
                      CircularProgressIndicator()) // Show loading spinner while fetching data
              : favoriteIds.isNotEmpty
                  ? FutureBuilder(
                      future: getData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text("Error: ${snapshot.error}"));
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                              child: Text("No favorite items found."));
                        }
                        List<itemModel> data = snapshot.data!.docs
                            .map((e) => itemModel.fromJson(e.data()))
                            .toList();
                        return ListView(
                          scrollDirection: Axis.vertical,
                          children: List.generate(data.length,
                              (index) => favoriteItem(size, data[index])),
                        );
                      },
                    )
                  : const Center(child: Text('No favorite items available')),
        ),
      ),
    );
  }

  // Fetch the favorite items based on the favoriteIds from the Firestore items collection
  Future<QuerySnapshot<Map<String, dynamic>>> getData() {
    return instance.collection('items').where('id', whereIn: favoriteIds).get();
  }

  Widget favoriteItem(Size size, itemModel item) {
    String storage = item.storage.toString();
    if (item.storage == 1024) {
      storage = '1TB';
    } else if (item.storage == 2048) {
      storage = '2TB';
    } else {
      storage = item.storage.toString() + 'GB';
    }

    return InkWell(
      onTap: () => Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => ItemView(item: item),
          )),
      child: SizedBox(
        height: 130,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
          color: WidgetStyle.white,
          child: Row(
            children: [
              SizedBox(
                width: size.width * 0.4,
                height: 130,
                child: ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(35), right: Radius.circular(20)),
                  child: Image.network(
                    item.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () async {
                                // Remove the item from the local favorites list
                                setState(() {
                                  favoriteIds.remove(
                                      item.id); // Remove from local list
                                });

                                // Also update Firestore to reflect the change
                                User? user = FirebaseAuth.instance.currentUser;
                                if (user != null) {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user.uid)
                                      .update({
                                    'favorites':
                                        FieldValue.arrayRemove([item.id]),
                                  });
                                }
                              },
                              icon: const Icon(Icons.close))
                        ],
                      ),
                    ),
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text('${item.price}\$'),
                    Text(storage),
                  ],
                ),
              ),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
