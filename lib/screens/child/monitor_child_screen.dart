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

  // ================= LOAD CHILD =================
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

      if (!mounted) return;

      setState(() {
        children = result;
        isLoading = false;

        if (children.isNotEmpty && selectedChild == null) {
          selectedChild = children.first;
        }
      });

      if (selectedChild != null) {
        await _loadGrowthData(selectedChild!.id);
      }
    } catch (e) {
      debugPrint('Error load children: $e');
      if (mounted) setState(() => isLoading = false);
    }
  }

  // ================= LOAD GROWTH DATA =================
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

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantau Anak'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xfff6f6f6),
      body: children.isEmpty
          ? _buildEmptyState(context)
          : _buildMonitorContent(context),
    );
  }

  // ================= EMPTY STATE =================
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.child_care, size: 90, color: Colors.grey),
            const SizedBox(height: 20),
            const Text(
              'Belum ada data anak',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Silakan tambahkan data anak terlebih dahulu.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Daftarkan Anak'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegisterChildScreen(),
                  ),
                );
                _loadChildren();
              },
            ),
          ],
        ),
      ),
    );
  }

  // ================= MAIN CONTENT =================
  Widget _buildMonitorContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildChildSelector(),
          const SizedBox(height: 20),
          _buildActionButtons(context),
          const SizedBox(height: 20),
          if (isGrowthLoading)
            const CircularProgressIndicator()
          else
            GrowthChart(
              chartData: {
                'Berat Badan': growthDataList.map((e) => e.weight).toList(),
                'Tinggi Badan': growthDataList.map((e) => e.height).toList(),
                'Lingkar Kepala':
                    growthDataList.map((e) => e.headCircumference).toList(),
              },
            ),
          const SizedBox(height: 20),
          if (selectedChild != null)
            DevelopmentTargetsWidget(
              childId: selectedChild!.id,
            ),
        ],
      ),
    );
  }

  // ================= CHILD SELECTOR =================
  Widget _buildChildSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: DropdownButton<Child>(
          value: selectedChild,
          isExpanded: true,
          underline: const SizedBox(),
          items: children
              .map(
                (child) => DropdownMenuItem(
                  value: child,
                  child: Text(child.name),
                ),
              )
              .toList(),
          onChanged: (value) async {
            if (value == null) return;
            setState(() => selectedChild = value);
            await _loadGrowthData(value.id);
          },
        ),
      ),
    );
  }

  // ================= ACTION BUTTONS =================
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Isi Data'),
            onPressed: selectedChild == null
                ? null
                : () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GrowthDataScreen(
                          childId: selectedChild!.id,
                          childName: selectedChild!.name,
                        ),
                      ),
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
            onPressed: selectedChild == null || growthDataList.isEmpty
                ? null
                : () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GrowthDataScreen(
                          childId: selectedChild!.id,
                          childName: selectedChild!.name,
                          isEdit: true,
                        ),
                      ),
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
