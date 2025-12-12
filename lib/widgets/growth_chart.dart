import 'package:flutter/material.dart';

class GrowthChart extends StatefulWidget {
  final Map<String, List<double>>? chartData; // data dari API (optional)
  const GrowthChart({super.key, this.chartData});

  @override
  _GrowthChartState createState() => _GrowthChartState();
}

class _GrowthChartState extends State<GrowthChart> {
  int _selectedChart = 0; // 0: Weight, 1: Height, 2: Head Circumference

  late Map<String, List<double>> _chartData;

  final Map<String, String> _chartUnits = {
    'Berat Badan': 'kg',
    'Tinggi Badan': 'cm',
    'Lingkar Kepala': 'cm',
  };

  @override
  void initState() {
    super.initState();

    // Kalau widget.chartData tidak ada atau kosong → default semua 0
    _chartData = widget.chartData ??
        {
          'Berat Badan': [0.0],
          'Tinggi Badan': [0.0],
          'Lingkar Kepala': [0.0],
        };
  }

  @override
  Widget build(BuildContext context) {
    final chartTitles = _chartData.keys.toList();
    final currentTitle = chartTitles[_selectedChart];
    final currentData = _chartData[currentTitle] ?? [0.0];
    final currentUnit = _chartUnits[currentTitle]!;

    // Cek apakah semua data masih 0
    final bool allZero = currentData.every((v) => v == 0.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Grafik Pertumbuhan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<int>(
                  value: _selectedChart,
                  items: List.generate(chartTitles.length, (index) {
                    return DropdownMenuItem(
                      value: index,
                      child: Text(chartTitles[index]),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      _selectedChart = value!;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Grafik atau pesan kosong
            Container(
              height: 200,
              padding: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              child: allZero
                  ? const Text(
                      'Belum ada data pertumbuhan',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    )
                  : _buildBarChart(currentData, currentUnit),
            ),

            const SizedBox(height: 16),

            // Legend cuma muncul kalau datanya ada
            if (!allZero)
              _buildChartLegend(currentData.last, currentUnit, currentTitle),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(List<double> data, String unit) {
    final maxValue =
        (data.reduce((a, b) => a > b ? a : b)).clamp(1, double.infinity);

    return Column(
      children: [
        // Y-axis + Bars
        Row(
          children: [
            SizedBox(
              width: 40,
              child: Text(
                maxValue.toStringAsFixed(1),
                style: const TextStyle(fontSize: 10),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 120,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: data.asMap().entries.map((entry) {
                    final index = entry.key;
                    final value = entry.value;
                    final height = (value / maxValue) * 100;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          value.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 10),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 20,
                          height: height,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'B$index',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        // X-axis label
        const Padding(
          padding: EdgeInsets.only(left: 40, top: 8),
          child: Text(
            'Bulan',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildChartLegend(double lastValue, String unit, String title) {
    final dataList = _chartData[title] ?? [0.0];
    final previousValue =
        dataList.length > 1 ? dataList[dataList.length - 2] : lastValue;
    final difference = lastValue - previousValue;
    final isPositive = difference >= 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '${lastValue.toStringAsFixed(1)} $unit',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isPositive ? Colors.green[50] : Colors.orange[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isPositive ? Colors.green : Colors.orange,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                size: 16,
                color: isPositive ? Colors.green : Colors.orange,
              ),
              const SizedBox(width: 4),
              Text(
                '${difference.toStringAsFixed(1)} $unit',
                style: TextStyle(
                  color: isPositive ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
