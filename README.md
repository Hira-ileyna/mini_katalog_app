# Medical Cross - Tıbbi Ekipman Katalog ve Sepet Uygulaması

Medical Cross, medikal ekipmanların listelenmesi, detaylı incelenmesi, sepete eklenmesi ve yönetilmesi amacıyla Flutter kullanılarak geliştirilmiş bir mobil katalog uygulamasıdır.

## Öne Çıkan Özellikler

- Dinamik Katalog: Tıbbi cihaz ve ekipmanların grid yapısında listelenmesi.
- Arama Özelliği: Ekipman adı üzerinden anlık filtrelenebilir arama çubuğu.
- Ürün Yönetimi (CRUD): Yeni ürün ekleme, var olan ürün bilgilerini düzenleme ve silme işlemleri.
- Ürün Detay Sayfası: Ürün görselleri, fiyat ve açıklamalarının yer aldığı özel detay ekranı.
- Canlı Sepet Yönetimi: App Bar üzerinde anlık ürün sayısı takibi, sepete ürün ekleme, çıkarma ve toplam tutar hesaplama.
- Yerel Veritabanı: sqflite (SQLite) entegrasyonu ile verilerin cihazda kalıcı saklanması.

## Kullanılan Teknolojiler

- Framework: Flutter (Dart)
- Veritabanı: SQLite (sqflite)
- State Management: ValueNotifier ve Singleton Tasarım Kalıbı (CartService)

## Proje Dizin Yapısı

lib/
├── helpers/        # Veritabanı yardımcı sınıfları
├── models/         # Veri modelleri
├── screens/        # Uygulama ekranları
├── services/       # İş mantığı ve servisler
├── widgets/        # Yeniden kullanılabilir bileşenler
└── main.dart       # Uygulama başlangıç noktası

## Kurulum ve Çalıştırma

1. Projeyi klonlayın:
   git clone https://github.com/kullanici-adiniz/mini_katalog_app.git

2. Proje dizinine gidin:
   cd mini_katalog_app

3. Bağımlılıkları yükleyin:
   flutter pub get

4. Uygulamayı çalıştırın:
   flutter run