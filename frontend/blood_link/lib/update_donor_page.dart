import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http;
import 'dart:convert';

class UpdateDonorPage
    extends StatefulWidget {
  final Map<
      String,
      dynamic>? donor;

  const UpdateDonorPage(
      {super.key,
      required this.donor});

  @override
  State<UpdateDonorPage> createState() =>
      _UpdateDonorPageState();
}

class _UpdateDonorPageState
    extends State<UpdateDonorPage> {
  final _formKey =
      GlobalKey<FormState>();

  final _nameController =
      TextEditingController();
  final _emailController =
      TextEditingController();
  final _passwordController =
      TextEditingController();
  final _phoneController =
      TextEditingController();
  final _bloodGroupController =
      TextEditingController();
  final _locationController =
      TextEditingController();

  bool
      _isLoading =
      false;

  @override
  void
      initState() {
    super.initState();

    if (widget.donor !=
        null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _nameController.text = widget.donor!['name'] ?? '';
          _emailController.text = widget.donor!['email'] ?? '';
          _phoneController.text = widget.donor!['phoneNumber'] ?? '';
          _bloodGroupController.text = widget.donor!['bloodGroup'] ?? '';
          _locationController.text = widget.donor!['location'] ?? '';
        });
      });
    }
  }

  Future<void>
      updateDonor() async {
    if (widget.donor ==
        null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final String
        url =
        'http://localhost:4000/api/donors/update/${widget.donor!['id']}';

    final name =
        _nameController.text.trim();
    final email =
        _emailController.text.trim();
    final password =
        _passwordController.text.trim();
    final phoneNumber =
        _phoneController.text.trim();
    final bloodGroup =
        _bloodGroupController.text.trim();
    final location =
        _locationController.text.trim();

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'phoneNumber': phoneNumber,
          'bloodGroup': bloodGroup,
          'location': location,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Donor updated successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update donor')),
        );
      }
    } catch (error) {
      print('Error updating donor: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating donor')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget
      build(BuildContext context) {
    if (widget.donor ==
        null) {
      return const Scaffold(
        body: Center(child: Text('No donor data available')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Update Donor'),
        backgroundColor: Colors.red,
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
              _buildHeader(),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(_nameController, 'Name', TextInputType.name),
                    const SizedBox(height: 10),
                    _buildTextField(_emailController, 'Email', TextInputType.emailAddress),
                    const SizedBox(height: 10),
                    _buildTextField(_passwordController, 'Password', TextInputType.visiblePassword, obscureText: true),
                    const SizedBox(height: 10),
                    _buildTextField(_phoneController, 'Phone Number', TextInputType.phone),
                    const SizedBox(height: 10),
                    _buildTextField(_bloodGroupController, 'Blood Group', TextInputType.text),
                    const SizedBox(height: 10),
                    _buildTextField(_locationController, 'Location', TextInputType.text),
                    const SizedBox(height: 20),
                    _buildUpdateButton(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget
      _buildHeader() {
    return Center(
      child: Column(
        children: [
          Image.asset('assets/blood_drop.png', height: 120),
          const SizedBox(height: 10),
          const Text(
            'Blood Link',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String hintText,
      TextInputType keyboardType,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }

  Widget
      _buildUpdateButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: _isLoading ? null : updateDonor,
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Update',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
      ),
    );
  }
}
