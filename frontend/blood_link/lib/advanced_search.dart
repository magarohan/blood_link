import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http;
import 'dart:convert';
import 'package:blood_link/themes/colors.dart';

class AdvanceSearchPage
    extends StatefulWidget {
  const AdvanceSearchPage(
      {super.key});

  @override
  State<AdvanceSearchPage> createState() =>
      _AdvanceSearchPageState();
}

class _AdvanceSearchPageState
    extends State<AdvanceSearchPage> {
  List<Map<String, dynamic>>
      combinedData =
      [];
  List<Map<String, dynamic>>
      filteredData =
      [];

  bool
      isLoading =
      true;

  // Filters
  String?
      selectedLocation;
  String?
      selectedBloodType;
  String?
      selectedRhFactor;

  List<String>
      allLocations =
      [];
  List<String>
      bloodTypes =
      [
    'A',
    'B',
    'AB',
    'O'
  ];
  List<String>
      rhFactors =
      [
    '+',
    '-'
  ];

  @override
  void
      initState() {
    super.initState();
    fetchAllData();
  }

  Future<void>
      fetchAllData() async {
    const String baseURL = kIsWeb
        ? 'http://localhost:4000'
        : 'http://10.0.2.2:4000';

    try {
      final bloodBanksRes = await http.get(Uri.parse('$baseURL/api/bloodBanks'));

      if (bloodBanksRes.statusCode == 200) {
        List<dynamic> bloodBanks = json.decode(bloodBanksRes.body);
        List<Map<String, dynamic>> tempData = [];

        for (var bank in bloodBanks) {
          final bankId = bank['_id'];
          final bankName = bank['name'];
          final bankLocation = bank['address'];

          final inventoryRes = await http.get(Uri.parse('$baseURL/api/bloods/bank/$bankId'));

          if (inventoryRes.statusCode == 200) {
            List<dynamic> inventories = json.decode(inventoryRes.body);

            for (var inventory in inventories) {
              tempData.add({
                'bloodBank': bankName,
                'location': bankLocation,
                'bloodType': inventory['bloodType'] ?? 'N/A',
                'rhFactor': inventory['rhFactor'] ?? 'N/A',
                'wholeBlood': inventory['components']?['wholeBlood'] ?? 0,
                'rbc': inventory['components']?['redBloodCells'] ?? 0,
                'wbc': inventory['components']?['whiteBloodCells'] ?? 0,
                'platelets': inventory['components']?['platelets'] ?? 0,
                'plasma': inventory['components']?['plasma'] ?? 0,
                'cryoprecipitate': inventory['components']?['cryoprecipitate'] ?? 0,
              });
            }
          }
        }

        setState(() {
          combinedData = tempData;
          filteredData = List.from(combinedData);
          allLocations = combinedData.map((e) => e['location'] as String).toSet().toList()..sort();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load blood banks');
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void
      applyFilters() {
    setState(() {
      filteredData = combinedData.where((item) {
        final matchLocation = selectedLocation == null || item['location'] == selectedLocation;
        final matchBloodType = selectedBloodType == null || item['bloodType'] == selectedBloodType;
        final matchRhFactor = selectedRhFactor == null || item['rhFactor'] == selectedRhFactor;
        return matchLocation && matchBloodType && matchRhFactor;
      }).toList();
    });
  }

  DataCell
      styledCell(int value) {
    return DataCell(
      Text(
        '$value',
        style: TextStyle(
          color: value < 5 ? Colors.red : Colors.black,
          fontWeight: value < 5 ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  DataRow
      buildDataRow(Map<String, dynamic> item) {
    return DataRow(cells: [
      DataCell(Text(item['bloodBank'])),
      DataCell(Text(item['location'])),
      DataCell(Text(item['bloodType'])),
      DataCell(Text(item['rhFactor'])),
      styledCell(item['wholeBlood']),
      styledCell(item['rbc']),
      styledCell(item['wbc']),
      styledCell(item['platelets']),
      styledCell(item['plasma']),
      styledCell(item['cryoprecipitate']),
    ]);
  }

  Widget
      buildDropdown<T>(
    String
        label,
    T? selectedValue,
    List<T>
        options,
    void Function(T?)
        onChanged,
  ) {
    return DropdownButtonFormField<T>(
      value: selectedValue,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      isExpanded: true,
      items: [
        const DropdownMenuItem(value: null, child: Text('All')),
        ...options.map((option) => DropdownMenuItem(value: option, child: Text(option.toString()))),
      ],
      onChanged: onChanged,
    );
  }

  @override
  Widget
      build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        title: const Text('Advanced Search', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: buildDropdown<String>('Location', selectedLocation, allLocations, (val) {
                              selectedLocation = val;
                              applyFilters();
                            }),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: buildDropdown<String>('Blood Type', selectedBloodType, bloodTypes, (val) {
                              selectedBloodType = val;
                              applyFilters();
                            }),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: buildDropdown<String>('Rh Factor', selectedRhFactor, rhFactors, (val) {
                              selectedRhFactor = val;
                              applyFilters();
                            }),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedLocation = null;
                            selectedBloodType = null;
                            selectedRhFactor = null;
                            filteredData = List.from(combinedData);
                          });
                        },
                        child: const Text('Reset Filters'),
                      )
                    ],
                  ),
                ),
                const Divider(height: 1, color: Colors.grey),
                Expanded(
                  child: filteredData.isEmpty
                      ? const Center(child: Text('No matching data found.'))
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: DataTable(
                              headingRowColor: WidgetStateProperty.all(MyColors.primaryColor.withOpacity(0.8)),
                              headingTextStyle: const TextStyle(color: Colors.white),
                              border: TableBorder.all(color: Colors.grey.shade300),
                              columns: const [
                                DataColumn(label: Text('Blood Bank')),
                                DataColumn(label: Text('Location')),
                                DataColumn(label: Text('Blood Type')),
                                DataColumn(label: Text('Rh Factor')),
                                DataColumn(label: Text('Whole Blood')),
                                DataColumn(label: Text('RBC')),
                                DataColumn(label: Text('WBC')),
                                DataColumn(label: Text('Platelets')),
                                DataColumn(label: Text('Plasma')),
                                DataColumn(label: Text('Cryoprecipitate')),
                              ],
                              rows: filteredData.map(buildDataRow).toList(),
                            ),
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}
