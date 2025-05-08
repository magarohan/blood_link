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
import 'package:blood_link/bloodbank_list.dart';
import 'package:blood_link/profile.dart';
import 'package:blood_link/home.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:khalti_flutter/localization/khalti_localizations.dart';

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
    return KhaltiScope(
      publicKey: '522847f5cd004762b4fae02be75f6920',
      enabledDebugging: true,
      builder: (contex, navKey) {
        return MaterialApp(
          title: 'Blood Link',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          navigatorKey: navKey,
          localizationsDelegates: const [
            KhaltiLocalizations.delegate
          ],
          initialRoute: '/',
          routes: {
            '/': (context) => const LoginScreen(),
            '/Signup': (context) => const SignupScreen(),
            '/AdminHome': (context) => const AdminHome(),
            '/BloodRequestsPage': (context) => const BloodRequestsPage(),
            '/DonorManagementPage': (context) => const DonorManagementPage(),
            '/StaffManagementPage': (context) => const StaffManagementPage(),
            '/BloodBank': (context) => const BloodBank(
                  bloodBankId: '',
                ),
            '/AddRequestPage': (context) => const AddRequestPage(),
            '/UpdateBloodInventory': (context) {
              final Map<String, dynamic> bloodType = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
              return UpdateBloodInventory(bloodType: bloodType);
            },
            '/UpdateDonorPage': (context) {
              final Map<String, dynamic> donor = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
              return UpdateDonorPage(donor: donor);
            },
            '/BloodBankList': (context) => const BloodBankList(),
            '/Profile': (context) => const ProfilePage(),
            '/Home': (context) => const HomeScreen(),
            '/Login': (context) => const LoginScreen(),
          },
        );
      },
    );
  }
}
