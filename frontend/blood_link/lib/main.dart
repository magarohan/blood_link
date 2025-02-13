import 'package:flutter/material.dart';
import 'package:blood_link/login.dart';
import 'package:blood_link/signup.dart';
import 'package:blood_link/admin_home.dart';
import 'package:blood_link/blood_request_page.dart';
import 'package:blood_link/donor_management.dart';
import 'package:blood_link/staff_managent.dart';
import 'package:blood_link/update_blood_inventory.dart';
import 'package:blood_link/blood_bank.dart';
import 'package:blood_link/add_request_page.dart';
import 'package:blood_link/update_donor_page.dart';

void
    main() {
  runApp(
      const MyApp());
}

class MyApp
    extends StatelessWidget {
  const MyApp(
      {super.key});

  @override
  Widget
      build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Link',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/Signup': (context) => const SignupScreen(),
        '/AdminHome': (context) => const AdminHome(),
        '/BloodRequestsPage': (context) => const BloodRequestsPage(),
        '/DonorManagementPage': (context) => const DonorManagementPage(),
        '/StaffManagementPage': (context) => const StaffManagementPage(),
        '/BloodBank': (context) => const BloodBank(),
        '/AddRequestPage': (context) => const AddRequestPage(),
        '/UpdateBloodInventory': (context) {
          final Map<String, dynamic> bloodType = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return UpdateBloodInventory(bloodType: bloodType);
        },
        '/UpdateDonorPage': (context) {
          final Map<String, dynamic> donor = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return UpdateDonorPage(donor: donor);
        },
      },
    );
  }
}
