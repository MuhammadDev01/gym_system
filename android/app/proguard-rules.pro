-keep class com.kongigym.app.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**
-keepattributes Signature
-keepattributes *Annotation*

# GoRouter / Flutter
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**
-keep class com.google.gson.** { *; }

# Keep serialization models
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}
