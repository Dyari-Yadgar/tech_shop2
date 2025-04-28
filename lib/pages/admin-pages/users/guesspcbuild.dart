import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GuessPcBuild extends StatefulWidget {
  @override
  State<GuessPcBuild> createState() => _GuessPcBuildState();
}

class _GuessPcBuildState extends State<GuessPcBuild> {
  final TextEditingController _budgetController = TextEditingController();
  List<Map<String, dynamic>> _selectedComponents = [];
  double _totalCost = 0.0;
  String _message = '';

  // Fetch items from Firestore
  Future<List<Map<String, dynamic>>> fetchItems() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('items').get();

    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .where((item) =>
            item['type'] != null &&
            item['price'] != null &&
            item['name'] != null &&
            item['spec'] != null)
        .toList();
  }

  // Generate the PC build based on the budget
  Future<void> generatePcBuild(double budget) async {
    var items = await fetchItems();

    // Group items by type
    Map<String, List<Map<String, dynamic>>> groupedItems = {};
    for (var item in items) {
      groupedItems.putIfAbsent(item['type'], () => []).add(item);
    }

    List<String> requiredTypes = [
      'CPU',
      'RAM',
      'HARD',
      'GPU',
      'PSU',
      'MB',
      'CASE',
      'COOLER'
    ];

    // Check if all types have at least one item
    for (var type in requiredTypes) {
      if (groupedItems[type] == null || groupedItems[type]!.isEmpty) {
        setState(() {
          _selectedComponents = [];
          _totalCost = 0.0;
          _message = '❌ Missing components for a full build.';
        });
        return;
      }
    }

    // Select the top 3 cheapest components from each category
    List<List<Map<String, dynamic>>> options = [];
    for (var type in requiredTypes) {
      var parts = groupedItems[type]!;
      parts.sort((a, b) => (a['price'] as num).compareTo(b['price'] as num));
      options.add(parts.take(3).toList());
    }

    // Try to find the best combination within the budget
    double closestDifference = double.infinity;
    List<Map<String, dynamic>> bestBuild = [];

    // Try combinations of the cheapest components (3 for each type)
    for (var cpu in options[0]) {
      for (var ram in options[1]) {
        for (var hard in options[2]) {
          for (var gpu in options[3]) {
            for (var psu in options[4]) {
              for (var mb in options[5]) {
                for (var caseItem in options[6]) {
                  for (var cooler in options[7]) {
                    double total = (cpu['price'] ?? 0) +
                        (ram['price'] ?? 0) +
                        (hard['price'] ?? 0) +
                        (gpu['price'] ?? 0) +
                        (psu['price'] ?? 0) +
                        (mb['price'] ?? 0) +
                        (caseItem['price'] ?? 0) +
                        (cooler['price'] ?? 0);

                    double diff = (budget - total).abs();

                    if (total <= budget && diff < closestDifference) {
                      closestDifference = diff;
                      bestBuild = [
                        cpu,
                        ram,
                        hard,
                        gpu,
                        psu,
                        mb,
                        caseItem,
                        cooler
                      ];
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    if (bestBuild.isNotEmpty) {
      setState(() {
        _selectedComponents = bestBuild;
        _totalCost = closestDifference;
        _message =
            '✅ Build found near your budget!\nTotal Cost: \$${_totalCost.toStringAsFixed(2)}';
      });
    } else {
      setState(() {
        _selectedComponents = [];
        _totalCost = 0.0;
        _message = '❌ Could not find build within your budget.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Guess Your PC Build'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _budgetController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter your budget',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    double budget =
                        double.tryParse(_budgetController.text) ?? 0;
                    if (budget > 0) {
                      generatePcBuild(budget);
                    } else {
                      setState(() {
                        _message = '⚠️ Please enter a valid budget.';
                      });
                    }
                  },
                  child: Text('Generate PC Build'),
                ),
                SizedBox(height: 20),
                Text(
                  _message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                _selectedComponents.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _selectedComponents.map((item) {
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(item['name'] ?? 'Unknown'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Type: ${item['type'] ?? ''}'),
                                  Text('Price: \$${item['price'] ?? 0}'),
                                  Text(
                                      'Spec: ${item['spec'] ?? 'No specification'}'),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
