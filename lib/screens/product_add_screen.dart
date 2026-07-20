import 'package:flutter/material.dart';
import 'package:mini_katalog_app/helpers/database_helper.dart';
import 'package:mini_katalog_app/models/product.dart';

class ProductAddScreen extends StatefulWidget {
  const ProductAddScreen({super.key});

  @override
  State<ProductAddScreen> createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends State<ProductAddScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  final _imageUrlController = TextEditingController();

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final newProduct = Product(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        price: double.parse(_priceController.text),
        description: _descController.text,
        imageUrl: _imageUrlController.text.isEmpty
            ? 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600'
            : _imageUrlController.text,
      );

      // Veri Tabanına Ekle
      await DatabaseHelper.instance.insertProduct(newProduct);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Yeni ekipman başarıyla eklendi.')),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Ekipman Ekle'),
        backgroundColor: const Color(0xFF005B94),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Ekipman Adı'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen ekipman adını giriniz.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Fiyat (TL)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir fiyat giriniz.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Lütfen geçerli bir sayı giriniz.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Açıklama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir açıklama giriniz.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Görsel URL veya Asset Yolu (Opsiyonel)',
                  hintText: 'Örn: assets/images/Steteskop.jpg veya http...',
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _saveProduct,
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text(
                  'Ekipmanı Kaydet',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005B94),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}