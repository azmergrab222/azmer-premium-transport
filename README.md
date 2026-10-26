# Azmer Premium Transport — Flutter starter

Ini ialah projek sumber Flutter untuk aplikasi tempahan ringkas Android. Ia belum merupakan fail APK.

## Fungsi demo
- Borang pickup, destinasi, tarikh dan masa
- Pilihan jenis perjalanan dan kenderaan
- Anggaran harga asas
- Butang WhatsApp yang menyediakan mesej tempahan

## Penting sebelum digunakan
1. Tukar `60123456789` dalam `lib/main.dart` kepada nombor WhatsApp bisnes anda dalam format antarabangsa tanpa `+`.
2. Semak dan tetapkan harga sebenar. Harga dalam kod hanyalah contoh.
3. Uji borang, pautan WhatsApp dan paparan pada telefon.
4. Tambah polisi privasi serta butiran pembangun sebelum penerbitan Google Play.

## Bina APK
Perlu komputer dengan Flutter SDK dan Android SDK dipasang.

```bash
flutter pub get
flutter run
flutter build apk --release
```

APK biasanya dihasilkan di:
`build/app/outputs/flutter-apk/app-release.apk`

Untuk Google Play, bina Android App Bundle:
```bash
flutter build appbundle --release
```

Fail AAB biasanya berada di:
`build/app/outputs/bundle/release/app-release.aab`
