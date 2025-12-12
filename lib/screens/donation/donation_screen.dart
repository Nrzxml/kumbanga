import 'package:flutter/material.dart';
import 'campaign_detail_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DonationScreen extends StatefulWidget {
  const DonationScreen({super.key});

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  List campaigns = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCampaigns();
  }

  Future<void> fetchCampaigns() async {
    final url = Uri.parse("http://10.0.2.2/kumbanga_api/get_campaigns.php");
    final res = await http.get(url);

    final data = jsonDecode(res.body);

    setState(() {
      campaigns = data["data"];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Donasi"),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: campaigns.length,
              itemBuilder: (context, index) {
                final c = campaigns[index];

                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CampaignDetailScreen(campaign: c),
                    ),
                  ),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        c["image"] != null && c["image"] != ""
                            ? Image.network(
                                "http://10.0.2.2/kumbanga_api/uploads/${c["image"]}",
                                height: 160,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                height: 160,
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(Icons.image, size: 50),
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c["title"],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                c["description"],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Terkumpul: Rp ${c["total_donation"]}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
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
