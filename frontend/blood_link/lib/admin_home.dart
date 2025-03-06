import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http;
import 'dart:convert';
import 'update_blood_inventory.dart';

class AdminHome
    extends StatefulWidget {
  const AdminHome(
      {super.key});

  @override
  State<AdminHome> createState() =>
      _AdminHomeState();
}

class _AdminHomeState
    extends State<AdminHome> {
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

  Future<void>
      fetchBloodInventory() async {
    const String
        url =
        'http://localhost:4000/api/hospitalBloods/';

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

  @override
  Widget
      build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFeatureCard(context, Icons.people, "Staffs", '/StaffManagementPage'),
                _buildFeatureCard(context, Icons.person, "Donors", '/DonorManagementPage'),
                _buildFeatureCard(context, Icons.doorbell, "Requests", '/BloodRequestsPage'),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Blood Inventory",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 10),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : bloodInventory.isEmpty
                    ? const Center(child: Text('No blood inventory available'))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: bloodInventory.length,
                        itemBuilder: (context, index) {
                          return _buildInventoryCard(bloodInventory[index]);
                        },
                      ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation logic here if needed
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

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
                MaterialPageRoute(builder: (context) => UpdateBloodInventory(bloodType: bloodType)),
              ).then((_) {
                fetchBloodInventory();
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

  Widget _buildFeatureCard(
      BuildContext context,
      IconData icon,
      String title,
      String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        width: 110,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.red, size: 30),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
