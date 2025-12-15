import 'package:flutter/material.dart';
import 'package:kumbanga/services/database_service_api.dart';
import '../../models/growth_data.dart';

class GrowthDataScreen extends StatefulWidget {
  final String childId;
  final String childName;
  final bool isEdit;

  const GrowthDataScreen({
    super.key,
    required this.childId,
    required this.childName,
    this.isEdit = false,
  });

  @override
  State<GrowthDataScreen> createState() => _GrowthDataScreenState();
}

class _GrowthDataScreenState extends State<GrowthDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _headCircumferenceController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _measurementDate = DateTime.now();
  bool _isSaving = false;

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== INFO ANAK =====
              Card(
                color: Colors.green[50],
                child: ListTile(
                  leading: const Icon(Icons.child_care,
                      color: Colors.green, size: 30),
                  title: Text(
                    widget.childName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text('ID: ${widget.childId}'),
                ),
              ),
              const SizedBox(height: 20),

              // ===== TANGGAL =====
              GestureDetector(
                onTap: _selectDate,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tanggal Pengukuran',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          '${_measurementDate.day}/${_measurementDate.month}/${_measurementDate.year}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const Icon(Icons.calendar_today, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              _numberField(
                controller: _weightController,
                label: 'Berat Badan (kg)',
                icon: Icons.monitor_weight,
              ),
              const SizedBox(height: 20),

              _numberField(
                controller: _heightController,
                label: 'Tinggi Badan (cm)',
                icon: Icons.height,
              ),
              const SizedBox(height: 20),

              _numberField(
                controller: _headCircumferenceController,
                label: 'Lingkar Kepala (cm)',
                icon: Icons.circle,
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: _decoration('Catatan (opsional)'),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          widget.isEdit ? 'UPDATE DATA' : 'SIMPAN DATA',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== HELPERS =====
  InputDecoration _decoration(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      );

  Widget _numberField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: _decoration(label).copyWith(prefixIcon: Icon(icon)),
      validator: (v) {
        if (v == null || v.isEmpty) return 'Wajib diisi';
        final n = double.tryParse(v);
        if (n == null || n <= 0) return 'Nilai tidak valid';
        return null;
      },
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _measurementDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _measurementDate = picked);
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final data = GrowthData(
      date: _measurementDate,
      weight: double.parse(_weightController.text),
      height: double.parse(_heightController.text),
      headCircumference: double.parse(_headCircumferenceController.text),
      notes: _notesController.text,
    );

    final api = DatabaseServiceAPI();
    final success = await api.addGrowthData(widget.childId, data);

    setState(() => _isSaving = false);

    if (success) {
      Navigator.pop(context, data);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan data')),
      );
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
