import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http;
import 'dart:convert';
import 'package:blood_link/themes/colors.dart';
import 'package:blood_link/blood_bank_inventory.dart'; // Ensure this is the correct import

class BloodBankList
    extends StatefulWidget {
  const BloodBankList(
      {super.key});

  @override
  State<BloodBankList> createState() =>
      _BloodBankListState();
}

class _BloodBankListState
    extends State<BloodBankList> {
  List<Map<String, dynamic>>
      bloodBankList =
      [];
  bool
      isLoading =
      true;

  @override
  void
      initState() {
    super.initState();
    fetchBloodBanks();
  }

  Future<void>
      fetchBloodBanks() async {
    const String
        url =
        'http://localhost:4000/api/bloodBanks';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          bloodBankList = data.map((item) {
            return {
              'id': item['_id'],
              'name': item['name'],
              'location': item['location'],
              'contact': item['contact'],
            };
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load blood banks');
      }
    } catch (error) {
      print('Error fetching blood banks: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget
      build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        elevation: 2,
        title: const Text("Blood Banks", style: TextStyle(color: Colors.white, fontSize: 18)),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : bloodBankList.isEmpty
              ? const Center(child: Text('No blood banks available'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: bloodBankList.length,
                  itemBuilder: (context, index) {
                    return _buildBloodBankCard(bloodBankList[index]);
                  },
                ),
    );
  }

  Widget
      _buildBloodBankCard(Map<String, dynamic> bloodBank) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: MyColors.primaryColor),
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
            bloodBank['name'] ?? 'N/A',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MyColors.primaryColor),
          ),
          const SizedBox(height: 5),
          Text('Location: ${bloodBank['location']}'),
          Text('Contact: ${bloodBank['contact']}'),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Navigate to Blood Inventory Page for the selected blood bank
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BloodBank(bloodBankId: bloodBank['id']), // Pass bloodBankId
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('View Inventory', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
