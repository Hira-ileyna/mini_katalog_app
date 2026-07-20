class Product {
  final String id;
  String name;
  double price;
  String description;
  String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      description: map['description'],
      imageUrl: map['imageUrl'],
    );
  }
}

List<Product> dummyProducts = [
  Product(
    id: 'm1',
    name: 'Dijital Stetoskop Pro',
    price: 4250.00,
    description: 'Yüksek hassasiyetli ses filtresine ve Bluetooth bağlantısına sahip yeni nesil stetoskop.',
    imageUrl: 'assets/images/Steteskop.jpg',
  ),
  Product(
    id: 'm2',
    name: 'Portatif Pulse Oksimetre',
    price: 650.00,
    description: 'Anlık nabız ve kandaki oksijen doygunluğunu (SpO2) ölçen kompakt parmak tipi cihaz.',
    imageUrl: 'assets/images/oksimetre.jpg',
  ),
  Product(
    id: 'm3',
    name: 'Gelişmiş İlk Yardım Kiti',
    price: 1250.50,
    description: 'Medical Cross standartlarına uygun, acil müdahale için tüm temel tıbbi malzemeleri içeren çanta.',
    imageUrl: 'assets/images/ilkyardim.jpg',
  ),
];