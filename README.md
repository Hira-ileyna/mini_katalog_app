# Medical Cross - Mini Katalog Uygulaması

Flutter ile geliştirilmiş basit ve kullanışlı bir medikal ekipman katalog ve sepet yönetimi uygulaması.

## Özellikler

- Medikal ürünlerin grid yapısında listelenmesi
- Ürün ismi ile anlık arama / filtreleme
- Yeni ürün ekleme, düzenleme ve silme (Geri alma desteğiyle)
- Ürün detay ekranı
- Sepete ürün ekleme, çıkarma ve canlı sepet sayısı gösterimi
- SQLite (`sqflite`) ile verilerin cihazda kalıcı tutulması

## Proje Yapısı

Proje `lib` klasörü altında modüler bir yapıda geliştirilmiştir:

- **helpers:** Veritabanı yardımcı sınıfları
- **models:** Veri modelleri
- **screens:** Uygulama ekranları
- **services:** Sepet yönetimi ve iş mantığı
- **widgets:** Ortak UI bileşenleri

## Kullanım

```bash
# Bağımlılıkları yükle
flutter pub get

# Projeyi çalıştır
flutter run