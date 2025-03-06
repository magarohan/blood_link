import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http;
import 'dart:convert';
import 'update_blood_inventory.dart';

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
      [];
  bool
      isLoading =
      true;

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
              'type': '${item['bloodType']}${item['rhFactor']}',
              'bloodType': item['bloodType'],
              'rhFactor': item['rhFactor'],
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

  // UI for each blood inventory item
  Widget
      _buildInventoryCard(Map<String, dynamic> bloodType) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
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
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          const SizedBox(height: 10),
          Text('Whole blood: ${bloodType['wholeBlood']}'),
          Text('RBC: ${bloodType['rbc']}'),
          Text('WBC: ${bloodType['wbc']}'),
          Text('Platelets: ${bloodType['platelets']}'),
          Text('Plasma: ${bloodType['plasma']}'),
          Text('Cryoprecipitate: ${bloodType['cryo']}'),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateBloodInventory(bloodType: bloodType),
                ),
              ).then((_) {
                fetchBloodInventory(); // Fetch updated data from backend
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Update', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget
      build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blood Inventory'), backgroundColor: Colors.red),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : bloodInventory.isEmpty
              ? const Center(child: Text('No blood inventory available'))
              : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: bloodInventory.length,
                  itemBuilder: (context, index) {
                    return _buildInventoryCard(bloodInventory[index]);
                  },
                ),
    );
  }
}
