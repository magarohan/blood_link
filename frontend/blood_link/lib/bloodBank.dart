import 'package:flutter/material.dart';
import 'updateBloodInventory.dart'; // Ensure this import is correct

class BloodBank
    extends StatefulWidget {
  const BloodBank(
      {super.key});

  @override
  State<BloodBank> createState() =>
      _BloodBankState();
}

class _BloodBankState
    extends State<BloodBank> {
  // Example blood inventory data
  List<Map<String, dynamic>>
      bloodInventory =
      [
    {
      'type': 'A+',
      'wholeBlood': '10 Pints',
      'rbc': '1000 ml',
      'wbc': '1000 ml',
      'platelets': '1000 ml',
      'plasma': '1000 ml',
      'cryo': '1000 ml',
    },
    {
      'type': 'A-',
      'wholeBlood': '8 Pints',
      'rbc': '900 ml',
      'wbc': '800 ml',
      'platelets': '750 ml',
      'plasma': '850 ml',
      'cryo': '800 ml',
    },
    {
      'type': 'B+',
      'wholeBlood': '12 Pints',
      'rbc': '1100 ml',
      'wbc': '1000 ml',
      'platelets': '1050 ml',
      'plasma': '950 ml',
      'cryo': '1000 ml',
    },
    {
      'type': 'B-',
      'wholeBlood': '6 Pints',
      'rbc': '800 ml',
      'wbc': '700 ml',
      'platelets': '700 ml',
      'plasma': '800 ml',
      'cryo': '750 ml',
    },
    {
      'type': 'AB+',
      'wholeBlood': '5 Pints',
      'rbc': '950 ml',
      'wbc': '850 ml',
      'platelets': '900 ml',
      'plasma': '900 ml',
      'cryo': '850 ml',
    },
    {
      'type': 'AB-',
      'wholeBlood': '4 Pints',
      'rbc': '700 ml',
      'wbc': '600 ml',
      'platelets': '650 ml',
      'plasma': '750 ml',
      'cryo': '700 ml',
    },
  ];

  @override
  Widget
      build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const Icon(Icons.grid_view, color: Colors.red),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.red),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          AppBar(
            backgroundColor: Colors.red,
            title: const Text('Inventory'),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {},
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: bloodInventory.length,
                itemBuilder: (context, index) {
                  return _buildInventoryCard(bloodInventory[index], index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryCard(
      Map<String, dynamic> bloodType,
      int index) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.red),
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
            bloodType['type'] ?? 'N/A',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 10),
          Text('Whole blood: ${bloodType['wholeBlood'] ?? 'N/A'}'),
          Text('RBC: ${bloodType['rbc'] ?? 'N/A'}'),
          Text('WBC: ${bloodType['wbc'] ?? 'N/A'}'),
          Text('Platelets: ${bloodType['platelets'] ?? 'N/A'}'),
          Text('Plasma: ${bloodType['plasma'] ?? 'N/A'}'),
          Text('Cryoprecipitate: ${bloodType['cryo'] ?? 'N/A'}'),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateBloodInventory(
                    bloodType: bloodInventory[index],
                  ),
                ),
              ).then((updatedValues) {
                if (updatedValues != null) {
                  setState(() {
                    bloodInventory[index] = updatedValues;
                  });
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Update',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
