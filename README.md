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
├── domain/          # Business logic
└── presentation/    # UI (screens, widgets, providers)
```

## 🚀 Memulai

### Prasyarat

- Flutter SDK 3.7.2 atau lebih tinggi
- Dart SDK ^3.7.2
- Android Studio / VS Code dengan plugin Flutter

### Instalasi

1. Clone repositori ini
```powershell
git clone [url-repositori]
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

### Tema
- Dukungan tema terang dan gelap
- Beralih tema secara otomatis mengikuti sistem

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
- Tanggal Dibuat

## 🤝 Kontribusi

Kontribusi selalu diterima! Silakan buat pull request untuk:
- Perbaikan bug
- Penambahan fitur baru
- Peningkatan dokumentasi
- Optimasi performa

## 📝 Lisensi

Proyek ini dilisensikan di bawah [Lisensi MIT](LICENSE)

## 👥 Tim Pengembang

[Tazkan Games](https://tazkan.com/)

---

Dibuat dengan ❤️ menggunakan Flutter