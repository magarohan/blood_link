import 'package:blood_link/themes/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen
    extends StatefulWidget {
  const HomeScreen(
      {super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {
  String?
      donorName;
  String?
      donorBloodType;
  String?
      donorRhFactor;
  bool
      isLoading =
      true;
  List<Map<String, dynamic>>
      bloodRequests =
      [];

  @override
  void
      initState() {
    super.initState();
    _loadDonorInfo();
  }

  Future<void>
      _loadDonorInfo() async {
    final prefs =
        await SharedPreferences.getInstance();
    final name =
        prefs.getString('donorName');
    final bloodType =
        prefs.getString('donorBloodType');
    final rhFactor =
        prefs.getString('donorRhFactor');

    if (name != null &&
        bloodType != null &&
        rhFactor != null) {
      setState(() {
        donorName = name;
        donorBloodType = bloodType;
        donorRhFactor = rhFactor;
      });
      _fetchMatchingBloodRequests(bloodType, rhFactor);
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No donor info found. Please log in again.')),
      );
    }
  }

  Future<void> _fetchMatchingBloodRequests(
      String bloodType,
      String rhFactor) async {
    final url = kIsWeb
        ? Uri.parse('http://localhost:4000/api/requests/search?bloodType=$bloodType&rhFactor=$rhFactor')
        : Uri.parse('http://10.0.2.2:4000/api/requests/search?bloodType=$bloodType&rhFactor=$rhFactor');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          setState(() {
            bloodRequests = List<Map<String, dynamic>>.from(data);
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No matching blood requests found.')),
          );
        }
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No matching blood requests found.')),
        );
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred while fetching requests.')),
      );
      print(error);
    }
  }

  @override
  Widget
      build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          donorName != null ? 'Welcome, $donorName!' : 'Welcome!',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: MyColors.primaryColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : bloodRequests.isEmpty
              ? const Center(child: Text('No matching blood requests found.'))
              : ListView.builder(
                  itemCount: bloodRequests.length,
                  itemBuilder: (context, index) {
                    final request = bloodRequests[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 2,
                      child: ListTile(
                        title: Text('Requested by: ${request['name']}'),
                        subtitle: Text('Location: ${request['location']}'),
                        trailing: Text(
                          '${request['bloodType']} ${request['rhFactor']}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: MyColors.primaryColor),
                        ),
                      ),
                    );
                  },
                ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: MyColors.primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/BloodBankList');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/Profile');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
