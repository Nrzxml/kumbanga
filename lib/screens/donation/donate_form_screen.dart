import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DonateFormScreen extends StatefulWidget {
  final int campaignId;
  const DonateFormScreen({super.key, required this.campaignId});

  @override
  State<DonateFormScreen> createState() => _DonateFormScreenState();
}

class _DonateFormScreenState extends State<DonateFormScreen> {
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  bool loading = false;

  Future<void> sendDonation() async {
    setState(() => loading = true);

    final url = Uri.parse("http://10.0.2.2/kumbanga_api/add_donation.php");

    await http.post(url, body: {
      "campaign_id": widget.campaignId.toString(),
      "donor_name": nameController.text,
      "amount": amountController.text,
    });

    setState(() => loading = false);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Terima kasih!"),
        content: const Text("Donasi Anda telah berhasil dikirim."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    ).then((_) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Form Donasi"),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nama Donatur"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: "Nominal Donasi"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: loading ? null : sendDonation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Kirim Donasi",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
