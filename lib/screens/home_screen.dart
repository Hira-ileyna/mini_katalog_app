import 'package:flutter/material.dart';
import '../models/product.dart';
import '../helpers/database_helper.dart';
import '../services/cart_service.dart';
import '../widgets/product_card.dart';
import 'product_add_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProductsFromDB();
  }

  Future<void> _loadProductsFromDB() async {
    final list = await DatabaseHelper.instance.getProducts();
    setState(() {
      _products = list;
      if (_searchController.text.isEmpty) {
        _filteredProducts = list;
      } else {
        _filterProducts(_searchController.text);
      }
    });
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = _products;
      } else {
        _filteredProducts = _products
            .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _deleteProduct(Product product) async {
    await DatabaseHelper.instance.deleteProduct(product.id);
    await _loadProductsFromDB();

    if (!mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Text('${product.name} silindi.'),
        duration: const Duration(milliseconds: 1500),
        action: SnackBarAction(
          label: 'GERİ AL',
          textColor: Colors.amber,
          onPressed: () async {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            await DatabaseHelper.instance.insertProduct(product);
            await _loadProductsFromDB();
          },
        ),
      ),
    );
  }

  void _showEditDialog(Product product) {
    final nameController = TextEditingController(text: product.name);
    final priceController =
        TextEditingController(text: product.price.toString());
    final descController = TextEditingController(text: product.description);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ürün Bilgilerini Düzenle'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Ürün Adı'),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Fiyat (TL)'),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Açıklama'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF005B94),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              if (nameController.text.isNotEmpty &&
                  priceController.text.isNotEmpty) {
                product.name = nameController.text;
                product.price =
                    double.tryParse(priceController.text) ?? product.price;
                product.description = descController.text;

                await DatabaseHelper.instance.updateProduct(product);
                await _loadProductsFromDB();

                if (!mounted) return;
                Navigator.of(ctx).pop();

                ScaffoldMessenger.of(context).clearSnackBars();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    content: const Text('Ürün bilgileri güncellendi.'),
                    duration: const Duration(milliseconds: 1500),
                  ),
                );
              }
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 🧹 Ekranın boş bir yerine dokunulduğunda SnackBar'ı anında kapatır
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Medical Cross - Katalog'),
          backgroundColor: const Color(0xFF005B94),
          foregroundColor: Colors.white,
          actions: [
            ValueListenableBuilder<List<CartItem>>(
              valueListenable: CartService.instance,
              builder: (context, cartItems, child) {
                final itemCount = CartService.instance.itemCount;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_cart),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CartScreen(),
                            ),
                          );
                        },
                      ),
                      if (itemCount > 0)
                        Positioned(
                          right: 4,
                          top: 4,
                          child: IgnorePointer(
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: Text(
                                '$itemCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                onChanged: _filterProducts,
                decoration: InputDecoration(
                  hintText: 'Ekipman ara...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: _filteredProducts.isEmpty
                  ? const Center(child: Text('Ürün bulunamadı.'))
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = _filteredProducts[index];
                        return ProductCard(
                          product: product,
                          onDelete: () => _deleteProduct(product),
                          onEdit: () => _showEditDialog(product),
                        );
                      },
                    ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF005B94),
          foregroundColor: Colors.white,
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProductAddScreen(),
              ),
            );
            _loadProductsFromDB();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}