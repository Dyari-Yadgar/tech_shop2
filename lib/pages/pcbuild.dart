import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tech_shop/WidgetStyle.dart'; // Assuming WidgetStyle is defined elsewhere

class PcBuild extends StatefulWidget {
  const PcBuild({super.key});

  @override
  _PcBuildState createState() => _PcBuildState();
}

class _PcBuildState extends State<PcBuild> {
  String? selectedCpu;
  String? selectedRam;
  String? selectedHardDrive;
  String? selectedPowerSupply;
  String? selectedGpu;
  String? selectedMotherboard;
  String? selectedCase;
  String? selectedCooler;

  List<Map<String, dynamic>> cpuItems = [];
  List<Map<String, dynamic>> ramItems = [];
  List<Map<String, dynamic>> hardDriveItems = [];
  List<Map<String, dynamic>> powerSupplyItems = [];
  List<Map<String, dynamic>> gpuItems = [];
  List<Map<String, dynamic>> motherboardItems = [];
  List<Map<String, dynamic>> caseItems = [];
  List<Map<String, dynamic>> coolerItems = [];

  // Function to fetch data from Firestore based on the component type
  Future<void> getItems(String type) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('items') // Assuming your collection name is 'items'
        .where('type', isEqualTo: type) // Filter by type
        .get();

    setState(() {
      if (type == 'CPU') {
        cpuItems = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      } else if (type == 'RAM') {
        ramItems = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      } else if (type == 'HARD') {
        hardDriveItems = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      } else if (type == 'PSU') {
        powerSupplyItems = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      } else if (type == 'GPU') {
        gpuItems = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      } else if (type == 'MB') {
        motherboardItems = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      } else if (type == 'CASE') {
        caseItems = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      } else if (type == 'Cooler') {
        coolerItems = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getItems('CPU');
    getItems('RAM');
    getItems('HARD');
    getItems('PSU');
    getItems('GPU');
    getItems('MB');
    getItems('CASE');
    getItems('Cooler');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          SizedBox(width: 40),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // CPU Dropdown
              buildDropdownRow('CPU', selectedCpu, cpuItems),

              // RAM Dropdown
              buildDropdownRow('RAM', selectedRam, ramItems),

              // Hard Drive Dropdown
              buildDropdownRow('Hard', selectedHardDrive, hardDriveItems),

              // Power Supply Dropdown
              buildDropdownRow(
                  'Power Supply', selectedPowerSupply, powerSupplyItems),

              // GPU Dropdown
              buildDropdownRow('GPU', selectedGpu, gpuItems),

              // Motherboard Dropdown
              buildDropdownRow(
                  'Motherboard', selectedMotherboard, motherboardItems),

              // Case Dropdown
              buildDropdownRow('Case', selectedCase, caseItems),

              // Cooler Dropdown
              buildDropdownRow('Cooler', selectedCooler, coolerItems),

              // Space between components
              SizedBox(height: 20),

              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Text 1"),
                  SizedBox(height: 10),
                  Text("Text 2"),
                  SizedBox(height: 10),
                  Text("Text 3"),
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize
                          .min, // To make the row only take as much space as needed
                      children: [
                        Text(
                          'Build',
                          style: TextStyle(
                              color: Colors.white,
                              backgroundColor: WidgetStyle.primary),
                        ),
                        SizedBox(
                            width:
                                8), // Optional space between the text and the icon
                        Icon(
                          Icons.build,
                          color: WidgetStyle.primary,
                        ), // Add your desired icon here
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to create dropdown widgets in a row for better structuring
  Widget buildDropdownRow(
      String hint, String? selectedValue, List<Map<String, dynamic>> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Dropdown button
          Container(
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              hint: Text(selectedValue ?? hint),
              value: selectedValue,
              onChanged: (newValue) {
                setState(() {
                  selectedValue = newValue;
                });
              },
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item['name'],
                  child: Text(item['name']),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
