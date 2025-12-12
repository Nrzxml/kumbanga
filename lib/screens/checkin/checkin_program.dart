import 'package:flutter/material.dart';

class CheckinProgram extends StatefulWidget {
  const CheckinProgram({super.key});

  @override
  _CheckinProgramState createState() => _CheckinProgramState();
}

class _CheckinProgramState extends State<CheckinProgram> {
  int _currentStreak = 5;
  int _totalCheckins = 23;
  DateTime _lastCheckin = DateTime.now().subtract(const Duration(hours: 12));
  bool _canCheckin = true;

  final List<CheckinReward> _rewards = [
    CheckinReward(day: 1, reward: '10 Poin', isClaimed: true),
    CheckinReward(day: 3, reward: '30 Poin', isClaimed: true),
    CheckinReward(day: 7, reward: '100 Poin + Sertifikat', isClaimed: true),
    CheckinReward(day: 14, reward: '250 Poin + E-Book', isClaimed: false),
    CheckinReward(day: 30, reward: '500 Poin + Konsultasi Gratis', isClaimed: false),
  ];

  void _performCheckin() {
    if (_canCheckin) {
      setState(() {
        _currentStreak++;
        _totalCheckins++;
        _lastCheckin = DateTime.now();
        _canCheckin = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Check-in berhasil! Poin telah ditambahkan.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Program Check-in'),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Streak Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Streak Check-in Anda',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '$_currentStreak hari',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total Check-in: $_totalCheckins',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(7, (index) {
                        final day = DateTime.now().subtract(Duration(days: 6 - index));
                        final isChecked = _currentStreak > (6 - index);
                        return _buildStreakDay(day, isChecked);
                      }),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Check-in Button
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 50,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Check-in Hari Ini',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _canCheckin
                          ? 'Dapatkan 10 poin untuk check-in hari ini'
                          : 'Anda sudah check-in hari ini',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _canCheckin ? _performCheckin : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _canCheckin ? Colors.green[800] : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _canCheckin ? 'CHECK-IN SEKARANG' : 'SUDAH CHECK-IN',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    if (!_canCheckin) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Check-in terakhir: ${_lastCheckin.hour}:${_lastCheckin.minute}',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Rewards
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hadiah Streak',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Kumpulkan streak untuk mendapatkan hadiah spesial',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._rewards.map((reward) => RewardItem(reward: reward)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Benefits
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Manfaat Check-in Rutin',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildBenefitItem('Pantau perkembangan anak secara konsisten'),
                    _buildBenefitItem('Dapatkan poin yang bisa ditukar hadiah'),
                    _buildBenefitItem('Akses materi edukasi eksklusif'),
                    _buildBenefitItem('Prioritas dalam program bantuan'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakDay(DateTime day, bool isChecked) {
    return Column(
      children: [
        Text(
          _getDayName(day.weekday),
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 4),
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: isChecked ? Colors.green : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Icon(
            isChecked ? Icons.check : Icons.close,
            size: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          day.day.toString(),
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'Sen';
      case 2: return 'Sel';
      case 3: return 'Rab';
      case 4: return 'Kam';
      case 5: return 'Jum';
      case 6: return 'Sab';
      case 7: return 'Min';
      default: return '';
    }
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green[800]),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class CheckinReward {
  final int day;
  final String reward;
  final bool isClaimed;

  CheckinReward({
    required this.day,
    required this.reward,
    required this.isClaimed,
  });
}

class RewardItem extends StatelessWidget {
  final CheckinReward reward;

  const RewardItem({super.key, required this.reward});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: reward.isClaimed ? Colors.green[50] : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: reward.isClaimed ? Colors.green : Colors.grey,
                shape: BoxShape.circle,
              ),
              child: Icon(
                reward.isClaimed ? Icons.check : Icons.lock,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hari ke-${reward.day}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(reward.reward),
                ],
              ),
            ),
            if (reward.isClaimed)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'CLAIMED',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}