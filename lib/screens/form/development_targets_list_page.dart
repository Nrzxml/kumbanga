import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/database_service_api.dart';
import '../../models/development_target.dart';
import 'development_form_page.dart';

class DevelopmentTargetsListPage extends StatefulWidget {
  final String childId;

  const DevelopmentTargetsListPage({super.key, required this.childId});

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
    return await db.getDevelopmentTargets(widget.childId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perkembangan Anak"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DevelopmentFormPage(childId: widget.childId),
            ),
          );
          setState(() {
            targetsFuture = _loadTargets();
          });
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<DevelopmentTarget>>(
        future: targetsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final targets = snapshot.data!;
          if (targets.isEmpty) {
            return const Center(
              child: Text("Belum ada data perkembangan."),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: targets.length,
            itemBuilder: (_, index) {
              final t = targets[index];

              final allDone = t.physicalDone && t.cognitiveDone && t.socialDone;

              return Card(
                color: allDone ? Colors.green[50] : Colors.white,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DevelopmentFormPage(
                          childId: widget.childId,
                          targetData: t,
                          ageInMonths: t.ageInMonths,
                          // <-- kirim data lama
                        ),
                      ),
                    );

                    setState(() {
                      targetsFuture = _loadTargets();
                    });
                  },
                  title: Text("Usia ${t.ageInMonths} bulan"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatus("Fisik", t.physicalDone),
                      _buildStatus("Kognitif", t.cognitiveDone),
                      _buildStatus("Sosial", t.socialDone),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatus(String label, bool done) {
    return Row(
      children: [
        Icon(
          done ? Icons.check_circle : Icons.radio_button_unchecked,
          color: done ? Colors.green : Colors.grey,
          size: 18,
        ),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}
