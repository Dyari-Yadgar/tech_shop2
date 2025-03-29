import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tech_shop/Data/ItemData.dart';
import 'package:tech_shop/model/itemmodel.dart';
import 'package:tech_shop/pages/itemview.dart';
import 'package:tech_shop/WidgetStyle.dart';

class favorite extends StatefulWidget {
  const favorite({super.key});

  @override
  State<favorite> createState() => _favoriteState();
}

class _favoriteState extends State<favorite> {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 5, left: 10, right: 10, top: 20),
        child: ItemData.favorites.length != 0
            ? FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  List<itemModel> data = snapshot.data!.docs
                      .map((e) => itemModel.fromJson(e.data()))
                      .toList();
                  return ListView(
                    scrollDirection: Axis.vertical,
                    children: List.generate(data.length,
                        (index) => favoriteItem(size, data[index])),
                  );
                })
            : const Center(
                child: Text('No Data Available'),
              ),
      ),
    ));
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getData() {
    return instance
        .collection('items')
        .orderBy('id')
        .where('id', whereIn: ItemData.favorites.toList())
        .get();
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
                              onPressed: () {
                                setState(() {
                                  ItemData.favorites.remove(item);
                                });
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
