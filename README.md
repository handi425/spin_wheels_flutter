# SpinWheels 🎡

Aplikasi undian berputar (spin wheel) yang dibuat dengan Flutter.

## 📱 Fitur Utama

- Roda undian yang dapat diputar secara interaktif
- Manajemen hadiah dengan probabilitas kemenangan
- Riwayat putaran untuk setiap pengguna
- Sistem manajemen pengguna
- Tampilan statistik undian
- Tema terang dan gelap
- Animasi yang menarik
- Database lokal untuk penyimpanan data

## 🛠️ Teknologi yang Digunakan

- **Flutter SDK:** ^3.7.2
- **State Management:** Provider
- **Database:** SQLite (sqflite)
- **UI Components:**
  - flutter_fortune_wheel
  - fl_chart
  - flutter_animate
  - flutter_slidable
  - shimmer
- **Utilities:**
  - shared_preferences
  - path_provider
  - intl
  - uuid
  - cached_network_image
  - lottie

## 📦 Struktur Proyek

```
lib/
├── config/          # Konfigurasi aplikasi
├── core/            # Fungsi dan utilitas inti
├── data/            # Layer data (models, sources)
│   ├── models/      # Model data
│   ├── repositories/ # Repositori
│   └── sources/     # Sumber data lokal dan remote
├── domain/          # Business logic
└── presentation/    # UI (screens, widgets, providers)
    ├── providers/   # State management
    ├── screens/     # Halaman utama
    └── widgets/     # Widget yang dapat digunakan kembali
```

## 🚀 Memulai

### Prasyarat

- Flutter SDK 3.7.2 atau lebih tinggi
- Dart SDK ^3.7.2
- Android Studio / VS Code dengan plugin Flutter
- Minimal 4GB RAM
- Perangkat Android (Android 6.0+) atau iOS (iOS 12+) untuk pengujian
- Koneksi internet untuk mengunduh dependensi

### Instalasi

1. Clone repositori ini
```powershell
git clone https://github.com/handi425/spin_wheels_flutter.git
```

2. Masuk ke direktori proyek
```powershell
cd spin_wheels
```

3. Install dependensi
```powershell
flutter pub get
```

4. Jalankan aplikasi
```powershell
flutter run
```

### Build untuk Production

1. Build untuk Android
```powershell
flutter build apk --release
```

2. Build untuk iOS (hanya di macOS)
```powershell
flutter build ios --release
```

## 📱 Fitur Detail

### Manajemen Hadiah
- Tambah, edit, dan hapus hadiah
- Atur probabilitas untuk setiap hadiah
- Tampilan daftar hadiah yang tersedia
- Upload gambar hadiah

### Manajemen Pengguna
- Pendaftaran pengguna baru
- Edit profil pengguna
- Riwayat undian per pengguna

### Riwayat Putaran
- Catat setiap putaran undian
- Status pengiriman hadiah
- Catatan tambahan untuk setiap undian
- Ekspor data riwayat

### Tema
- Dukungan tema terang dan gelap
- Beralih tema secara otomatis mengikuti sistem
- Kustomisasi warna utama

## 📄 Model Data

### User
- ID
- Nama
- Email
- Nomor Telepon
- Tanggal Dibuat/Diperbarui

### Prize (Hadiah)
- ID
- Nama
- Deskripsi
- Nilai
- Warna
- Probabilitas
- Jumlah Tersedia
- Path Gambar
- Tanggal Dibuat/Diperbarui

### SpinHistory (Riwayat Putaran)
- ID
- ID Pengguna
- ID Hadiah
- Status Pengiriman
- Tanggal Pengiriman
- Catatan
- Nomor Resi
- Tanggal Dibuat

## 🤝 Kontribusi

Kontribusi selalu diterima! Silakan ikuti langkah-langkah berikut:

1. Fork repositori
2. Buat branch fitur (`git checkout -b fitur-baru`)
3. Commit perubahan Anda (`git commit -m 'Menambahkan fitur baru'`)
4. Push ke branch (`git push origin fitur-baru`)
5. Buat Pull Request baru

Kontribusi dapat berupa:
- Perbaikan bug
- Penambahan fitur baru
- Peningkatan dokumentasi
- Optimasi performa
- Terjemahan ke bahasa lain

## ❓ FAQ

### Apakah aplikasi ini gratis?
Ya, aplikasi ini bersifat open source dan gratis untuk digunakan.

### Bisakah saya menggunakan aplikasi ini secara offline?
Ya, aplikasi menggunakan database lokal sehingga dapat beroperasi tanpa koneksi internet.

### Bagaimana cara melaporkan bug?
Silakan buat issue baru di repositori GitHub dengan detail bug yang ditemui.

### Apakah aplikasi ini tersedia di Play Store atau App Store?
Belum saat ini, tetapi Anda dapat membangun dan menginstalnya dari sumber.

## 📝 Lisensi

Proyek ini dilisensikan di bawah [Lisensi MIT](LICENSE)

## 👥 Tim Pengembang

- [Tazkan Games](https://tazkan.com/)

## 📞 Kontak

Jika Anda memiliki pertanyaan atau saran, silakan hubungi kami di:
- Email: support@tazkan.com
- Facebook: [@TazkanGames](https://www.facebook.com/tazkangames)
- Linkedin: [@TazkanGames](https://www.linkedin.com/company/tazkan-games/)

---

Dibuat dengan ❤️ menggunakan Flutter
