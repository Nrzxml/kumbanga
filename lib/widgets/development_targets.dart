import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../screens/form/development_form_page.dart';
import '../../models/development_target.dart';
import '../../services/database_service_api.dart';

class DevelopmentTargetsWidget extends StatefulWidget {
  final String childId;

  const DevelopmentTargetsWidget({super.key, required this.childId});

  @override
  State<DevelopmentTargetsWidget> createState() =>
      _DevelopmentTargetsWidgetState();
}

class _DevelopmentTargetsWidgetState extends State<DevelopmentTargetsWidget> {
  late Future<List<DevelopmentTarget>> _targetsFuture;

  @override
  void initState() {
    super.initState();
    _targetsFuture = _loadTargets();
  }

  @override
  void didUpdateWidget(covariant DevelopmentTargetsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // jika childId berubah -> reload
    if (oldWidget.childId != widget.childId) {
      _targetsFuture = _loadTargets();
      setState(() {});
    }
  }

  Future<List<DevelopmentTarget>> _loadTargets() async {
    final db = Provider.of<DatabaseServiceAPI>(context, listen: false);
    final list = await db.getDevelopmentTargets(widget.childId);

    final Map<int, DevelopmentTarget> byAge = {
      for (final t in list) t.ageInMonths: t
    };

    final desired = [6, 9, 12, 18];
    final res = desired.map((age) {
      if (byAge.containsKey(age)) return byAge[age]!;
      // create default placeholder target text for each age
      return DevelopmentTarget(
        ageInMonths: age,
        physicalTarget: 'Target fisik usia $age bulan',
        cognitiveTarget: 'Target kognitif usia $age bulan',
        socialTarget: 'Target sosial usia $age bulan',
        physicalDone: false,
        cognitiveDone: false,
        socialDone: false,
      );
    }).toList();

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<DevelopmentTarget>>(
          future: _targetsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final targets = snapshot.data ?? [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Target Perkembangan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pantau pencapaian perkembangan anak sesuai usia',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                if (targets.isEmpty)
                  const Text('Belum ada data. Tekan + untuk tambah.')
                else
                  ...targets.map((t) => _buildTile(t)).toList(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTile(DevelopmentTarget t) {
    final allChecked = t.isCompleted;

    return InkWell(
      onTap: () async {
        // buka form (kirim data eksisting supaya form di-mode edit)
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DevelopmentFormPage(
              childId: widget.childId,
              ageInMonths: t.ageInMonths,
              targetData: t,
            ),
          ),
        );

        // jika berhasil simpan, reload list
        if (result == true) {
          setState(() {
            _targetsFuture = _loadTargets();
          });
        }
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        color: allChecked ? Colors.green[50] : null,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Usia ${t.ageInMonths} bulan',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: allChecked ? Colors.green[100] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  allChecked ? 'Perkembangan normal' : 'Perlu pengecekan',
                  style: TextStyle(
                    color: allChecked ? Colors.green[800] : Colors.grey[800],
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
