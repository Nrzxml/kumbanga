import 'package:flutter/material.dart';

class NutritionAidScreen extends StatefulWidget {
  const NutritionAidScreen({super.key});

  @override
  _NutritionAidScreenState createState() => _NutritionAidScreenState();
}

class _NutritionAidScreenState extends State<NutritionAidScreen> {
  final List<NutritionPackage> _packages = [
    NutritionPackage(
      id: '1',
      name: 'Paket Dasar',
      description: 'Susu formula, bubur bayi, vitamin A',
      price: 0,
      duration: '1 bulan',
      items: ['Susu Formula 400g', 'Bubur Bayi 5 pcs', 'Vitamin A'],
    ),
    NutritionPackage(
      id: '2',
      name: 'Paket Lengkap',
      description: 'Makanan pendamping ASI lengkap',
      price: 0,
      duration: '2 bulan',
      items: [
        'Susu Formula 800g',
        'Bubur Bayi 10 pcs',
        'Biskuit Bayi',
        'Vitamin A+D',
        'MPASI Instan'
      ],
    ),
    NutritionPackage(
      id: '3',
      name: 'Paket Spesial',
      description: 'Untuk bayi dengan kebutuhan khusus',
      price: 0,
      duration: '3 bulan',
      items: [
        'Susu Formula Khusus',
        'MPASI Organik',
        'Vitamin Lengkap',
        'Probiotik',
        'Konsultasi Gizi'
      ],
    ),
  ];

  int _selectedPackage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bantuan Paket Gizi'),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.green[800]),
                        const SizedBox(width: 8),
                        const Text(
                          'Informasi Bantuan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Bantuan paket gizi diberikan untuk keluarga yang membutuhkan dalam upaya pencegahan stunting. Pengajuan akan diverifikasi terlebih dahulu.',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Package Selection
            const Text(
              'Pilih Paket Bantuan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _packages.length,
              itemBuilder: (context, index) {
                final package = _packages[index];
                return PackageCard(
                  package: package,
                  isSelected: _selectedPackage == index,
                  onTap: () {
                    setState(() {
                      _selectedPackage = index;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 24),

            // Application Form
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Form Pengajuan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Alasan Pengajuan',
                        hintText: 'Jelaskan mengapa membutuhkan bantuan ini',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Alamat Lengkap',
                        hintText: 'Masukkan alamat pengiriman',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Nomor Telepon yang Dapat Dihubungi',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submitApplication,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'AJUKAN BANTUAN',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitApplication() {
    final selectedPackage = _packages[_selectedPackage];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pengajuan Berhasil'),
        content: Text(
          'Pengajuan bantuan paket "${selectedPackage.name}" telah diterima. Tim kami akan menghubungi Anda dalam 1-2 hari kerja untuk verifikasi.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class NutritionPackage {
  final String id;
  final String name;
  final String description;
  final int price;
  final String duration;
  final List<String> items;

  NutritionPackage({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.items,
  });
}

class PackageCard extends StatelessWidget {
  final NutritionPackage package;
  final bool isSelected;
  final VoidCallback onTap;

  const PackageCard({
    super.key,
    required this.package,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? Colors.green[50] : null,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isSelected ? Colors.green : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    package.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'GRATIS',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(package.description),
              const SizedBox(height: 12),
              Text(
                'Durasi: ${package.duration}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Isi Paket:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: package.items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, size: 16, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(item),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}