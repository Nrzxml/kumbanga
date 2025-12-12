// development_form_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kumbanga/services/database_service_api.dart';
import 'package:kumbanga/models/development_target.dart';

class DevelopmentFormPage extends StatefulWidget {
  final String childId;
  final int? ageInMonths; // optional, bisa diisi dari TargetItem
  final DevelopmentTarget?
      targetData; // optional existing target (dipakai utk edit)

  const DevelopmentFormPage({
    super.key,
    required this.childId,
    this.ageInMonths,
    this.targetData,
  });

  @override
  State<DevelopmentFormPage> createState() => _DevelopmentFormPageState();
}

class _DevelopmentFormPageState extends State<DevelopmentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ageController = TextEditingController();

  bool physicalDone = false;
  bool cognitiveDone = false;
  bool socialDone = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    // Prefill from widget.ageInMonths or widget.targetData
    final age = widget.ageInMonths ?? widget.targetData?.ageInMonths;
    if (age != null) _ageController.text = age.toString();

    if (widget.targetData != null) {
      physicalDone = widget.targetData!.physicalDone;
      cognitiveDone = widget.targetData!.cognitiveDone;
      socialDone = widget.targetData!.socialDone;
    }
  }

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final parsedAge = int.tryParse(_ageController.text.trim());
    if (parsedAge == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Umur harus berupa angka.')));
      return;
    }

    setState(() => _isSaving = true);
    final db = Provider.of<DatabaseServiceAPI>(context, listen: false);

    final success = await db.saveDevelopmentTarget(
      childId: widget.childId,
      ageInMonths: parsedAge,
      physicalDone: physicalDone,
      cognitiveDone: cognitiveDone,
      socialDone: socialDone,
    );

    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Berhasil disimpan' : 'Gagal menyimpan'),
      ),
    );

    if (success) {
      // Kembalikan true supaya parent bisa reload
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.targetData != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Perkembangan' : 'Tambah Perkembangan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Umur
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Umur (bulan)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Wajib diisi';
                  if (int.tryParse(v.trim()) == null) return 'Harus angka';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Checkboxes
              CheckboxListTile(
                title: const Text('Perkembangan Fisik Tercapai'),
                value: physicalDone,
                onChanged: (v) => setState(() => physicalDone = v ?? false),
              ),
              CheckboxListTile(
                title: const Text('Perkembangan Kognitif Tercapai'),
                value: cognitiveDone,
                onChanged: (v) => setState(() => cognitiveDone = v ?? false),
              ),
              CheckboxListTile(
                title: const Text('Perkembangan Sosial Tercapai'),
                value: socialDone,
                onChanged: (v) => setState(() => socialDone = v ?? false),
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(isEditing ? 'Perbarui' : 'Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
