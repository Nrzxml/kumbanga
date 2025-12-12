import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserDonateScreen extends StatefulWidget {
  final Map data;

  const UserDonateScreen({super.key, required this.data});

  @override
  State<UserDonateScreen> createState() => _UserDonateScreenState();
}

class _UserDonateScreenState extends State<UserDonateScreen> {
  final nameCtrl = TextEditingController();
  final amountCtrl = TextEditingController();

  bool loading = false;

  Future submitDonation() async {
    setState(() => loading = true);

    final res = await http.post(
      Uri.parse("http://10.0.2.2/kumbanga_api/add_donation.php"),
      body: {
        "campaign_id": widget.data["id"].toString(),
        "donor_name": nameCtrl.text,
        "amount": amountCtrl.text,
      },
    );

    setState(() => loading = false);

    if (res.statusCode == 200) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Donasi berhasil!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Form Donasi"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: "Nama Anda",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Nominal Donasi",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : submitDonation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  loading ? "Memproses..." : "Kirim Donasi",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
