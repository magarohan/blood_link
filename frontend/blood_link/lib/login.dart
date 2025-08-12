import 'package:blood_link/admin_home.dart';
import 'package:blood_link/blood_bank.dart';
import 'package:blood_link/home.dart';
import 'package:blood_link/themes/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_config.dart';

class LoginScreen
    extends StatefulWidget {
  const LoginScreen(
      {super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {
  final TextEditingController
      _emailController =
      TextEditingController();
  final TextEditingController
      _passwordController =
      TextEditingController();
  bool
      _isLoading =
      false;
  bool
      _checkingLogin =
      true;
  late AppConfig
      config;

  @override
  void
      initState() {
    super.initState();
    _initialize();
  }

  Future<void>
      _initialize() async {
    config =
        await AppConfig.loadFromAsset();
    await _checkIfAlreadyLoggedIn();
  }

  Future<void>
      _checkIfAlreadyLoggedIn() async {
    final prefs =
        await SharedPreferences.getInstance();
    final donorToken =
        prefs.getString('donorToken');
    final bloodBankToken =
        prefs.getString('bloodBankToken');

    if (donorToken != null &&
        donorToken.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (bloodBankToken != null && bloodBankToken.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BloodBank(
            bloodBankId: prefs.getString('bloodBankId') ?? '',
            apiBaseUrl: config.apiBaseUrl,
          ),
        ),
      );
    } else {
      setState(() {
        _checkingLogin = false;
      });
    }
  }

  Future<void>
      _login() async {
    final email =
        _emailController.text.trim();
    final password =
        _passwordController.text.trim();

    if (email.isEmpty ||
        password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Both Email and Password are required')),
      );
      return;
    }

    if (email == "admin" &&
        password == "admin") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => AdminHome(
                  apiBaseUrl: config.apiBaseUrl,
                )),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final donorURI =
        '${config.apiBaseUrl}/api/donors/login';
    final bloodBankURI =
        '${config.apiBaseUrl}/api/bloodBanks/login';

    try {
      final donorResponse = await http.post(
        Uri.parse(donorURI),
        headers: {
          'Content-Type': 'application/json'
        },
        body: json.encode({
          'email': email,
          'password': password
        }),
      );

      if (donorResponse.statusCode == 200) {
        final donorData = json.decode(donorResponse.body);
        if (donorData != null && donorData.containsKey('donor')) {
          final donor = donorData['donor'];
          final token = donorData['token'];

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('donorId', donor['_id'] ?? '');
          await prefs.setString('donorName', donor['fullName'] ?? '');
          await prefs.setString('donorBloodType', donor['bloodType'] ?? '');
          await prefs.setString('donorRhFactor', donor['rhFactor'] ?? '');
          await prefs.setString('donorEmail', donor['email'] ?? '');
          await prefs.setString('donorLocation', donor['location'] ?? '');
          await prefs.setString('donorToken', token ?? '');

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login Successful as Donor!')),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
          return;
        }
      }

      final bloodBankResponse = await http.post(
        Uri.parse(bloodBankURI),
        headers: {
          'Content-Type': 'application/json'
        },
        body: json.encode({
          'email': email,
          'password': password
        }),
      );

      if (bloodBankResponse.statusCode == 200) {
        final bloodBankData = json.decode(bloodBankResponse.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('bloodBankToken', bloodBankData['token']);
        await prefs.setString('bloodBankId', bloodBankData['bloodBank']['_id']);
        final bloodBankId = bloodBankData['bloodBank']['_id'];

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful as Blood Bank!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => BloodBank(
                    bloodBankId: bloodBankId,
                    apiBaseUrl: config.apiBaseUrl,
                  )),
        );
        return;
      }

      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again later.')),
      );
      if (kDebugMode) {
        print("Error: $error");
      }
    }
  }

  @override
  Widget
      build(BuildContext context) {
    if (_checkingLogin) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
        child: Column(
          children: [
            Image.asset('assets/blood_drop.png', height: 120),
            const SizedBox(height: 10),
            Text(
              'Blood Link',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: MyColors.primaryColor),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(backgroundColor: MyColors.primaryColor),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
