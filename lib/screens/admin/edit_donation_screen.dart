import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EditDonationScreen extends StatefulWidget {
  final Map data;

  const EditDonationScreen({super.key, required this.data});

  @override
  State<EditDonationScreen> createState() => _EditDonationScreenState();
}

class _EditDonationScreenState extends State<EditDonationScreen> {
  late TextEditingController titleC;
  late TextEditingController descC;

  File? newImage;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    titleC = TextEditingController(text: widget.data["title"]);
    descC = TextEditingController(text: widget.data["description"]);
  }

  Future pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() => newImage = File(picked.path));
    }
  }

  Future updateCampaign() async {
    setState(() => loading = true);

    var url = Uri.parse("http://10.0.2.2/kumbanga_api/update_campaign.php");

    var request = http.MultipartRequest("POST", url);

    request.fields["id"] = widget.data["id"];
    request.fields["title"] = titleC.text;
    request.fields["description"] = descC.text;

    // Kalau user pilih gambar baru
    if (newImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath("image", newImage!.path),
      );
    }

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    setState(() => loading = false);

    var result = json.decode(responseBody);

    if (result["status"] == true) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Campaign berhasil diperbarui")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result["message"] ?? "Gagal update")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Campaign"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: titleC,
              decoration: const InputDecoration(labelText: "Judul"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descC,
              minLines: 3,
              maxLines: 6,
              decoration: const InputDecoration(labelText: "Deskripsi"),
            ),
            const SizedBox(height: 16),

            // Preview gambar lama ATAU baru
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: newImage != null
                    ? Image.file(newImage!, height: 180)
                    : (widget.data["image"] != null
                        ? Image.network(
                            "http://10.0.2.2/kumbanga_api/uploads/${widget.data["image"]}",
                            height: 180,
                            fit: BoxFit.cover,
                          )
                        : Container(height: 150)),
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.photo),
              label: const Text("Ganti Foto"),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: loading ? null : updateCampaign,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Update"),
            )
          ],
        ),
      ),
    );
  }
}
