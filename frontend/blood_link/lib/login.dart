import 'package:blood_link/admin_home.dart';
import 'package:blood_link/blood_bank.dart';
import 'package:blood_link/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'signup.dart';
import 'package:http/http.dart'
    as http;
import 'dart:convert';

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

  Future<void>
      _login() async {
    final email =
        _emailController.text.trim();
    final password =
        _passwordController.text.trim();

    if (email.isEmpty ||
        password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email and Password are required')),
      );
      return;
    }

    if (email == "admin" ||
        password == "admin") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminHome()),
      );
    }

    setState(() {
      _isLoading = true;
    });

    const donorURI =
        'http://localhost:4000/api/donors/login';
    const bloodBankURI =
        'http://localhost:4000/api/bloodBanks/login';

    try {
      // Try logging in as a donor
      final donorResponse = await http.post(
        Uri.parse(donorURI),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (donorResponse.statusCode == 200) {
        final donorData = json.decode(donorResponse.body);

        if (donorData != null && donorData.containsKey('donor')) {
          final donor = donorData['donor'];
          final token = donorData['token'];

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('donorName', donor['fullName'] ?? '');
          await prefs.setString('donorBloodType', donor['bloodType'] ?? '');
          await prefs.setString('donorRhFactor', donor['rhFactor'] ?? '');
          await prefs.setString('donorEmail', donor['email'] ?? '');
          await prefs.setString('donorToken', token ?? ''); // Save token for authentication

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

      // Try blood bank login if donor login fails
      final bloodBankResponse = await http.post(
        Uri.parse(bloodBankURI),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (bloodBankResponse.statusCode == 200) {
        final bloodBankData = json.decode(bloodBankResponse.body);
        final bloodBankId = bloodBankData['bloodBank']['_id'];

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful as Blood Bank!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BloodBank(bloodBankId: bloodBankId),
          ),
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
      print("Error: $error");
    }
  }

  @override
  Widget
      build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 80),
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.primaryColor,
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupScreen()),
                  );
                },
                child: const Text('Register Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
