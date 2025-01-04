import 'package:flutter/material.dart';

class HomeScreen
    extends StatelessWidget {
  const HomeScreen(
      {super.key});

  @override
  Widget
      build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.grid_view, color: Colors.red),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.red),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFeatureCard(Icons.campaign, "Campaigns"),
                _buildFeatureCard(Icons.history, "History"),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Donation Requests",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(">"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildDonationCard("Ram Nepal", "TU Teaching Hospital, Kathmandu", "A+"),
            const SizedBox(height: 10),
            _buildDonationCard("Shyam Nepal", "Bhaktapur Hospital", "B+"),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
      IconData icon,
      String title) {
    return Container(
      width: 150,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.red, size: 30),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Colors.red)),
        ],
      ),
    );
  }

  Widget _buildDonationCard(
      String name,
      String location,
      String bloodType) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name", style: TextStyle(color: Colors.grey[600])),
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text("Location", style: TextStyle(color: Colors.grey[600])),
                Text(location, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.red[100],
                radius: 25,
                child: Text(
                  bloodType,
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Donate",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
