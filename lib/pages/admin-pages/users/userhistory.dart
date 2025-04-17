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
                final total = record['total']?.toString() ?? '0';

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.shopping_basket,
                                color: WidgetStyle.primary,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Order Number ${index + 1}',
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width > 600
                                          ? 20
                                          : 16,
                                  fontWeight: FontWeight.bold,
                                  color: WidgetStyle.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (date != null)
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: WidgetStyle.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Date of Order: ${date.day}/${date.month}/${date.year}',
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width > 600
                                            ? 16
                                            : 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 10),
                          Column(
                            children: items.map((item) {
                              final itemName = item['name'] ?? 'Unnamed Item';
                              final itemPrice =
                                  item['price']?.toString() ?? '0';
                              final quantity = item['quantity'] ?? 1;
                              final imageUrl = item['image'] ?? '';

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  children: [
                                    imageUrl.isNotEmpty
                                        ? Image.network(
                                            imageUrl,
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.cover,
                                          )
                                        : const Icon(Icons.shopping_bag),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '$itemName - \$${itemPrice} x $quantity',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  600
                                              ? 16
                                              : 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                Icons.money,
                                color: WidgetStyle.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Total: \$${total}',
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width > 600
                                          ? 18
                                          : 16,
                                  fontWeight: FontWeight.bold,
                                  color: WidgetStyle.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
