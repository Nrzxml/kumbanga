import 'package:flutter/material.dart';
import '../../services/database_service_api.dart';

class AdminInformationPage extends StatefulWidget {
  const AdminInformationPage({super.key});

  @override
  State<AdminInformationPage> createState() => _AdminInformationPageState();
}

class _AdminInformationPageState extends State<AdminInformationPage> {
  final db = DatabaseServiceAPI();

  List<Map<String, dynamic>> informasi = [];

  @override
  void initState() {
    super.initState();
    loadInformasi();
  }

  Future<void> loadInformasi() async {
    final data = await db.getInformasi();
    setState(() => informasi = data);
  }

  void showAddDialog() {
    final judulC = TextEditingController();
    final deskC = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tambah Informasi"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: judulC,
              decoration: const InputDecoration(labelText: "Judul"),
            ),
            TextField(
              controller: deskC,
              decoration: const InputDecoration(labelText: "Deskripsi"),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Simpan"),
            onPressed: () async {
              await db.addInformasi(judulC.text, deskC.text);
              Navigator.pop(context);
              loadInformasi();
            },
          ),
        ],
      ),
    );
  }

  void showEditDialog(Map info) {
    final judulC = TextEditingController(text: info['judul']);
    final deskC = TextEditingController(text: info['deskripsi']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Informasi"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: judulC,
              decoration: const InputDecoration(labelText: "Judul"),
            ),
            TextField(
              controller: deskC,
              decoration: const InputDecoration(labelText: "Deskripsi"),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Update"),
            onPressed: () async {
              await db.updateInformasi(
                info['id'].toString(),
                judulC.text,
                deskC.text,
              );

              Navigator.pop(context);
              loadInformasi();
            },
          ),
        ],
      ),
    );
  }

  void deleteInformasi(String id) async {
    await db.deleteInformasi(id);
    loadInformasi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kelola Informasi"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: showAddDialog,
          ),
        ],
      ),
      body: informasi.isEmpty
          ? const Center(
              child: Text(
                "Belum ada informasi",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: informasi.length,
              itemBuilder: (context, i) {
                final info = informasi[i];

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Judul
                        Text(
                          info['judul'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Deskripsi
                        Text(
                          info['deskripsi'],
                          style: const TextStyle(fontSize: 15),
                        ),

                        const SizedBox(height: 12),
                        const Divider(),

                        // Tombol edit & delete
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => showEditDialog(info),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  deleteInformasi(info['id'].toString()),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
