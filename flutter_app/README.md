# Retail Products Flutter App

Instructions:

1. Run `flutter create .` in `flutter_app` to generate platform folders.
2. Add dependencies: `http`, `image_picker`, `provider` in `pubspec.yaml`.
3. Replace `lib/` with the provided files.
4. For release APKs, set the backend URL in `lib/services/api_service.dart` or override it with `--dart-define=API_BASE=...`.

Example run (Android emulator):

```bash
cd flutter_app
flutter pub get
flutter run --dart-define=API_BASE=http://10.0.2.2:3000 --dart-define=CLOUDINARY_CLOUD_NAME=your_cloud --dart-define=CLOUDINARY_UPLOAD_PRESET=your_preset
```

For APK builds, the app uses the production URL defined in `lib/services/api_service.dart` unless you pass a different `API_BASE`.
