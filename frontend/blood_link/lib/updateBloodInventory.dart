import 'package:flutter/material.dart';

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
                onPressed: () {
                  Navigator.pop(context, updatedValues); // Pass updated values back
                },
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
