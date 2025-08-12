import 'package:blood_link/app_config.dart';
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
  bool
      isLoading =
      true;
  String
      errorMessage =
      "";
  late AppConfig
      _config;

  @override
  void
      initState() {
    super.initState();
    _loadConfigAndFetchDonors();
  }

  Future<void>
      _loadConfigAndFetchDonors() async {
    try {
      _config = await AppConfig.loadFromAsset();
      await fetchDonors(_config);
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load config or donors";
        isLoading = false;
      });
    }
  }

  Future<void>
      fetchDonors(AppConfig config) async {
    final String
        baseUrl =
        '${config.apiBaseUrl}/api/donors/';
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body);
        setState(() {
          donors = responseData.map((donor) {
            return {
              "id": donor["_id"],
              "name": donor["fullName"] ?? "Unknown",
              "email": donor["email"] ?? "No email",
              "phoneNumber": donor["phoneNumber"] ?? "No phone",
              "bloodType": donor["bloodType"] ?? "Unknown",
              "rhFactor": donor["rhFactor"] ?? "Unknown",
              "location": donor["location"] ?? "No location",
            };
          }).toList();
          isLoading = false;
          errorMessage = "";
        });
      } else {
        setState(() {
          errorMessage = "Failed to load donors: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error fetching donors";
        isLoading = false;
      });
    }
  }

  Future<void>
      deleteDonor(String id) async {
    final String
        baseUrl =
        '${_config.apiBaseUrl}/api/donors/';
    try {
      final response = await http.delete(Uri.parse('$baseUrl$id'));
      if (response.statusCode == 200) {
        setState(() {
          donors.removeWhere((donor) => donor["id"] == id);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete donor: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting donor: $e')),
      );
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
        backgroundColor: MyColors.primaryColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(errorMessage, style: TextStyle(color: MyColors.primaryColor)),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: donors.length,
                  itemBuilder: (context, index) {
                    return _buildDonorCard(donors[index]);
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/Signup').then((value) {
            _loadConfigAndFetchDonors();
          });
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
            Text("Blood Type: ${donor["bloodType"]}"),
            Text("RH Factor: ${donor["rhFactor"]}"),
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
                ).then((value) {
                  _loadConfigAndFetchDonors();
                });
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
