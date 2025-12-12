import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/database_service_api.dart';
import '../../models/child.dart';
import 'admin_child_development_page.dart';

class AdminChildListPage extends StatefulWidget {
  final String userId;

  const AdminChildListPage({super.key, required this.userId});

  @override
  State<AdminChildListPage> createState() => _AdminChildListPageState();
}

class _AdminChildListPageState extends State<AdminChildListPage> {
  late Future<List<Child>> _childrenFuture;

  @override
  void initState() {
    super.initState();
    final db = Provider.of<DatabaseServiceAPI>(context, listen: false);
    _childrenFuture = db.getChildrenByUser(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Anak"),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<Child>>(
        future: _childrenFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final kids = snapshot.data!;

          if (kids.isEmpty) {
            return Center(
              child: Text(
                "Belum ada data anak",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            );
          }

          return ListView.builder(
            itemCount: kids.length,
            itemBuilder: (_, i) {
              final child = kids[i];

              return ListTile(
                title: Text(child.name),
                subtitle: Text("Tanggal Lahir: ${child.birthDate}"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminChildDevelopmentPage(
                        childId: child.id,
                        childName: child.name,
                      ),
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
