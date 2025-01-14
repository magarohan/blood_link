import 'package:flutter/material.dart';
import 'package:blood_link/login.dart';
import 'package:blood_link/signup.dart';
import 'package:blood_link/adminHome.dart';
import 'package:blood_link/bloodRequestPage.dart';
import 'package:blood_link/donorManagement.dart';
import 'package:blood_link/staffManagent.dart';

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
      },
    );
  }
}
