import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http;
import 'dart:convert';

class UpdateBloodInventory
    extends StatefulWidget {
  final Map<
      String,
      dynamic> bloodType;

  const UpdateBloodInventory(
      {Key? key,
      required this.bloodType})
      : super(key: key);

  @override
  State<UpdateBloodInventory> createState() =>
      _UpdateBloodInventoryState();
}

class _UpdateBloodInventoryState
    extends State<UpdateBloodInventory> {
  late Map<
      String,
      dynamic> updatedValues;
  final Map<String, String>
      _units =
      {
    'wholeBlood':
        'Pints',
    'rbc':
        'ml',
    'wbc':
        'ml',
    'platelets':
        'ml',
    'plasma':
        'ml',
    'cryo':
        'ml',
  };

  @override
  void
      initState() {
    super.initState();
    updatedValues =
        Map<String, dynamic>.from(widget.bloodType);
  }

  void incrementValue(
      String key) {
    setState(() {
      final currentValue = _parseValue(updatedValues[key]);
      updatedValues[key] = '${currentValue + 10} ${_units[key]}'; // Preserve unit
    });
  }

  void decrementValue(
      String key) {
    setState(() {
      final currentValue = _parseValue(updatedValues[key]);
      updatedValues[key] = '${currentValue > 0 ? currentValue - 10 : 0} ${_units[key]}'; // Preserve unit
    });
  }

  int _parseValue(
      dynamic value) {
    return int.tryParse(value.toString().replaceAll(RegExp(r'[^\d]'), '')) ??
        0;
  }

  Future<void>
      updateBloodInventory() async {
    const String
        url =
        'http://localhost:4000/api/bloods/updateBlood'; // Change to your backend URL

    try {
      final Map<String, dynamic> data = {
        "bloodType": widget.bloodType['type'].substring(0, widget.bloodType['type'].length - 1), // Extract blood type
        "rhFactor": widget.bloodType['type'].substring(widget.bloodType['type'].length - 1), // Extract rh factor
        "components": {
          "wholeBlood": _parseValue(updatedValues['wholeBlood']),
          "redBloodCells": _parseValue(updatedValues['rbc']),
          "whiteBloodCells": _parseValue(updatedValues['wbc']),
          "platelets": _parseValue(updatedValues['platelets']),
          "plasma": _parseValue(updatedValues['plasma']),
          "cryoprecipitate": _parseValue(updatedValues['cryo']),
        }
      };

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json"
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        print("Blood inventory updated successfully");
        Navigator.pop(context, updatedValues); // Pass updated values back
      } else {
        print("Failed to update blood inventory: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update blood inventory")),
        );
      }
    } catch (error) {
      print("Error updating blood inventory: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating blood inventory")),
      );
    }
  }

  @override
  Widget
      build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Inventory for ${widget.bloodType['type']}'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (String key in [
              'wholeBlood',
              'rbc',
              'wbc',
              'platelets',
              'plasma',
              'cryo'
            ])
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      key.replaceAllMapped(RegExp(r'[A-Z]'), (match) => ' ${match.group(0)}').toUpperCase(),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => decrementValue(key),
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                        ),
                        SizedBox(
                          width: 60,
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: TextEditingController(
                              text: '${_parseValue(updatedValues[key])} ${_units[key]}',
                            ),
                            onChanged: (value) {
                              setState(() {
                                updatedValues[key] = '$value ${_units[key]}'; // Preserve unit
                              });
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => incrementValue(key),
                          icon: const Icon(Icons.add_circle, color: Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: updateBloodInventory, // Call API when saving
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
