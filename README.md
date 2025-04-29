Blood Link
Blood Link is a Flutter-based Blood Management System designed to connect blood donors, recipients, and blood banks efficiently. The application aims to simplify the process of finding and managing blood supplies, ensuring that blood is always available when urgently needed.

Features
🏥 Manage Multiple Blood Banks

🩸 Track Blood Inventory for each blood bank

🙋 User Registration and Login (for both donors and blood banks)

🛡️ Secure Authentication with token-based auto-login

👤 Editable User Profiles (with data saving to database and SharedPreferences)

📊 Pie Chart Visualization of available blood types (pie_chart package)

☁️ Cloud-hosted Backend (Node.js)

🔎 Search and List Blood Banks near users

Tech Stack
Frontend: Flutter (Dart)

Backend: Node.js (Express.js)

Database: MongoDB

State Management: Provider

Local Storage: SharedPreferences

Cloud Hosting: TBD (Coming Soon)

Setup Instructions
Prerequisites
Flutter SDK installed (Stable Channel)

Node.js and npm installed

MongoDB instance (local or cloud)

Flutter App
Clone the repo:

bash
Copy
Edit
git clone https://github.com/magarohan/blood_link.git
cd blood_link
Install dependencies:

bash
Copy
Edit
flutter pub get
Run the app:

bash
Copy
Edit
flutter run
Make sure a simulator/emulator or physical device is connected.

Backend (Optional for Full Functionality)
Navigate to your backend directory (if available).

Install server dependencies:

bash
Copy
Edit
npm install
Run the server:

bash
Copy
Edit
npm start
Update the API URLs in your Flutter app if necessary.

Project Structure
bash
Copy
Edit
/lib
  /screens
    bloodBankList.dart
    profile.dart
    login.dart
    signup.dart
    home.dart
  /services
    auth_service.dart
    blood_bank_service.dart
  /models
    user.dart
    blood_bank.dart
/assets
  /images
Contributions
Contributions, issues, and feature requests are welcome!
Feel free to fork the repo and submit a pull request.
