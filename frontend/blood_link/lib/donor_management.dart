import 'package:blood_link/themes/colors.dart';
import 'package:blood_link/update_donor_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http;
import 'dart:convert';

class DonorManagementPage
    extends StatefulWidget {
  const DonorManagementPage(
      {super.key});

  @override
  DonorManagementPageState createState() =>
      DonorManagementPageState();
}

class DonorManagementPageState
    extends State<DonorManagementPage> {
  List<Map<String, dynamic>>
      donors =
      [];
  Map<String, int>
      bloodGroupCounts =
      {}; // Stores count of each blood type
  bool
      isLoading =
      true;
  String
      errorMessage =
      "";
  final String
      baseUrl =
      'http://localhost:4000/api/donors/';

  @override
  void
      initState() {
    super.initState();
    fetchDonors();
  }

  Future<void>
      fetchDonors() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        setState(() {
          List<dynamic> responseData = json.decode(response.body);
          donors = responseData.map((donor) {
            return {
              "id": donor["_id"],
              "name": donor["fullName"] ?? "Unknown",
              "email": donor["email"] ?? "No email",
              "phoneNumber": donor["phoneNumber"] ?? "No phone",
              "bloodGroup": donor["bloodGroup"] ?? "Unknown",
              "location": donor["location"] ?? "No location",
            };
          }).toList();

          // Reset and count blood groups
          bloodGroupCounts.clear();
          for (var donor in donors) {
            String bloodGroup = donor["bloodGroup"] ?? "Unknown";
            bloodGroupCounts[bloodGroup] = (bloodGroupCounts[bloodGroup] ?? 0) + 1;
          }

          isLoading = false;
        });
      } else {
        throw Exception('Failed to load donors');
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error fetching data";
        isLoading = false;
      });
    }
  }

  Future<void>
      deleteDonor(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl$id'));
      if (response.statusCode == 200) {
        setState(() {
          donors.removeWhere((donor) => donor["id"] == id);
          fetchDonors(); // Refresh the blood group counts
        });
      } else {
        throw Exception('Failed to delete donor');
      }
    } catch (e) {
      print('Error deleting donor: $e');
    }
  }

  @override
  Widget
      build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(
          title: const Text(
            "Donor Management",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: MyColors.primaryColor),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage, style: TextStyle(color: MyColors.primaryColor)))
              : Column(
                  children: [
                    // Blood Group Count Summary
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: bloodGroupCounts.entries.map((entry) {
                          return Text(
                            "${entry.key}: ${entry.value} donors",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          );
                        }).toList(),
                      ),
                    ),

                    // Donor List
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: donors.length,
                        itemBuilder: (context, index) {
                          return _buildDonorCard(donors[index]);
                        },
                      ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/Signup');
        },
        backgroundColor: MyColors.primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget
      _buildDonorCard(Map<String, dynamic> donor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        title: Text(donor["name"]),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Email: ${donor["email"]}"),
            Text("Phone: ${donor["phoneNumber"]}"),
            Text("Blood Group: ${donor["bloodGroup"]}"),
            Text("Location: ${donor["location"]}"),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateDonorPage(donor: donor),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: MyColors.primaryColor),
              onPressed: () => deleteDonor(donor["id"]),
            ),
          ],
        ),
      ),
    );
  }
}
