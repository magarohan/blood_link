import 'package:blood_link/themes/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http;
import 'package:khalti_flutter/khalti_flutter.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

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
    _checkLoginStatus();
  }

  Future<void>
      _checkLoginStatus() async {
    final prefs =
        await SharedPreferences.getInstance();
    final token =
        prefs.getString('donorToken');

    if (token != null &&
        token.isNotEmpty) {
      _loadDonorInfo();
    } else {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
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

  Future<void>
      _logout() async {
    final prefs =
        await SharedPreferences.getInstance();
    await prefs.clear();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  void
      donateWithKhalti() {
    KhaltiScope.of(context).pay(
      config: PaymentConfig(
        amount: 10000, // in paisa (Rs. 100 = 10000)
        productIdentity: 'donation-001',
        productName: 'Donation',
      ),
      preferences: [
        PaymentPreference.khalti, // Only enable Khalti wallet
      ],
      onSuccess: onSuccess,
      onFailure: onFailure,
      onCancel: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Payment Cancelled")),
        );
      },
    );
  }

  void onSuccess(
      PaymentSuccessModel success) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text("Donation Successful"),
          actions: [
            SimpleDialogOption(
              child: const Text("Okay"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void onFailure(
      PaymentFailureModel failure) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text("Donation Failed"),
          actions: [
            SimpleDialogOption(
              child: const Text("Okay"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget
      build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          donorName != null ? 'Welcome, $donorName!' : 'Welcome!',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: MyColors.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: bloodRequests.isEmpty
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: MyColors.primaryColor,
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: donateWithKhalti,
        label: const Text('Donate'),
        icon: const Icon(Icons.favorite),
        backgroundColor: MyColors.primaryColor,
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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
