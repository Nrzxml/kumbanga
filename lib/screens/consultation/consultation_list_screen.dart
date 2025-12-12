import 'package:flutter/material.dart';
import 'consultation_chat_screen.dart';

class ConsultationListScreen extends StatefulWidget {
  const ConsultationListScreen({super.key});

  @override
  _ConsultationListScreenState createState() => _ConsultationListScreenState();
}

class _ConsultationListScreenState extends State<ConsultationListScreen> {
  final List<Map<String, dynamic>> _consultations = [
    {
      'id': '1',
      'doctorName': 'Dr. Sari Indah, Sp.A',
      'specialty': 'Dokter Spesialis Anak',
      'hospital': 'RS Umum Daerah',
      'lastMessage': 'Bagaimana perkembangan anak Ibu?',
      'lastMessageTime': DateTime.now().subtract(const Duration(hours: 2)),
      'unreadCount': 1,
      'isOnline': true,
    },
    {
      'id': '2',
      'doctorName': 'Dr. Budi Santoso, Gizi',
      'specialty': 'Ahli Gizi',
      'hospital': 'Puskesmas Melati',
      'lastMessage': 'Menu makanan sudah sesuai',
      'lastMessageTime': DateTime.now().subtract(const Duration(days: 1)),
      'unreadCount': 0,
      'isOnline': false,
    },
    {
      'id': '3',
      'doctorName': 'Ns. Maya Sari, S.Kep',
      'specialty': 'Perawat Anak',
      'hospital': 'Klinik Bunda',
      'lastMessage': 'Jangan lupa kontrol bulan depan',
      'lastMessageTime': DateTime.now().subtract(const Duration(days: 3)),
      'unreadCount': 0,
      'isOnline': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konsultasi'),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.medical_services),
                    label: const Text('Dokter Anak'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.restaurant_menu),
                    label: const Text('Ahli Gizi'),
                  ),
                ),
              ],
            ),
          ),

          // Consultation List
          Expanded(
            child: ListView.builder(
              itemCount: _consultations.length,
              itemBuilder: (context, index) {
                final consultation = _consultations[index];
                return ConsultationListItem(
                  consultation: consultation,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConsultationChatScreen(
                          consultation: consultation,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNewConsultationDialog();
        },
        backgroundColor: Colors.green[800],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showNewConsultationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konsultasi Baru'),
        content: const Text('Pilih jenis konsultasi yang diinginkan'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to doctor selection
            },
            child: const Text('Pilih Dokter'),
          ),
        ],
      ),
    );
  }
}

class ConsultationListItem extends StatelessWidget {
  final Map<String, dynamic> consultation;
  final VoidCallback onTap;

  const ConsultationListItem({
    super.key,
    required this.consultation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Stack(
          children: [
            const CircleAvatar(
              radius: 25,
              child: Icon(Icons.person),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: consultation['isOnline'] == true ? Colors.green : Colors.grey,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          consultation['doctorName'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(consultation['specialty']),
            Text(
              consultation['lastMessage'],
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatTime(consultation['lastMessageTime']),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            if (consultation['unreadCount'] > 0)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  consultation['unreadCount'].toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays}h';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}j';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Baru saja';
    }
  }
}