import 'package:flutter/material.dart';

class BloodRequestsPage
    extends StatelessWidget {
  const BloodRequestsPage(
      {super.key});

  @override
  Widget
      build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blood Requests"),
        backgroundColor: Colors.red,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildRequestCard("Ram Nepal", "TU Teaching Hospital", "A+"),
          _buildRequestCard("Shyam Nepal", "Bhaktapur Hospital", "B+"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add request logic
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildRequestCard(
      String name,
      String location,
      String bloodType) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.red[100],
          child: Text(
            bloodType,
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(name),
        subtitle: Text(location),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            // Delete request logic
          },
        ),
      ),
    );
  }
}
