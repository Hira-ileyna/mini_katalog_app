import 'package:flutter/material.dart';
import 'package:mini_katalog_app/helpers/database_helper.dart';
import 'package:mini_katalog_app/models/product.dart';
import 'package:mini_katalog_app/screens/product_detail_screen.dart';
import 'package:mini_katalog_app/screens/product_add_screen.dart';
// ==========================================
// 🛒 SEPET SERVİSİ VE MODELİ
// ==========================================
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartService extends ValueNotifier<List<CartItem>> {
  CartService._internal() : super([]);
  static final CartService instance = CartService._internal();

  void addToCart(Product product) {
    final existingIndex = value.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      value[existingIndex].quantity += 1;
    } else {
      value.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeFromCart(Product product) {
    final existingIndex = value.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      if (value[existingIndex].quantity > 1) {
        value[existingIndex].quantity -= 1;
      } else {
        value.removeAt(existingIndex);
      }
    }
    notifyListeners();
  }

  void clearCart() {
    value.clear();
    notifyListeners();
  }

  double get totalAmount {
    double total = 0.0;
    for (var item in value) {
      total += item.product.price * item.quantity;
    }
    return total;
  }

  int get itemCount {
    int count = 0;
    for (var item in value) {
      count += item.quantity;
    }
    return count;
  }
}

// ==========================================
// 🛒 SEPET EKRANI (CART SCREEN)
// ==========================================
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final cartService = CartService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Talep Edilen Ekipmanlar (Sepet)'),
        backgroundColor: const Color(0xFF005B94),
        foregroundColor: Colors.white,
      ),
      body: ValueListenableBuilder<List<CartItem>>(
        valueListenable: cartService,
        builder: (context, cartItems, child) {
          if (cartItems.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Henüz talep edilen ekipman bulunmuyor.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 50,
                            height: 50,
                            color: Colors.white,
                            child: item.product.imageUrl.startsWith('http')
                                ? Image.network(item.product.imageUrl, fit: BoxFit.contain)
                                : Image.asset(item.product.imageUrl, fit: BoxFit.contain),
                          ),
                        ),
                        title: Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          'Birim: ${item.product.price.toStringAsFixed(2)} TL\nToplam: ${(item.product.price * item.quantity).toStringAsFixed(2)} TL',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                              onPressed: () => cartService.removeFromCart(item.product),
                            ),
                            Text('${item.quantity}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                              onPressed: () => cartService.addToCart(item.product),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Toplam Tutar:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
                          '${cartService.totalAmount.toStringAsFixed(2)} TL',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF005B94),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Talep Oluşturuldu'),
                              content: const Text(
                                'Ekipman talebiniz hastane otomasyon sistemine başarıyla iletilmiştir.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    cartService.clearCart();
                                    Navigator.of(ctx).pop();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Tamam'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('TALEBİ TAMAMLA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ==========================================
// 🏠 ANA SAYFA (GRIDVIEW KART DÜZENİ)
// ==========================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProductsFromDB();
  }

  Future<void> _loadProductsFromDB() async {
    setState(() => _isLoading = true);
    final dbProducts = await DatabaseHelper.instance.getProducts();
    setState(() {
      _allProducts = dbProducts;
      _filteredProducts = dbProducts;
      _isLoading = false;
    });
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts.where((product) {
          final productName = product.name.toLowerCase();
          final productDesc = product.description.toLowerCase();
          final searchLower = query.toLowerCase();
          return productName.contains(searchLower) || productDesc.contains(searchLower);
        }).toList();
      }
    });
  }

  Future<void> _deleteProduct(Product product) async {
  await DatabaseHelper.instance.deleteProduct(product.id);
  _loadProductsFromDB();

  if (!mounted) return;
  
  // 🧹 Varsa ekrandaki eski SnackBar'ı anında temizler
  ScaffoldMessenger.of(context).clearSnackBars();
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('${product.name} silindi.'),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'GERİ AL',
        textColor: Colors.amber,
        onPressed: () async {
          await DatabaseHelper.instance.insertProduct(product);
          _loadProductsFromDB();
        },
      ),
    ),
  );
}

  void _showEditDialog(Product product) {
    final nameController = TextEditingController(text: product.name);
    final priceController = TextEditingController(text: product.price.toString());
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
                maxLines: 3,
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
              if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
                product.name = nameController.text;
                product.price = double.tryParse(priceController.text) ?? product.price;
                product.description = descController.text;

                await DatabaseHelper.instance.updateProduct(product);
                _loadProductsFromDB();

                if (!mounted) return;
                Navigator.of(ctx).pop();

                // 🧹 Eskisini hemen temizle
                ScaffoldMessenger.of(context).clearSnackBars();

                // ⏱️ 2 saniyelik yeni bildirimi göster
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Ürün bilgileri güncellendi.'),
                    duration: Duration(seconds: 2),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Cross - Katalog'),
        backgroundColor: const Color(0xFF005B94),
        foregroundColor: Colors.white,
        actions: [
          ValueListenableBuilder<List<CartItem>>(
            valueListenable: CartService.instance,
            builder: (context, cartItems, child) {
              final count = CartService.instance.itemCount;
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const CartScreen()),
                      );
                    },
                  ),
                  if (count > 0)
                    Positioned(
                      right: 8,
                      top: 8,
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
                          '$count',
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
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF005B94)))
          : Column(
              children: [
                // 🔍 Arama Kutusu
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterProducts,
                    decoration: InputDecoration(
                      hintText: 'Ekipman ara...',
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF005B94)),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                                _filterProducts('');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    ),
                  ),
                ),

                // 📦 2 SÜTUNLU GRIDVIEW KART LİSTESİ
                Expanded(
                  child: _filteredProducts.isEmpty
                      ? const Center(
                          child: Text(
                            'Aranan ekipman bulunamadı.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(10),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 2 Sütun
                            childAspectRatio: 0.72, // Kart En/Boy Oranı
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: _filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = _filteredProducts[index];

                            return Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailScreen(product: product),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Görsel
                                      Expanded(
                                        child: Center(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: product.imageUrl.startsWith('http')
                                                ? Image.network(
                                                    product.imageUrl,
                                                    fit: BoxFit.contain,
                                                    errorBuilder: (context, error, stackTrace) =>
                                                        const Icon(Icons.medical_services, size: 50, color: Color(0xFF005B94)),
                                                  )
                                                : Image.asset(
                                                    product.imageUrl,
                                                    fit: BoxFit.contain,
                                                    errorBuilder: (context, error, stackTrace) =>
                                                        const Icon(Icons.broken_image, size: 50, color: Colors.red),
                                                  ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      // Başlık
                                      Text(
                                        product.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      // Fiyat ve İşlem Butonları
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${product.price.toStringAsFixed(0)} TL',
                                              style: const TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              InkWell(
                                                onTap: () => _showEditDialog(product),
                                                child: const Icon(Icons.edit, color: Color(0xFF005B94), size: 18),
                                              ),
                                              const SizedBox(width: 6),
                                              InkWell(
                                                onTap: () => _deleteProduct(product),
                                                child: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(builder: (context) => const ProductAddScreen()),
          )
              .then((_) {
            _loadProductsFromDB();
          });
        },
        backgroundColor: const Color(0xFF005B94),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}