import 'package:blood_link/profile.dart';
import 'package:flutter/material.dart';
// // import 'package:khalti_flutter/khalti_flutter.dart';

import 'package:blood_link/login.dart';
import 'package:blood_link/signup.dart';
import 'package:blood_link/home.dart';
import 'package:blood_link/staff_managent.dart';
import 'package:blood_link/donor_management.dart';
import 'package:blood_link/blood_request_page.dart';
import 'package:blood_link/bloodbank_list.dart';
import 'package:blood_link/add_request_page.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/Login': (context) => const LoginScreen(),
        '/Signup': (context) => const SignupScreen(),
        '/StaffManagementPage': (context) => const StaffManagementPage(),
        '/DonorManagementPage': (context) => const DonorManagementPage(),
        '/BloodRequestsPage': (context) => const BloodRequestsPage(),
        '/BloodBankList': (context) => const BloodBankList(),
        '/Profile': (context) => const ProfilePage(),
        '/AddRequestPage': (context) => const AddRequestPage(),
        '/donorHome': (context) => const HomeScreen(),
      },
      localizationsDelegates: const [
        // KhaltiLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.red,
      ),
    );
  }
}
