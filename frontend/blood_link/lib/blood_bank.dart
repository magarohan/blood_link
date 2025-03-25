import 'package:blood_link/themes/colors.dart';
import 'package:blood_link/update_blood_inventory.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http;
import 'dart:convert';
import 'package:pie_chart/pie_chart.dart';

class BloodBank
    extends StatefulWidget {
  final String
      bloodBankId;

  const BloodBank(
      {super.key,
      required this.bloodBankId});

  @override
  State<BloodBank> createState() =>
      _BloodBankState();
}

class _BloodBankState
    extends State<BloodBank> {
  List<Map<String, dynamic>>
      bloodInventory =
      [];
  bool
      isLoading =
      true;

  @override
  void
      initState() {
    super.initState();
    fetchBloodInventory();
  }

  Future<void>
      fetchBloodInventory() async {
    String url = kIsWeb
        ? 'http://localhost:4000/api/bloods/bank/${widget.bloodBankId}'
        : 'http://10.0.2.2:4000/api/bloods/bank/${widget.bloodBankId}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          bloodInventory = data.map((item) {
            return {
              'id': item['_id'], // ✅ Ensure the ID is included
              'type': '${item['bloodType']}${item['rhFactor']}',
              'bloodType': item['bloodType'],
              'rhFactor': item['rhFactor'],
              'wholeBlood': item['components']['wholeBlood'] ?? 0,
              'rbc': item['components']['redBloodCells'] ?? 0,
              'wbc': item['components']['whiteBloodCells'] ?? 0,
              'platelets': item['components']['platelets'] ?? 0,
              'plasma': item['components']['plasma'] ?? 0,
              'cryo': item['components']['cryoprecipitate'] ?? 0,
            };
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load blood inventory');
      }
    } catch (error) {
      print('Error fetching blood inventory: $error');
      setState(() {
        isLoading = false;
        bloodInventory = [];
      });
    }
  }

  Map<String, double>
      getPieChartData() {
    Map<String, double>
        dataMap =
        {};
    for (var item
        in bloodInventory) {
      String type = item['type'];
      double quantity = (item['wholeBlood'] as num).toDouble();
      if (quantity > 0) {
        dataMap[type] = quantity;
      }
    }
    return dataMap.isEmpty
        ? {
            'No Data': 1
          }
        : dataMap;
  }

  @override
  Widget
      build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Blood Inventory', style: TextStyle(color: Colors.white)),
        backgroundColor: MyColors.primaryColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : bloodInventory.isEmpty
              ? const Center(
                  child: Text(
                    'No blood inventory available',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      PieChart(
                        dataMap: getPieChartData(),
                        chartRadius: MediaQuery.of(context).size.width / 2.5,
                        colorList: const [
                          Colors.red,
                          Colors.blue,
                          Colors.green,
                          Colors.orange,
                          Colors.purple,
                          Colors.yellow
                        ],
                        legendOptions: const LegendOptions(showLegendsInRow: false, legendPosition: LegendPosition.right),
                        chartValuesOptions: const ChartValuesOptions(showChartValuesInPercentage: true, showChartValuesOutside: true),
                      ),
                      const SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(10),
                        itemCount: bloodInventory.length,
                        itemBuilder: (context, index) {
                          var bloodType = bloodInventory[index];
                          return Container(
                            padding: const EdgeInsets.all(16.0),
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.red),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 3))
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bloodType['type'] ?? 'N/A',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                                ),
                                const SizedBox(height: 10),
                                Text('Whole Blood: ${bloodType['wholeBlood']} Pints'),
                                Text('RBC: ${bloodType['rbc']} ml'),
                                Text('WBC: ${bloodType['wbc']} ml'),
                                Text('Platelets: ${bloodType['platelets']} ml'),
                                Text('Plasma: ${bloodType['plasma']} ml'),
                                Text('Cryoprecipitate: ${bloodType['cryo']} ml'),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdateBloodInventory(bloodType: bloodType),
                                      ),
                                    ).then((_) => fetchBloodInventory());
                                  },
                                  style: ElevatedButton.styleFrom(backgroundColor: MyColors.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                  child: const Text('Update', style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}
