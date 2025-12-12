import 'package:flutter/material.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  final List<Order> _orders = [
    Order(
      id: 'ORD-001',
      date: DateTime.now().subtract(const Duration(days: 2)),
      items: ['Susu Formula Pertumbuhan', 'Bubur Bayi Organik'],
      total: 110000,
      status: 'completed',
    ),
    Order(
      id: 'ORD-002',
      date: DateTime.now().subtract(const Duration(days: 1)),
      items: ['Vitamin A+D Drops'],
      total: 45000,
      status: 'shipped',
    ),
    Order(
      id: 'ORD-003',
      date: DateTime.now(),
      items: ['Probiotik Bayi', 'MPASI Homemade Set'],
      total: 140000,
      status: 'processing',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          final order = _orders[index];
          return OrderCard(order: order);
        },
      ),
    );
  }
}

class Order {
  final String id;
  final DateTime date;
  final List<String> items;
  final int total;
  final String status; // processing, shipped, completed

  Order({
    required this.id,
    required this.date,
    required this.items,
    required this.total,
    required this.status,
  });

  String get statusText {
    switch (status) {
      case 'processing':
        return 'Sedang Diproses';
      case 'shipped':
        return 'Dikirim';
      case 'completed':
        return 'Selesai';
      default:
        return 'Menunggu';
    }
  }

  Color get statusColor {
    switch (status) {
      case 'processing':
        return Colors.orange;
      case 'shipped':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.id,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: order.statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: order.statusColor),
                  ),
                  child: Text(
                    order.statusText,
                    style: TextStyle(
                      color: order.statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Tanggal: ${order.date.day}/${order.date.month}/${order.date.year}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            const Text(
              'Items:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...order.items.map((item) => Text('• $item')).toList(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Rp ${order.total}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (order.status == 'shipped')
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // Track order
                  },
                  child: const Text('Lacak Pengiriman'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}