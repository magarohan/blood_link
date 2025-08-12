import 'package:blood_link/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http;
import 'dart:convert';
import 'login.dart';
import '../app_config.dart';

class SignupScreen
    extends StatefulWidget {
  const SignupScreen(
      {super.key});

  @override
  SignupScreenState createState() =>
      SignupScreenState();
}

class SignupScreenState
    extends State<SignupScreen> {
  final _fullNameController =
      TextEditingController();
  final _emailController =
      TextEditingController();
  final _passwordController =
      TextEditingController();
  final _phoneController =
      TextEditingController();
  final _bloodTypeController =
      TextEditingController();
  final _rhFactorController =
      TextEditingController();
  final _locationController =
      TextEditingController();

  late Future<AppConfig>
      _configFuture;

  bool
      _isLoading =
      false;

  @override
  void
      initState() {
    super.initState();
    _configFuture =
        AppConfig.loadFromAsset();
  }

  Future<void>
      _register(AppConfig config) async {
    final fullName =
        _fullNameController.text.trim();
    final email =
        _emailController.text.trim();
    final password =
        _passwordController.text.trim();
    final phoneNumber =
        _phoneController.text.trim();
    final bloodType =
        _bloodTypeController.text.trim();
    final rhFactor =
        _rhFactorController.text.trim();
    final location =
        _locationController.text.trim();

    if (fullName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        phoneNumber.isEmpty ||
        bloodType.isEmpty ||
        rhFactor.isEmpty ||
        location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url =
        Uri.parse('${config.apiBaseUrl}/api/donors/signup');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'fullName': fullName,
          'email': email,
          'password': password,
          'phoneNumber': phoneNumber,
          'bloodType': bloodType,
          'rhFactor': rhFactor,
          'location': location,
        }),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['error'] ?? 'Registration Failed. Try Again!';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
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
    return FutureBuilder<AppConfig>(
      future: _configFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final config = snapshot.data!;
        return Scaffold(
          backgroundColor: MyColors.backgroundColor,
          appBar: AppBar(
            title: const Text('Sign Up', style: TextStyle(color: Colors.white)),
            backgroundColor: MyColors.primaryColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/blood_drop.png',
                          height: 120,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Blood Link',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: MyColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildTextField(_fullNameController, 'Full Name'),
                  const SizedBox(height: 10),
                  _buildTextField(_emailController, 'Email'),
                  const SizedBox(height: 10),
                  _buildTextField(_passwordController, 'Password', obscureText: true),
                  const SizedBox(height: 10),
                  _buildTextField(_phoneController, 'Phone Number'),
                  const SizedBox(height: 10),
                  _buildTextField(_bloodTypeController, 'Blood Type'),
                  const SizedBox(height: 10),
                  _buildTextField(_rhFactorController, 'Rh Factor'),
                  const SizedBox(height: 10),
                  _buildTextField(_locationController, 'Location'),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => _register(config),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Register',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Log In.',
                          style: TextStyle(
                            color: MyColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget
      _buildTextField(
    TextEditingController
        controller,
    String
        hintText, {
    bool obscureText =
        false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: MyColors.primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: MyColors.primaryColor, width: 2),
        ),
      ),
    );
  }
}
