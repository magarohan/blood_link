import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http;
import 'dart:convert';
import 'package:blood_link/themes/colors.dart';
import 'package:flutter/foundation.dart';

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

  String?
      _selectedWholeBlood =
      'None';
  String?
      _selectedRedBloodCells =
      'None';
  String?
      _selectedWhiteBloodCells =
      'None';
  String?
      _selectedPlatelets =
      'None';
  String?
      _selectedPlasma =
      'None';
  String?
      _selectedCryoprecipitate =
      'None';

  final List<String>
      componentOptions =
      [
    'None',
    '1 unit',
    '2 units',
    '3 units',
    '4 units',
    '5 units'
  ];

  @override
  void
      dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void>
      _addRequest() async {
    const String url = kIsWeb
        ? 'http://localhost:4000/api/requests'
        : 'http://10.0.2.2:4000/api/requests';

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
      "components": {
        "wholeBlood": _parseComponentSelection(_selectedWholeBlood),
        "redBloodCells": _parseComponentSelection(_selectedRedBloodCells),
        "whiteBloodCells": _parseComponentSelection(_selectedWhiteBloodCells),
        "platelets": _parseComponentSelection(_selectedPlatelets),
        "plasma": _parseComponentSelection(_selectedPlasma),
        "cryoprecipitate": _parseComponentSelection(_selectedCryoprecipitate),
      }
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

  int _parseComponentSelection(
      String? selection) {
    switch (selection) {
      case '1 unit':
        return 1;
      case '2 units':
        return 2;
      case '3 units':
        return 3;
      case '4 units':
        return 4;
      case '5 units':
        return 5;
      default:
        return 0;
    }
  }

  @override
  Widget
      build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Add Blood Request',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: MyColors.primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedWholeBlood,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedWholeBlood = newValue;
                  });
                },
                items: componentOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Whole Blood'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedRedBloodCells,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRedBloodCells = newValue;
                  });
                },
                items: componentOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Red Blood Cells'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedWhiteBloodCells,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedWhiteBloodCells = newValue;
                  });
                },
                items: componentOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'White Blood Cells'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedPlatelets,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPlatelets = newValue;
                  });
                },
                items: componentOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Platelets'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedPlasma,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPlasma = newValue;
                  });
                },
                items: componentOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Plasma'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedCryoprecipitate,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCryoprecipitate = newValue;
                  });
                },
                items: componentOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Cryoprecipitate'),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _addRequest,
                  style: ElevatedButton.styleFrom(backgroundColor: MyColors.primaryColor),
                  child: const Text('Add Request', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
