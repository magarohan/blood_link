import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http;
import 'dart:convert';
import 'updateBloodInventory.dart'; // Ensure this import is correct

class BloodBank
    extends StatefulWidget {
  const BloodBank(
      {super.key});

  @override
  State<BloodBank> createState() =>
      _BloodBankState();
}

class _BloodBankState
    extends State<BloodBank> {
  List<Map<String, dynamic>>
      bloodInventory =
      []; // Initialize as empty list
  bool
      isLoading =
      true; // For loading indicator

  @override
  void
      initState() {
    super.initState();
    fetchBloodInventory();
  }

  // Fetch blood inventory from the backend
  Future<void>
      fetchBloodInventory() async {
    const String
        url =
        'http://localhost:4000/api/bloods/'; // Change to your backend URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          bloodInventory = data.map((item) {
            return {
              'type': '${item['bloodType']}${item['rhFactor']}', // Concatenate bloodType and rhFactor
              'wholeBlood': '${item['components']['wholeBlood']} Pints',
              'rbc': '${item['components']['redBloodCells']} ml',
              'wbc': '${item['components']['whiteBloodCells']} ml',
              'platelets': '${item['components']['platelets']} ml',
              'plasma': '${item['components']['plasma']} ml',
              'cryo': '${item['components']['cryoprecipitate']} ml',
            };
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load blood inventory');
      }
    } catch (error) {
      print('Error fetching blood inventory: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget
      build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const Icon(Icons.grid_view, color: Colors.red),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.red),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          AppBar(
            backgroundColor: Colors.red,
            title: const Text('Inventory'),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {},
              ),
            ],
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator()) // Show loading indicator
                : bloodInventory.isEmpty
                    ? const Center(child: Text('No blood inventory available'))
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 16.0,
                            mainAxisSpacing: 16.0,
                          ),
                          itemCount: bloodInventory.length,
                          itemBuilder: (context, index) {
                            return _buildInventoryCard(bloodInventory[index], index);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryCard(
      Map<String, dynamic> bloodType,
      int index) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bloodType['type'] ?? 'N/A',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 10),
          Text('Whole blood: ${bloodType['wholeBlood'] ?? 'N/A'}'),
          Text('RBC: ${bloodType['rbc'] ?? 'N/A'}'),
          Text('WBC: ${bloodType['wbc'] ?? 'N/A'}'),
          Text('Platelets: ${bloodType['platelets'] ?? 'N/A'}'),
          Text('Plasma: ${bloodType['plasma'] ?? 'N/A'}'),
          Text('Cryoprecipitate: ${bloodType['cryo'] ?? 'N/A'}'),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateBloodInventory(
                    bloodType: bloodInventory[index],
                  ),
                ),
              ).then((updatedValues) {
                if (updatedValues != null) {
                  setState(() {
                    bloodInventory[index] = updatedValues;
                  });
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Update',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
