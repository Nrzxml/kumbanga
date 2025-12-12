import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'add_donation_screen.dart';
import 'edit_donation_screen.dart';
import 'donation_detail_screen.dart';

class AdminDonationScreen extends StatefulWidget {
  const AdminDonationScreen({super.key});

  @override
  State<AdminDonationScreen> createState() => _AdminDonationScreenState();
}

class _AdminDonationScreenState extends State<AdminDonationScreen> {
  List campaigns = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCampaigns();
  }

  /// ======================================================
  /// GET DATA CAMPAIGN
  /// ======================================================
  Future fetchCampaigns() async {
    setState(() => isLoading = true);

    final response = await http.get(
      Uri.parse("http://10.0.2.2/kumbanga_api/get_campaigns.php"),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      if (json["success"] == true) {
        setState(() {
          campaigns = json["data"];
        });
      }
    }

    setState(() => isLoading = false);
  }

  /// ======================================================
  /// DELETE CAMPAIGN
  /// ======================================================
  Future deleteCampaign(String id) async {
    final response = await http.post(
      Uri.parse("http://10.0.2.2/kumbanga_api/delete_campaign.php"),
      body: {"id": id},
    );

    if (response.statusCode == 200) {
      fetchCampaigns(); // refresh data
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Campaign berhasil dihapus")),
      );
    }
  }

  /// ======================================================
  ///  BUILD UI
  /// ======================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kelola Donasi"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddDonationScreen()),
          );
          fetchCampaigns();
        },
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : campaigns.isEmpty
              ? const Center(child: Text("Belum ada campaign donasi."))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: campaigns.length,
                  itemBuilder: (context, index) {
                    final item = campaigns[index];

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: item["image"] != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  "http://10.0.2.2/kumbanga_api/uploads/${item["image"]}",
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(Icons.image),
                        title: Text(
                          item["title"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          item["description"],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DonationDetailScreen(data: item),
                            ),
                          );
                        },
                        trailing: PopupMenuButton(
                          onSelected: (value) {
                            if (value == "edit") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      EditDonationScreen(data: item),
                                ),
                              ).then((_) => fetchCampaigns());
                            } else if (value == "delete") {
                              deleteCampaign(item["id"]);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: "edit",
                              child: Row(
                                children: [
                                  Icon(Icons.edit, size: 18),
                                  SizedBox(width: 8),
                                  Text("Edit")
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: "delete",
                              child: Row(
                                children: [
                                  Icon(Icons.delete, size: 18),
                                  SizedBox(width: 8),
                                  Text("Hapus")
                                ],
                              ),
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
