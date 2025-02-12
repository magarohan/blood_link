import 'package:blood_link/updateDonorPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http;
import 'dart:convert';

class DonorManagementPage
    extends StatefulWidget {
  const DonorManagementPage(
      {super.key});

  @override
  _DonorManagementPageState createState() =>
      _DonorManagementPageState();
}

class _DonorManagementPageState
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
          donors = responseData
              .map((donor) => {
                    "id": donor["_id"],
                    "name": donor["fullName"] ?? "Unknown",
                    "email": donor["email"] ?? "No email",
                    "phoneNumber": donor["phoneNumber"] ?? "No phone",
                    "bloodGroup": donor["bloodGroup"] ?? "Unknown",
                    "location": donor["location"] ?? "No location",
                  })
              .toList();
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
      appBar: AppBar(title: const Text("Donor Management"), backgroundColor: Colors.red),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: donors.length,
                  itemBuilder: (context, index) {
                    return _buildDonorCard(donors[index]);
                  },
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
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => deleteDonor(donor["id"]),
            ),
          ],
        ),
      ),
    );
  }
}
