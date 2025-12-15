import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/database_service_api.dart';
import '../../models/development_target.dart';
import 'development_form_page.dart';

class DevelopmentTargetsListPage extends StatefulWidget {
  final String childId;

  const DevelopmentTargetsListPage({
    super.key,
    required this.childId,
  });

  @override
  State<DevelopmentTargetsListPage> createState() =>
      _DevelopmentTargetsListPageState();
}

class _DevelopmentTargetsListPageState
    extends State<DevelopmentTargetsListPage> {
  late Future<List<DevelopmentTarget>> targetsFuture;

  @override
  void initState() {
    super.initState();
    targetsFuture = _loadTargets();
  }

  Future<List<DevelopmentTarget>> _loadTargets() async {
    final db = Provider.of<DatabaseServiceAPI>(context, listen: false);
    return db.getDevelopmentTargets(widget.childId);
  }

  // ================= STATUS HELPERS =================

  bool _isAllDone(DevelopmentTarget t) {
    return t.physicalDone && t.cognitiveDone && t.socialDone;
  }

  bool _isPartiallyDone(DevelopmentTarget t) {
    return !_isAllDone(t) &&
        (t.physicalDone || t.cognitiveDone || t.socialDone);
  }

  Color _cardColor(DevelopmentTarget t) {
    if (_isAllDone(t)) return Colors.green.shade50;
    if (_isPartiallyDone(t)) return Colors.yellow.shade50;
    return Colors.white;
  }

  String _statusText(DevelopmentTarget t) {
    if (_isAllDone(t)) return 'Perkembangan normal';
    if (_isPartiallyDone(t)) return 'Perlu pengecekan';
    return 'Belum diisi';
  }

  Color _statusColor(DevelopmentTarget t) {
    if (_isAllDone(t)) return Colors.green;
    if (_isPartiallyDone(t)) return Colors.orange;
    return Colors.grey;
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perkembangan Anak'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTarget,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<DevelopmentTarget>>(
        future: targetsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Belum ada data perkembangan'),
            );
          }

          final targets = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: targets.length,
            itemBuilder: (_, index) {
              final t = targets[index];

              return Card(
                color: _cardColor(t),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(
                    'Usia ${t.ageInMonths} bulan',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    _statusText(t),
                    style: TextStyle(
                      color: _statusColor(t),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DevelopmentFormPage(
                          childId: widget.childId,
                          ageInMonths: t.ageInMonths,
                          targetData: t,
                        ),
                      ),
                    );

                    setState(() {
                      targetsFuture = _loadTargets();
                    });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ================= ADD TARGET =================

  Future<void> _addNewTarget() async {
    final ageController = TextEditingController();

    final age = await showDialog<int>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Tambah Perkembangan'),
        content: TextField(
          controller: ageController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Umur (bulan)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final parsed = int.tryParse(ageController.text.trim());
              if (parsed != null) {
                Navigator.pop(context, parsed);
              }
            },
            child: const Text('Lanjut'),
          ),
        ],
      ),
    );

    if (age == null) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DevelopmentFormPage(
          childId: widget.childId,
          ageInMonths: age,
        ),
      ),
    );

    setState(() {
      targetsFuture = _loadTargets();
    });
  }
}
