# PawFeed

Prototype Flutter PawFeed dengan layar navigable dan data mock lokal. Belum terhubung ke Firebase, MQTT, atau ESP32.

## Prasyarat Windows

- Flutter stable
- Android Studio dan Android SDK
- Android Emulator atau perangkat Android dengan USB debugging

Path instalasi Flutter dan Android SDK bersifat lokal pada setiap komputer, sehingga tidak dicantumkan di repository. Setelah memasang Android Studio, selesaikan **Setup Wizard** dan pastikan Android SDK Platform, Android SDK Platform-Tools, serta Android SDK Command-line Tools terpasang. Kemudian buka terminal baru:

```powershell
flutter doctor --android-licenses
flutter doctor
```

Jika perintah `flutter` belum dikenali, tambahkan folder `flutter\bin` ke PATH Windows atau gunakan lokasi Flutter yang sesuai dengan komputer Anda.

## Menjalankan aplikasi

```powershell
flutter pub get
flutter devices
flutter run
```

Pilih perangkat Android dari keluaran `flutter devices`. Untuk membuat APK debug:

```powershell
flutter build apk --debug
```

## Mencoba mode mock

1. Tekan **Masuk** pada layar login (login demo tidak memerlukan kredensial).
2. Buka tab **Pengaturan**.
3. Pada kartu **Mode demo UI**, pilih Normal, Menipis, Offline, atau Loading.
4. Kembali ke Beranda dan Monitoring untuk melihat state perangkat yang dipilih.

Tab Beranda, Jadwal, Monitoring, dan Pengaturan dapat dinavigasi. Aksi perangkat dan jadwal hanya simulasi UI; tidak menggerakkan feeder/pompa sungguhan dan belum menyimpan data ke backend.
