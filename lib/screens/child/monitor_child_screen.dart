import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/child.dart';
import '../../models/growth_data.dart';
import '../../services/database_service_api.dart';
import 'register_child_screen.dart';
import 'growth_data_screen.dart';
import '../../widgets/growth_chart.dart';
import '../../widgets/development_targets.dart';

class MonitorChildScreen extends StatefulWidget {
  const MonitorChildScreen({super.key});

  @override
  State<MonitorChildScreen> createState() => _MonitorChildScreenState();
}

class _MonitorChildScreenState extends State<MonitorChildScreen> {
  bool isLoading = true;
  bool isGrowthLoading = false;
  List<Child> children = [];
  Child? selectedChild;
  List<GrowthData> growthDataList = [];

  @override
  void initState() {
    super.initState();
    _loadChildren();
  }

  Future<void> _loadChildren() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) {
      setState(() => isLoading = false);
      return;
    }

    try {
      final api = DatabaseServiceAPI();
      final result = await api.getChildrenByUser(userId);

      setState(() {
        children = result;
        isLoading = false;
        if (children.isNotEmpty) selectedChild = children.first;
      });

      if (selectedChild != null) await _loadGrowthData(selectedChild!.id);
    } catch (e) {
      debugPrint('Error load children: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadGrowthData(String childId) async {
    setState(() => isGrowthLoading = true);
    try {
      final api = DatabaseServiceAPI();
      final data = await api.getGrowthDataByChild(childId);

      setState(() {
        growthDataList = data;
        isGrowthLoading = false;
      });
    } catch (e) {
      debugPrint('Error load growth data: $e');
      setState(() => isGrowthLoading = false);
    }
  }

  Map<String, List<double>> _convertGrowthData(List<GrowthData> list) {
    if (list.isEmpty) {
      return {
        'Berat Badan': [0.0],
        'Tinggi Badan': [0.0],
        'Lingkar Kepala': [0.0],
      };
    }
    return {
      'Berat Badan': list.map((e) => e.weight.toDouble()).toList(),
      'Tinggi Badan': list.map((e) => e.height.toDouble()).toList(),
      'Lingkar Kepala':
          list.map((e) => e.headCircumference.toDouble()).toList(),
    };
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      body: children.isEmpty
          ? _buildEmptyState(context)
          : _buildMonitorContent(context),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.child_care, size: 90, color: Colors.grey),
            const SizedBox(height: 20),
            const Text('Belum ada data anak',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Silakan tambahkan data anak terlebih dahulu.',
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Daftarkan Anak'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegisterChildScreen()),
                );
                _loadChildren();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonitorContent(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          if (selectedChild != null) await _loadGrowthData(selectedChild!.id);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildChildSelector(),
              const SizedBox(height: 20),
              _buildActionButtons(context),
              const SizedBox(height: 20),
              if (isGrowthLoading)
                const Center(child: CircularProgressIndicator())
              else
                GrowthChart(chartData: _convertGrowthData(growthDataList)),
              const SizedBox(height: 20),
              DevelopmentTargetsWidget(
                key: ValueKey(selectedChild!.id),
                childId: selectedChild!.id,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChildSelector() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.child_care, size: 30),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButton<Child>(
                isExpanded: true,
                value: selectedChild,
                underline: const SizedBox(),
                items: children
                    .map(
                      (child) => DropdownMenuItem(
                        value: child,
                        child: Text(child.name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ),
                    )
                    .toList(),
                onChanged: (value) async {
                  if (value == null) return;
                  setState(() => selectedChild = value);

                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('selectedChildId', value.id);
                  await prefs.setString('selectedChildName', value.name);

                  await _loadGrowthData(value.id);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Isi Data'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () async {
              if (selectedChild == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pilih anak terlebih dahulu!')),
                );
                return;
              }

              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const GrowthDataScreen()),
              );

              if (result != null) {
                await _loadGrowthData(selectedChild!.id);
              }
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.edit),
            label: const Text('Edit Data'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: Colors.green.shade700, width: 1.5),
            ),
            onPressed: growthDataList.isEmpty
                ? null
                : () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const GrowthDataScreen(isEdit: true)),
                    );
                    if (result != null) {
                      await _loadGrowthData(selectedChild!.id);
                    }
                  },
          ),
        ),
      ],
    );
  }
}
