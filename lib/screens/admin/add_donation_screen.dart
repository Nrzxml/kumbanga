import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddDonationScreen extends StatefulWidget {
  const AddDonationScreen({super.key});

  @override
  State<AddDonationScreen> createState() => _AddDonationScreenState();
}

class _AddDonationScreenState extends State<AddDonationScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  File? selectedImage; // File foto yang dipilih

  final ImagePicker _picker = ImagePicker();

  /// =============================
  ///  PICK IMAGE DARI GALERI
  /// =============================
  Future pickImage() async {
    final XFile? img = await _picker.pickImage(source: ImageSource.gallery);

    if (img != null) {
      setState(() {
        selectedImage = File(img.path);
      });
    }
  }

  /// =============================
  ///  KIRIM DATA KE SERVER
  /// =============================
  Future<void> submitCampaign() async {
    if (titleController.text.isEmpty || descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Judul & Deskripsi wajib diisi")),
      );
      return;
    }

    if (selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Foto campaign wajib diupload!")),
      );
      return;
    }

    // Tampilkan loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Colors.green),
      ),
    );

    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("http://10.0.2.2/kumbanga_api/add_campaign.php"),
      );

      request.fields["title"] = titleController.text;
      request.fields["description"] = descController.text;

      // Upload gambar
      request.files.add(
        await http.MultipartFile.fromPath("image", selectedImage!.path),
      );

      var response = await request.send();
      var body = await response.stream.bytesToString();

      Navigator.pop(context); // tutup loading

      if (response.statusCode == 200 && body.contains('"success":true')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Campaign berhasil disimpan!")),
        );
        Navigator.pop(context); // kembali ke halaman sebelumnya
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menyimpan: $body")),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  /// =============================
  ///  BUILD UI
  /// =============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Buat Campaign Donasi",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // INPUT JUDUL
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Judul Campaign",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // INPUT DESKRIPSI
            TextField(
              controller: descController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Deskripsi",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // PREVIEW GAMBAR
            if (selectedImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  selectedImage!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 16),

            // BUTTON UPLOAD GAMBAR
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: pickImage,
              icon: const Icon(Icons.photo),
              label: const Text("Upload Foto"),
            ),

            const SizedBox(height: 16),

            // BUTTON SIMPAN
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: submitCampaign,
              child: const Text(
                "Simpan Campaign",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
