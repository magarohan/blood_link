import 'package:flutter/material.dart';
import 'package:blood_link/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage
    extends StatefulWidget {
  const ProfilePage(
      {super.key});

  @override
  _ProfilePageState createState() =>
      _ProfilePageState();
}

class _ProfilePageState
    extends State<ProfilePage> {
  String
      name =
      '';
  String
      bloodType =
      '';
  String
      rhFactor =
      '';
  String
      email =
      '';
  String
      location =
      '';

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
    setState(() {
      name = prefs.getString('donorName') ?? 'N/A';
      bloodType = prefs.getString('donorBloodType') ?? 'N/A';
      rhFactor = prefs.getString('donorRhFactor') ?? 'N/A';
      email = prefs.getString('donorEmail') ?? 'N/A';
      location = prefs.getString('donorLocation') ?? 'N/A';
    });
  }

  @override
  Widget
      build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: MyColors.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileField(label: 'Name', value: name),
                ProfileField(label: 'Email', value: email),
                ProfileField(label: 'Blood Type', value: '$bloodType $rhFactor'),
                ProfileField(label: 'Location', value: location),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: MyColors.primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: 2,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/BloodBankList');
          } else if (index == 0) {
            Navigator.pushNamed(context, '/Home');
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

class ProfileField
    extends StatelessWidget {
  final String
      label;
  final String
      value;

  const ProfileField(
      {super.key,
      required this.label,
      required this.value});

  @override
  Widget
      build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: MyColors.primaryColor),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
