import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/database_service_api.dart';
import '../../models/development_target.dart';
import '../../screens/form/development_form_page.dart';

class DevelopmentTargetsWidget extends StatelessWidget {
  final String childId;

  const DevelopmentTargetsWidget({
    super.key,
    required this.childId,
  });

  // 🔑 USIA WAJIB MUNCUL WALAU BELUM ADA DATA
  static const List<int> defaultAges = [6, 9, 12, 18];

  int _passedCount(DevelopmentTarget t) {
    return [
      t.physicalDone,
      t.cognitiveDone,
      t.socialDone,
    ].where((e) => e).length;
  }

  Color _bgColor(int passed) {
    if (passed == 3) return Colors.green.shade100;
    if (passed > 0) return Colors.orange.shade100;
    return Colors.white;
  }

  Color _textColor(int passed) {
    if (passed == 3) return Colors.green;
    if (passed > 0) return Colors.orange;
    return Colors.grey;
  }

  String _statusText(int passed) {
    if (passed == 3) return 'Perkembangan normal';
    if (passed > 0) return 'Perlu pengecekan';
    return 'Belum diisi';
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<DatabaseServiceAPI>(context, listen: false);

    return FutureBuilder<List<DevelopmentTarget>>(
      future: db.getDevelopmentTargets(childId),
      builder: (context, snapshot) {
        final apiTargets = snapshot.data ?? [];

        // 🔑 MAP: age -> DevelopmentTarget
        final Map<int, DevelopmentTarget> targetMap = {
          for (var t in apiTargets) t.ageInMonths: t
        };

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Target Perkembangan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Pantau pencapaian perkembangan anak sesuai usia',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 12),

                // 🔥 LOOP USIA DEFAULT
                ...defaultAges.map((age) {
                  final t = targetMap[age];

                  final passed = t == null ? 0 : _passedCount(t);
                  final bg = _bgColor(passed);
                  final color = _textColor(passed);

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DevelopmentFormPage(
                            childId: childId,
                            ageInMonths: age,
                            targetData: t, // bisa null → mode input baru
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: color.withOpacity(0.4)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Usia $age bulan',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _statusText(passed),
                              style: TextStyle(
                                color: color,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
