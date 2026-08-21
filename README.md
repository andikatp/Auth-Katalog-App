# Auth Katalog App

[![Dart & Flutter CI](https://github.com/andikatp/Auth-Katalog-App/actions/workflows/dart.yml/badge.svg)](https://github.com/andikatp/Auth-Katalog-App/actions/workflows/dart.yml)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)

Repository ini berisi project Flutter untuk technical test Konten.com. Aplikasi ini mencakup fitur autentikasi (login, session persistence), katalog produk dengan pagination, dan penanganan refresh token otomatis.

---

## Cara Run Project

### Prerequisites
* Flutter SDK (`^3.13.1`)
* Dart SDK (`^3.13.1`)

### Langkah Jalankan

1. **Install dependensi**
   ```bash
   flutter pub get
   ```

2. **Generate kode (Riverpod, Freezed, Envied)**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Jalankan Aplikasi**
   * Development mode:
     ```bash
     flutter run -t lib/main_dev.dart
     ```
   * Production mode:
     ```bash
     flutter run -t lib/main_prod.dart
     ```

4. **Jalankan Linter & Test**
   ```bash
   flutter analyze
   flutter test
   ```

---

## Single-Flight Token Refresh

Salah satu tantangan saat token expired (`401 Unauthorized`) adalah ketika ada beberapa API request yang jalan secara bersamaan (misal saat dashboard pertama kali dimuat). Tanpa penanganan khusus, aplikasi akan memanggil endpoint `/auth/refresh` beberapa kali secara paralel.

### Solusi & Cara Kerja

Di aplikasi ini, single-flight refresh diimplementasikan pada `ApiInterceptor` ([`lib/core/network/dio/dio_client.dart`](file:///Users/andikatp/Documents/Belajar/Auth-Katalog-App/lib/core/network/dio/dio_client.dart#L72-L109)) menggunakan package `synchronized` (`Lock`):

1. **Request 401 masuk antrean lock:** Saat request gagal dengan status 401, request tersebut mencoba masuk ke dalam `_lock.synchronized()`.
2. **Request pertama melakukan refresh:** Request pertama yang mendapatkan lock akan memanggil endpoint `/auth/refresh`, mengambil token baru, lalu menyimpannya ke `flutter_secure_storage`.
3. **Request berikutnya menanti & retry:** Request lain yang 401 di saat bersamaan akan mengantri. Setelah lock terlepas, mereka mengecek apakah token sudah berubah. Karena token sudah baru, mereka tidak memanggil `/auth/refresh` lagi, melainkan langsung melakukan retry dengan token baru:

```dart
// Potongan kode dari ApiInterceptor (dio_client.dart)
final response = await _lock.synchronized(() async {
  final currentToken = _ref.read(tokenServiceProvider).token;
  final requestToken = err.requestOptions.headers['Authorization']
      ?.toString()
      .replaceFirst('Bearer ', '');

  // Jika token sudah di-refresh oleh request sebelumnya, langsung retry
  if (currentToken != null &&
      currentToken.isNotEmpty &&
      currentToken != requestToken) {
    return _retry(err.requestOptions);
  }

  // Jika belum, lakukan refresh token sekali saja
  await _refreshToken();
  return _retry(err.requestOptions);
});
```

---

## Keputusan Arsitektur

Project ini menggunakan pendekatan **Feature-First Domain-Driven Design (DDD)** dengan **Riverpod** sebagai state management.

Struktur folder dikelompokkan per fitur (`auth`, `dashboard`, `profile`, `core`) dengan pembagian layer:
* **domain:** Entitas dan kontrak repositori.
* **infrastructure:** Data source (Dio & Secure Storage), DTO/Model, dan repositori konkret.
* **application:** Controller / Notifier (diproduksi lewat `riverpod_generator`).
* **presentation:** Screen & Widget UI.

**Tech stack & pustaka yang dipakai:**
* **State Management:** `flutter_riverpod` + `riverpod_generator`
* **Routing:** `go_router` + `go_router_builder`
* **HTTP Client:** `dio` + `talker_dio_logger` untuk logging
* **Flavors:** Multi-entrypoint (`main_dev.dart` & `main_prod.dart`) dengan `FlavorConfig`
* **UI & Pagination:** `infinite_scroll_pagination` & `skeletonizer` untuk loading state

---

## Waktu Pengerjaan

Total waktu pengerjaan sekitar **14 - 16 jam** yang terbagi dalam beberapa tahapan:
* **Setup awal & arsitektur:** Setup folder, Riverpod, GoRouter, dan Flavors (~3 jam)
* **Auth & Single-Flight Interceptor:** Logic login, secure storage, dan Dio interceptor (~4 jam)
* **Katalog Produk & UI:** Infinite scroll, detail produk, skeleton loading (~5 jam)
* **Polishing & Cleanup:** Handling error UI, linter Very Good Analysis, & dokumentasi (~3 jam)

---

## Yang Ingin Diperbaiki (Jika Ada Waktu Lebih)

- [ ] **Upgrade AGP & Kotlin:** Upgrade versi Android Gradle Plugin dan Kotlin agar lebih up-to-date dengan versi Flutter/Gradle terbaru.
- [ ] **Stabilkan Dependensi:** Mengganti beberapa dependensi versi dev/beta (seperti freezed dev build) ke versi yang release stable.
- [ ] **Environment Handling:** Memindahkan `.env` keluar dari git tracking (disimpan di repo saat ini hanya untuk kemudahan testing).
- [ ] **UI & Integration Test:** Menambahkan UI test menggunakan `patrol` atau `integration_test`.
