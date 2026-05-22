@echo off
echo Preparing Flutter project in %CD%
echo Running `flutter create .` to ensure platform folders exist (android/ios)
flutter create .
echo Fetching dependencies...
flutter pub get
echo Flutter project prepared. Open this folder in Android Studio.
pause
