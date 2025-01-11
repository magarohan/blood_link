import 'package:blood_link/signup.dart';
import 'package:flutter/material.dart';

class DonorManagementPage
    extends StatelessWidget {
  const DonorManagementPage(
      {super.key});

  @override
  Widget
      build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Donor Management"),
        backgroundColor: Colors.red,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildDonorCard("Alice Johnson", "alice.johnson@example.com"),
          _buildDonorCard("Bob Smith", "bob.smith@example.com"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignupScreen()),
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDonorCard(
      String name,
      String email) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        title: Text(name),
        subtitle: Text(email),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                // Edit donor logic
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // Delete donor logic
              },
            ),
          ],
        ),
      ),
    );
  }
}
