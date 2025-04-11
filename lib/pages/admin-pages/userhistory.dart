import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tech_shop/widgetstyle.dart';

class UserHistory extends StatelessWidget {
  final String userId;
  final String userName;

  const UserHistory({super.key, required this.userId, required this.userName});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'Tech Shop',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: WidgetStyle.primary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('No user data found'));
            }

            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final history = userData['history'] as List<dynamic>?;

            if (history == null || history.isEmpty) {
              return const Center(child: Text('No purchase history found'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final record = history[index];
                final timestamp = record['date'] as Timestamp?;
                final date = timestamp?.toDate();
                final items = record['name'] as List<dynamic>? ?? [];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (date != null)
                          Text(
                            'Date: ${date.day}/${date.month}/${date.year}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        const SizedBox(height: 8),
                        ...items.map((item) {
                          return ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            leading: item['image'] != null
                                ? Image.network(item['image'],
                                    width: 50, height: 50)
                                : const Icon(Icons.shopping_bag),
                            title: Text(item['name'] ?? 'Unnamed Item'),
                            subtitle:
                                Text('Quantity: ${item['quantity'] ?? 1}'),
                            trailing: Text(
                              '\$${item['total'] ?? item['price'] ?? '0'}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
