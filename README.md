# general usage
flutter pub get
flutter run

# Commands for specific changes (on first-use)

# clear onboarding flag (android)
adb shell pm clear com.bytewyze.local_fork

# to replace the default flutter icon with our logo
flutter pub get
flutter pub run flutter_launcher_icons
flutter run
