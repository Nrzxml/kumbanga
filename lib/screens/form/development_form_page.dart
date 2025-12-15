import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kumbanga/services/database_service_api.dart';
import 'package:kumbanga/models/development_target.dart';
import 'package:kumbanga/screens/form/development_points.dart';

class DevelopmentFormPage extends StatefulWidget {
  final String childId;
  final int ageInMonths;
  final DevelopmentTarget? targetData;

  const DevelopmentFormPage({
    super.key,
    required this.childId,
    required this.ageInMonths,
    this.targetData,
  });

  @override
  State<DevelopmentFormPage> createState() => _DevelopmentFormPageState();
}

class _DevelopmentFormPageState extends State<DevelopmentFormPage> {
  bool _isSaving = false;

  final Map<String, bool> physicalValues = {};
  final Map<String, bool> cognitiveValues = {};
  final Map<String, bool> socialValues = {};

  @override
  void initState() {
    super.initState();
    _initCheckbox();
  }

  void _initCheckbox() {
    for (final p in physicalPoints[widget.ageInMonths] ?? []) {
      physicalValues[p.key] = false;
    }
    for (final p in cognitivePoints[widget.ageInMonths] ?? []) {
      cognitiveValues[p.key] = false;
    }
    for (final p in socialPoints[widget.ageInMonths] ?? []) {
      socialValues[p.key] = false;
    }
  }

  bool _passed(Map<String, bool> values) {
    return values.values.where((v) => v).length >= 2;
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);

    final db = Provider.of<DatabaseServiceAPI>(context, listen: false);

    final success = await db.saveDevelopmentTarget(
      childId: widget.childId,
      ageInMonths: widget.ageInMonths,
      physicalDone: _passed(physicalValues),
      cognitiveDone: _passed(cognitiveValues),
      socialDone: _passed(socialValues),
    );

    setState(() => _isSaving = false);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data berhasil disimpan')),
    );

    Navigator.pop(context);
  }

  Widget _statusCardFromDB() {
    if (widget.targetData == null) return const SizedBox();

    final normal = widget.targetData!.physicalDone &&
        widget.targetData!.cognitiveDone &&
        widget.targetData!.socialDone;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: normal ? Colors.green[100] : Colors.orange[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            normal ? Icons.check_circle : Icons.warning_amber_rounded,
            color: normal ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 12),
          Text(
            normal ? 'Perkembangan Normal' : 'Perlu Pengecekan Lanjutan',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _section(
    String title,
    List<DevelopmentPoint> points,
    Map<String, bool> values,
  ) {
    if (points.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ...points.map(
          (p) => CheckboxListTile(
            value: values[p.key],
            title: Text(p.label),
            contentPadding: EdgeInsets.zero,
            onChanged: (v) => setState(() {
              values[p.key] = v ?? false;
            }),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final age = widget.ageInMonths;

    return Scaffold(
      appBar: AppBar(title: const Text('Perkembangan Anak')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              enabled: false,
              initialValue: age.toString(),
              decoration: const InputDecoration(
                labelText: 'Umur (bulan)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            /// STATUS DARI DATABASE
            _statusCardFromDB(),
            const SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _section(
                      'Pertumbuhan Fisik',
                      physicalPoints[age] ?? [],
                      physicalValues,
                    ),
                    const SizedBox(height: 16),
                    _section(
                      'Motorik & Kognitif',
                      cognitivePoints[age] ?? [],
                      cognitiveValues,
                    ),
                    const SizedBox(height: 16),
                    _section(
                      'Gizi & Pola Asuh',
                      socialPoints[age] ?? [],
                      socialValues,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const CircularProgressIndicator()
                    : const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
