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
import 'package:blood_link/app_config.dart';

void
    main() async {
  WidgetsFlutterBinding
      .ensureInitialized();
  final config =
      await AppConfig.loadFromAsset();
  runApp(
      MyApp(apiBaseUrl: config.apiBaseUrl));
}

class MyApp
    extends StatelessWidget {
  final String
      apiBaseUrl;
  const MyApp(
      {super.key,
      required this.apiBaseUrl});

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
        '/AddRequestPage': (context) => AddRequestPage(config: AppConfig(apiBaseUrl: apiBaseUrl)),
        '/donorHome': (context) => const HomeScreen(),
        '/profile': (context) => const ProfilePage(),
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
