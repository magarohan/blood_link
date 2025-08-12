# BloodLink

BloodLink is a **Flutter-based blood bank management system** that connects donors, recipients, and blood banks in a seamless way, helping ensure timely access to blood when needed.

---

##  Features

- Manage multiple blood banks and track their inventory  
- User authentication (donors and blood banks) with secure, token-based auto-login  
- Editable user profiles (state saved using SharedPreferences)  
- Visualize blood availability with pie charts (using the `pie_chart` package)  
- Cloud-hosted backend (Node.js & MongoDB)  
- [Optional] Search for nearby blood banks (planned)  

---

##  Tech Stack

- **Frontend**: Flutter (Dart)  
- **Backend**: Node.js & Express.js  
- **Database**: MongoDB  
- **State Management**: Provider  
- **Local Persistence**: SharedPreferences  
- **Hosting**: Railway (backend), TBD for frontend  

---

##  Setup & Usage

### Prerequisites

- Flutter SDK (stable channel) installed  
- Node.js and npm installed  
- A MongoDB instance (local or cloud-based)

### Clone & Install

```bash
git clone https://github.com/magarohan/blood_link.git
cd blood_link
