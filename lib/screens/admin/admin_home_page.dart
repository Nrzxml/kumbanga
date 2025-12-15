import 'package:flutter/material.dart';

// ================= HALAMAN ADMIN =================
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

  // ================= REGISTER SEMUA HALAMAN =================
  final List<Widget> _pages = const [
    AdminDashboard(),
    AdminInformationPage(),
    AdminChildrenScreen(),
    AdminDonationScreen(),
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

      // ================= BOTTOM NAV BAR =================
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
            icon: Icon(Icons.volunteer_activism),
            label: "Donasi",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}

/// =================================================================
///                         DASHBOARD ADMIN
/// =================================================================
class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final parentState = context.findAncestorStateOfType<_AdminHomePageState>();

    return Container(
      color: Colors.green[50],
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= HEADER =================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green.shade700,
                  Colors.green.shade400,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Selamat Datang, Admin 👋",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Kelola data pengguna, anak, informasi, dan donasi",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ================= GRID MENU =================
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _DashboardMenuCard(
                  icon: Icons.group,
                  title: "Pengguna & Anak",
                  subtitle: "Kelola data anak",
                  onTap: () {
                    parentState?.setState(() {
                      parentState._selectedIndex = 2;
                    });
                  },
                ),
                _DashboardMenuCard(
                  icon: Icons.info_outline,
                  title: "Informasi",
                  subtitle: "Artikel & edukasi",
                  onTap: () {
                    parentState?.setState(() {
                      parentState._selectedIndex = 1;
                    });
                  },
                ),
                _DashboardMenuCard(
                  icon: Icons.volunteer_activism,
                  title: "Donasi",
                  subtitle: "Campaign donasi",
                  onTap: () {
                    parentState?.setState(() {
                      parentState._selectedIndex = 3;
                    });
                  },
                ),
                _DashboardMenuCard(
                  icon: Icons.person,
                  title: "Profil Admin",
                  subtitle: "Akun & pengaturan",
                  onTap: () {
                    parentState?.setState(() {
                      parentState._selectedIndex = 4;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// =================================================================
///                       CARD MENU DASHBOARD
/// =================================================================
class _DashboardMenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DashboardMenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.green.shade100,
                child: Icon(
                  icon,
                  color: Colors.green.shade700,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
