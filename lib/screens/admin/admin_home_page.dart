import 'package:flutter/material.dart';

// Halaman Admin
import 'admin_information_page.dart';
import 'admin_children_screen.dart';
import 'admin_profile_screen.dart';
import 'admin_user_list_page.dart';
import 'admin_donation_screen.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;

  /// ==========================
  ///  REGISTER SEMUA HALAMAN
  /// ==========================
  final List<Widget> _pages = const [
    AdminDashboard(),
    AdminInformationPage(),
    AdminChildrenScreen(),
    AdminDonationScreen(), // <<< DONASI DI ADMIN
    AdminProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Admin Panel",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.green,
        elevation: 2,
      ),
      body: _pages[_selectedIndex],

      /// ==========================
      ///  BOTTOM NAV BAR
      /// ==========================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "Informasi"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Data Anak"),
          BottomNavigationBarItem(
              icon: Icon(Icons.volunteer_activism), label: "Donasi"), // <<< NEW
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}

/// ===============================
///        DASHBOARD ADMIN
/// ===============================
class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final parentState = context.findAncestorStateOfType<_AdminHomePageState>();

    return Container(
      color: Colors.green[50],
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dashboard, size: 90, color: Colors.green[800]),
            const SizedBox(height: 20),

            Text(
              "Selamat Datang Admin!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green[900],
              ),
            ),

            const SizedBox(height: 30),

            /// CARD KE DATA ANAK
            GestureDetector(
              onTap: () => parentState?.setState(() {
                parentState._selectedIndex = 2;
              }),
              child: const DashboardCard(
                icon: Icons.group,
                title: "Data Pengguna & Anak",
              ),
            ),

            const SizedBox(height: 20),

            /// CARD KE INFORMASI
            GestureDetector(
              onTap: () => parentState?.setState(() {
                parentState._selectedIndex = 1;
              }),
              child: const DashboardCard(
                icon: Icons.info_outline,
                title: "Kelola Informasi",
              ),
            ),

            const SizedBox(height: 20),

            /// CARD KE DONASI (NEW)
            GestureDetector(
              onTap: () => parentState?.setState(() {
                parentState._selectedIndex = 3;
              }),
              child: const DashboardCard(
                icon: Icons.volunteer_activism,
                title: "Kelola Donasi",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const DashboardCard({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.green, size: 40),
            const SizedBox(width: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
