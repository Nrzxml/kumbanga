import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/database_service_api.dart';
import 'admin_child_list_page.dart';

class AdminChildrenScreen extends StatefulWidget {
  const AdminChildrenScreen({super.key});

  @override
  State<AdminChildrenScreen> createState() => _AdminChildrenScreenState();
}

class _AdminChildrenScreenState extends State<AdminChildrenScreen> {
  late Future<List<Map<String, dynamic>>> _usersFuture;

  @override
  void initState() {
    super.initState();
    final db = Provider.of<DatabaseServiceAPI>(context, listen: false);
    _usersFuture = db.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (_, index) {
              final u = users[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.person, color: Colors.green),
                  title: Text(u['name']),
                  subtitle: Text(u['email']),
                  trailing: const Icon(Icons.arrow_forward_ios),

                  /// ➜ PENCET USER → LIHAT DAFTAR ANAK
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AdminChildListPage(userId: u['id']),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
