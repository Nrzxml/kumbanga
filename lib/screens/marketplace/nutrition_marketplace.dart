import 'package:flutter/material.dart';
import 'checkout_screen.dart';

class NutritionMarketplace extends StatefulWidget {
  const NutritionMarketplace({super.key});

  @override
  _NutritionMarketplaceState createState() => _NutritionMarketplaceState();
}

class _NutritionMarketplaceState extends State<NutritionMarketplace> {
  final List<Map<String, dynamic>> _products = [
    {
      'id': '1',
      'name': 'Susu Formula Pertumbuhan',
      'description': 'Susu formula khusus untuk bayi 6-12 bulan',
      'price': 85000,
      'image': 'assets/susu_formula.jpg',
      'category': 'Susu',
      'rating': 4.8,
      'stock': 50,
    },
    {
      'id': '2',
      'name': 'Bubur Bayi Organik',
      'description': 'Bubur bayi instan dengan bahan organik',
      'price': 25000,
      'image': 'assets/bubur_bayi.jpg',
      'category': 'MPASI',
      'rating': 4.6,
      'stock': 30,
    },
    {
      'id': '3',
      'name': 'Vitamin A+D Drops',
      'description': 'Vitamin tetes untuk pertumbuhan tulang',
      'price': 45000,
      'image': 'assets/vitamin_drops.jpg',
      'category': 'Vitamin',
      'rating': 4.9,
      'stock': 20,
    },
    {
      'id': '4',
      'name': 'Biskuit Bayi',
      'description': 'Biskuit bergizi untuk melatih motorik',
      'price': 18000,
      'image': 'assets/biskuit_bayi.jpg',
      'category': 'Snack',
      'rating': 4.5,
      'stock': 40,
    },
    {
      'id': '5',
      'name': 'Probiotik Bayi',
      'description': 'Probiotik untuk kesehatan pencernaan',
      'price': 65000,
      'image': 'assets/probiotik.jpg',
      'category': 'Suplemen',
      'rating': 4.7,
      'stock': 15,
    },
    {
      'id': '6',
      'name': 'MPASI Homemade Set',
      'description': 'Bahan MPASI homemade berkualitas',
      'price': 75000,
      'image': 'assets/mpasi_set.jpg',
      'category': 'MPASI',
      'rating': 4.8,
      'stock': 25,
    },
  ];

  final List<String> _categories = [
    'Semua',
    'Susu',
    'MPASI',
    'Vitamin',
    'Snack',
    'Suplemen'
  ];

  int _selectedCategory = 0;
  final List<Map<String, dynamic>> _cart = [];

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      _cart.add(product);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} ditambahkan ke keranjang'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _navigateToCheckout() {
    if (_cart.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutScreen(cartItems: _cart),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Keranjang belanja kosong'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _selectedCategory == 0
        ? _products
        : _products
            .where((product) =>
                product['category'] == _categories[_selectedCategory])
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Penuhi Gizi'),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: _navigateToCheckout,
              ),
              if (_cart.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      _cart.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: FilterChip(
                    label: Text(_categories[index]),
                    selected: _selectedCategory == index,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = index;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Product Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.65,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return ProductCard(
                  product: product,
                  onAddToCart: () => _addToCart(product),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Placeholder
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(product['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product['name'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              'Rp ${product['price']}',
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, size: 14, color: Colors.amber),
                const SizedBox(width: 2),
                Text(
                  product['rating'].toString(),
                  style: const TextStyle(fontSize: 12),
                ),
                const Spacer(),
                Text(
                  'Stok: ${product['stock']}',
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onAddToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'Tambah',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
