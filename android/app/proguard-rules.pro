# Proguard rules for Flutter

# Keep the classes related to Flutter
-keep class io.flutter.** { *; }

# Keep the classes related to Firebase
-keep class com.google.firebase.** { *; }

# Keep the classes related to shared preferences
-keep class android.content.SharedPreferences { *; }

# Add other specific rules as needed
