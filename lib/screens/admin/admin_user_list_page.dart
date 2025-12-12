import 'package:flutter/material.dart';
import '../../services/database_service_api.dart';
import 'package:provider/provider.dart';
import 'admin_child_list_page.dart';

class AdminUserListPage extends StatefulWidget {
  const AdminUserListPage({super.key});

  @override
  State<AdminUserListPage> createState() => _AdminUserListPageState();
}

class _AdminUserListPageState extends State<AdminUserListPage> {
  late Future<List<Map<String, dynamic>>> _usersFuture;

  @override
  void initState() {
    super.initState();
    final db = Provider.of<DatabaseServiceAPI>(context, listen: false);
    _usersFuture = db.getAllUsers(); // <-- kamu buat endpoint ini
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Pengguna"),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (_, i) {
              final u = users[i];
              return ListTile(
                title: Text(u['name']),
                subtitle: Text(u['email']),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminChildListPage(userId: u['id']),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
