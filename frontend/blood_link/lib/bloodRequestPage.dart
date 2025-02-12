import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http;
import 'dart:convert';

class BloodRequestsPage
    extends StatefulWidget {
  const BloodRequestsPage(
      {super.key});

  @override
  _BloodRequestsPageState createState() =>
      _BloodRequestsPageState();
}

class _BloodRequestsPageState
    extends State<BloodRequestsPage> {
  List<dynamic>
      bloodRequests =
      [];
  bool
      isLoading =
      true;
  String
      errorMessage =
      '';

  @override
  void
      initState() {
    super.initState();
    fetchBloodRequests();
  }

  Future<void>
      fetchBloodRequests() async {
    const String
        url =
        'http://localhost:4000/api/requests';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          bloodRequests = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load blood requests');
      }
    } catch (error) {
      setState(() {
        errorMessage = "Error fetching data";
        isLoading = false;
      });
    }
  }

  Future<void>
      deleteBloodRequest(String id) async {
    final String
        url =
        'http://localhost:4000/api/requests/$id';

    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          bloodRequests.removeWhere((request) => request['_id'] == id);
        });
      } else {
        throw Exception('Failed to delete request');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error deleting request")),
      );
    }
  }

  @override
  Widget
      build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blood Requests"),
        backgroundColor: Colors.red,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: bloodRequests.length,
                  itemBuilder: (context, index) {
                    final request = bloodRequests[index];
                    return _buildRequestCard(
                      request['_id'],
                      request['name'],
                      request['location'],
                      request['bloodType'],
                      request['rhFactor'],
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/AddRequestPage');
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildRequestCard(
      String id,
      String name,
      String location,
      String bloodType,
      String rhFactor) {
    String
        bloodTypeWithRh =
        '$bloodType$rhFactor';
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.red[100],
          child: Text(
            bloodTypeWithRh,
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(name),
        subtitle: Text(location),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => deleteBloodRequest(id),
        ),
      ),
    );
  }
}
