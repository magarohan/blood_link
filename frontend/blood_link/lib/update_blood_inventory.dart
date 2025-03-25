import 'package:blood_link/themes/colors.dart';
import 'package:flutter/foundation.dart';
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
      {super.key,
      required this.bloodType});

  @override
  State<UpdateBloodInventory> createState() =>
      _UpdateBloodInventoryState();
}

class _UpdateBloodInventoryState
    extends State<UpdateBloodInventory> {
  late Map<
      String,
      dynamic> updatedValues;

  @override
  void
      initState() {
    super.initState();
    updatedValues =
        Map<String, dynamic>.from(widget.bloodType);
  }

  int _parseValue(
      dynamic value) {
    return int.tryParse(value.toString().replaceAll(RegExp(r'[^\d]'), '')) ??
        0;
  }

  Future<void>
      updateBloodInventory() async {
    String
        id =
        widget.bloodType['id'];
    String url = kIsWeb
        ? 'http://localhost:4000/api/bloods/$id'
        : 'http://10.0.2.2:4000/api/bloods/$id';

    final Map<String, dynamic>
        data =
        {
      "components": {
        "wholeBlood": _parseValue(updatedValues['wholeBlood']),
        "redBloodCells": _parseValue(updatedValues['rbc']),
        "whiteBloodCells": _parseValue(updatedValues['wbc']),
        "platelets": _parseValue(updatedValues['platelets']),
        "plasma": _parseValue(updatedValues['plasma']),
        "cryoprecipitate": _parseValue(updatedValues['cryo']),
      }
    };

    try {
      final response = await http.patch(Uri.parse(url),
          headers: {
            "Content-Type": "application/json"
          },
          body: json.encode(data));

      if (response.statusCode == 200) {
        print("✅ Blood inventory updated successfully!");
        Navigator.pop(context, updatedValues);
      } else {
        print("❌ Failed to update: ${response.body}");
      }
    } catch (error) {
      print("❌ Error: $error");
    }
  }

  @override
  Widget
      build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Update Blood Inventory', style: TextStyle(color: Colors.white)),
        backgroundColor: MyColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Updating: ${widget.bloodType['type']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 20),
            _buildTextField('Whole Blood (Pints)', 'wholeBlood'),
            _buildTextField('Red Blood Cells (ml)', 'rbc'),
            _buildTextField('White Blood Cells (ml)', 'wbc'),
            _buildTextField('Platelets (ml)', 'platelets'),
            _buildTextField('Plasma (ml)', 'plasma'),
            _buildTextField('Cryoprecipitate (ml)', 'cryo'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateBloodInventory,
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Update Inventory', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      String key) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        onChanged: (value) {
          setState(() {
            updatedValues[key] = _parseValue(value);
          });
        },
        controller: TextEditingController(text: updatedValues[key].toString()),
      ),
    );
  }
}
