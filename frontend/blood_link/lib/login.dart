import 'package:blood_link/blood_bank.dart';
import 'package:blood_link/themes/colors.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'signup.dart';
import 'package:http/http.dart'
    as http;
import 'dart:convert';
import 'admin_home.dart';
import 'bloodbank_list.dart';

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

    setState(() {
      _isLoading = true;
    });

    final donorURI =
        'http://localhost:4000/api/donors/login';
    final bloodBankURI =
        'http://localhost:4000/api/bloodBanks/login';

    try {
      // Try logging in as a donor first
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful as Donor!')),
        );

        // Navigate to Donor Home Screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        return;
      }

      // If donor login fails, try blood bank login
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
        final bloodBankId = bloodBankData['bloodBank']['_id'];

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful as Blood Bank!')),
        );

        // Navigate to Blood Bank Home Screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BloodBank(bloodBankId: bloodBankId),
          ),
        );
        return;
      }

      // If both logins fail, show an error
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
                  // Navigate to RegisterScreen if the user doesn't have an account
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
