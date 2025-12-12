import 'package:flutter/material.dart';
import 'package:kumbanga/services/database_service_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/growth_data.dart';

class GrowthDataScreen extends StatefulWidget {
  final bool isEdit;

  const GrowthDataScreen({super.key, this.isEdit = false});

  @override
  _GrowthDataScreenState createState() => _GrowthDataScreenState();
}

class _GrowthDataScreenState extends State<GrowthDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _headCircumferenceController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _measurementDate = DateTime.now();

  String? _selectedChildName;
  String? _selectedChildId;

  @override
  void initState() {
    super.initState();
    _loadSelectedChild();
  }

  /// 🔹 Ambil data anak aktif dari SharedPreferences
  Future<void> _loadSelectedChild() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedChildName = prefs.getString('selectedChildName');
      _selectedChildId = prefs.getString('selectedChildId');
    });

    debugPrint('🧒 Anak aktif: $_selectedChildName ($_selectedChildId)');
  }

  /// 🔹 Pilih tanggal pengukuran
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _measurementDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _measurementDate) {
      setState(() {
        _measurementDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit
            ? 'Edit Data Tumbuh Kembang'
            : 'Isi Data Tumbuh Kembang'),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: _selectedChildId == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.warning, color: Colors.orange, size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada anak yang dipilih.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Silakan pilih anak terlebih dahulu.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                    ),
                    child: const Text('Kembali'),
                  )
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Tampilkan anak aktif
                    Card(
                      color: Colors.green[50],
                      child: ListTile(
                        leading: const Icon(Icons.child_care,
                            color: Colors.green, size: 30),
                        title: Text(
                          _selectedChildName ?? 'Anak tidak dikenal',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text('ID: $_selectedChildId'),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Tanggal Pengukuran
                    GestureDetector(
                      onTap: _selectDate,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Tanggal Pengukuran',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${_measurementDate.day}/${_measurementDate.month}/${_measurementDate.year}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const Icon(Icons.calendar_today,
                                  color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Berat Badan
                    TextFormField(
                      controller: _weightController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Berat Badan (kg)',
                        prefixIcon: const Icon(Icons.monitor_weight),
                        suffixText: 'kg',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Berat badan harus diisi';
                        }
                        final weight = double.tryParse(value);
                        if (weight == null || weight <= 0) {
                          return 'Berat badan tidak valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Tinggi Badan
                    TextFormField(
                      controller: _heightController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Tinggi Badan (cm)',
                        prefixIcon: const Icon(Icons.height),
                        suffixText: 'cm',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tinggi badan harus diisi';
                        }
                        final height = double.tryParse(value);
                        if (height == null || height <= 0) {
                          return 'Tinggi badan tidak valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Lingkar Kepala
                    TextFormField(
                      controller: _headCircumferenceController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Lingkar Kepala (cm)',
                        prefixIcon: const Icon(Icons.circle),
                        suffixText: 'cm',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lingkar kepala harus diisi';
                        }
                        final circumference = double.tryParse(value);
                        if (circumference == null || circumference <= 0) {
                          return 'Lingkar kepala tidak valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Catatan
                    TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Catatan (opsional)',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Tombol Simpan
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _saveData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          widget.isEdit ? 'UPDATE DATA' : 'SIMPAN DATA',
                          style: const TextStyle(
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
    );
  }

  /// 🔹 Simpan data ke server
  void _saveData() async {
    if (_formKey.currentState!.validate()) {
      final growthData = GrowthData(
        date: _measurementDate,
        weight: double.parse(_weightController.text),
        height: double.parse(_heightController.text),
        headCircumference: double.parse(_headCircumferenceController.text),
        notes: _notesController.text.isNotEmpty ? _notesController.text : '',
      );

      if (_selectedChildId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menyimpan: anak belum dipilih'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      try {
        final api = DatabaseServiceAPI();
        final success = await api.addGrowthData(_selectedChildId!, growthData);

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.isEdit
                  ? 'Data berhasil diupdate ke server'
                  : 'Data berhasil disimpan ke server'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, growthData);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal menyimpan data ke server'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _headCircumferenceController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
