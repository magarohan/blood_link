import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http;
import 'dart:convert';

const List<String>
    rhFactors =
    [
  '+',
  '-'
];
const List<String>
    bloodTypes =
    [
  'A',
  'B',
  'AB',
  'O'
];

class AddRequestPage
    extends StatefulWidget {
  const AddRequestPage(
      {super.key});

  @override
  AddRequestState createState() =>
      AddRequestState();
}

class AddRequestState
    extends State<AddRequestPage> {
  final TextEditingController
      _nameController =
      TextEditingController();
  final TextEditingController
      _locationController =
      TextEditingController();

  String?
      _selectedBloodType;
  String?
      _selectedRhFactor;

  @override
  void
      dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void>
      _addRequest() async {
    const String
        url =
        'http://localhost:4000/api/requests';

    if (_selectedBloodType == null ||
        _selectedRhFactor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select Blood Type and Rh Factor')),
      );
      return;
    }

    final Map<String, dynamic>
        requestData =
        {
      "name": _nameController.text.trim(),
      "location": _locationController.text.trim(),
      "bloodType": _selectedBloodType,
      "rhFactor": _selectedRhFactor,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json"
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request Added Successfully!')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to Add Request')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error Adding Request')),
      );
    }
  }

  @override
  Widget
      build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Blood Request'), backgroundColor: Colors.red),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Patient Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            const SizedBox(height: 10),

            // Blood Type Dropdown
            DropdownButtonFormField<String>(
              value: _selectedBloodType,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedBloodType = newValue;
                });
              },
              items: bloodTypes.map((String bloodType) {
                return DropdownMenuItem<String>(
                  value: bloodType,
                  child: Text(bloodType),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: 'Blood Type'),
            ),

            const SizedBox(height: 10),

            // Rh Factor Dropdown
            DropdownButtonFormField<String>(
              value: _selectedRhFactor,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRhFactor = newValue;
                });
              },
              items: rhFactors.map((String rhFactor) {
                return DropdownMenuItem<String>(
                  value: rhFactor,
                  child: Text(rhFactor),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: 'Rh Factor'),
            ),

            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _addRequest,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Add Request', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
