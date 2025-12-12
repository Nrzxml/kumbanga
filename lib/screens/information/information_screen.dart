import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});

  @override
  _InformationScreenState createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  List<dynamic> _informasi = [];
  bool _isLoading = true;

  Future<void> fetchInformasi() async {
    try {
      final res = await http.get(Uri.parse(
        "http://10.0.2.2/kumbanga_api/get_informasi.php",
      ));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        setState(() {
          _informasi = data["data"];
          _isLoading = false;
        });
      } else {
        throw Exception("Gagal mengambil data");
      }
    } catch (e) {
      print("ERROR: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchInformasi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _informasi.isEmpty
              ? const Center(
                  child: Text(
                    "Belum ada informasi",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _informasi.length,
                  itemBuilder: (context, index) {
                    final item = _informasi[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['judul'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item['deskripsi'],
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
