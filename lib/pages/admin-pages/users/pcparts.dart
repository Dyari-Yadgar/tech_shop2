import 'dart:convert';  // For handling JSON (if using JSON file)
import 'dart:io';      // For handling file operations
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class PcPart {
  String name;
  String type;
  double price;
  String spec;
  String brand;

  PcPart({
    required this.name,
    required this.type,
    required this.price,
    required this.spec,
    required this.brand,
  });

  // Factory constructor to create PcPart from JSON data
  factory PcPart.fromJson(Map<String, dynamic> json) {
    return PcPart(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      spec: json['spec'] ?? '',
      brand: json['brand'] ?? '',
    );
  }
}

class GuessPcBuild extends StatefulWidget {
  @override
  State<GuessPcBuild> createState() => _GuessPcBuildState();
}

class _GuessPcBuildState extends State<GuessPcBuild> {
  final TextEditingController _budgetController = TextEditingController();
  List<PcPart> _pcParts = [];  // List to store PC parts loaded from the file
  List<PcPart> _selectedComponents = [];
  double _totalCost = 0.0;
  String _message = '';

  // Load the data from a local JSON file
  Future<void> loadPcParts() async {
    final String response = await rootBundle.loadString('assets/pc_parts.json'); // or CSV file
    final data = json.decode(response);
    setState(() {
      _pcParts = List<PcPart>.from(data.map((item) => PcPart.fromJson(item)));
    });
  }

  // This method will generate the best build based on budget
  Future<void> generatePcBuild(double budget) async {
    if (_pcParts.isEmpty) {
      setState(() {
        _message = '⚠️ No parts available. Please load the parts data.';
      });
      return;
    }

    List<String> requiredTypes = [
      'CPU',
      'RAM',
      'HARD',
      'GPU',
      'PSU',
      'MB',
      'CASE',
      'COOLER',
    ];

    Map<String, List<PcPart>> groupedItems = {};

    // Group parts by their type
    for (var part in _pcParts) {
      if (groupedItems[part.type] == null) {
        groupedItems[part.type] = [];
      }
      groupedItems[part.type]?.add(part);
    }

    // Check if we have all the required parts
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

    // Try finding the best build within the budget
    List<PcPart> bestBuild = [];
    double bestTotal = 0.0;

    // Sort and try to find the best options for each part type
    for (var type in requiredTypes) {
      var parts = groupedItems[type]!;
      parts.sort((a, b) => a.price.compareTo(b.price)); // Sort by price
      PcPart selectedPart = parts.firstWhere(
        (part) => bestTotal + part.price <= budget,
        orElse: () => parts.first,
      );
      bestBuild.add(selectedPart);
      bestTotal += selectedPart.price;
    }

    if (bestBuild.isNotEmpty) {
      setState(() {
        _selectedComponents = bestBuild;
        _totalCost = bestTotal;
        _message = '✅ Build found near your budget!\nTotal Cost: \$${_totalCost.toStringAsFixed(2)}';
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
  void initState() {
    super.initState();
    loadPcParts();  // Load data when the page initializes
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
                    double budget = double.tryParse(_budgetController.text) ?? 0;
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
                              title: Text(item.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Type: ${item.type}'),
                                  Text('Price: \$${item.price.toStringAsFixed(2)}'),
                                  Text('Spec: ${item.spec}'),
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
