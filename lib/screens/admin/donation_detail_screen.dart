import 'package:flutter/material.dart';

class DonationDetailScreen extends StatelessWidget {
  final Map data;

  const DonationDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    String? image = data["image"];

    return Scaffold(
      appBar: AppBar(
        title: Text(data["title"]),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (image != null && image.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  "http://10.0.2.2/kumbanga_api/uploads/$image",
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text("Tidak ada gambar"),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              data["title"] ?? "",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              data["description"] ?? "",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
