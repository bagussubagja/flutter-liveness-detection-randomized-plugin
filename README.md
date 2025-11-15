# Flutter Liveness Detection Randomized Plugin

A Flutter plugin for liveness detection with randomized challenge response method with an interaction mechanism between the user and the system in the form of a movement challenge that indicates life is detected on the face. This plugin helps implement secure biometric authentication by detecting real human presence through dynamic facial verification challenges.

[![pub package](https://img.shields.io/pub/v/flutter_liveness_detection_randomized_plugin.svg)](https://pub.dev/packages/flutter_liveness_detection_randomized_plugin)

[![Codacy Badge](https://app.codacy.com/project/badge/Grade/50b64954ad654b65b0424d266399b026)](https://app.codacy.com/gh/bagussubagja/flutter-liveness-detection-randomized-plugin/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)

## Preview 🪟
![Slide 16_9 - 1](https://github.com/user-attachments/assets/55e59d51-e0da-4562-879e-ae50adaced33)

https://github.com/user-attachments/assets/f7266dc9-c4a2-4fba-8684-0ead2f678180

## Update 1.1.0
- ⏱️ Added automatic cooldown feature after 3 failed verification attempts
- 🔒 10-minute waiting period with persistent countdown (survives app restarts)
- 🎯 Countdown only decreases when app is active (pauses when app is backgrounded)

## Update 1.0.6
![Slide 16_9 - 9](https://github.com/user-attachments/assets/3a9b187a-ccfd-4542-a8d9-88b7ef7903a9)
Face stretching already fixed on this version

## Features ✨

- 📱 Real-time face detection
- 🎲 Randomized challenge sequence generation
- 💫 Cross-platform support (iOS & Android) 
- 🎨 Light and dark mode support
- ✅ High accuracy liveness verification
- 🚀 Simple integration API
- 🎭 Customizable liveness challenge labels
- ⏳ Flexible security verification duration
- 🎲 Adjustable number of liveness challenges
- 🛠️ Adjustable image quality result
- ⏱️ Automatic cooldown after failed attempts

## Getting Started 🌟

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_liveness_detection_randomized_plugin: ^1.1.0
```

## Cooldown Feature
The plugin now includes an automatic cooldown mechanism to prevent brute force attempts:
- Configurable number of failed attempts before cooldown (default: 3)
- Configurable cooldown duration (default: 10 minutes)
- The countdown timer only decreases when the app is active (foreground)
- Cooldown state persists even if the app is closed and reopened
- Users will see a countdown screen during the cooldown period
- Enable/disable this feature using `enableCooldownOnFailure` parameter

```dart
config: LivenessDetectionConfig(
  enableCooldownOnFailure: true, // Enable cooldown feature (default: true)
  maxFailedAttempts: 5, // Number of failed attempts before cooldown (default: 3)
  cooldownMinutes: 15, // Cooldown duration in minutes (default: 10)
),
```

## Customized Steps Label
You can customized steps label or use certain step only of liveness challenge with this example :
```dart
config: LivenessDetectionConfig(
customizedLabel: LivenessDetectionLabelModel(
  blink: '', // add empty string to skip/pass this liveness challenge
  lookDown: '',
  lookLeft: '',
  lookRight: '',
  lookUp: 'Tengok Atas', // example of customize label name for liveness challenge. it will replace default 'look up'
  smile: null, // null value to use default label name
),
),
```

## Platform Setup

### Android
Add camera permission to your AndroidManifest.xml:
```xml
<uses-permission android:name="android.permission.CAMERA"/>
```
Minimum SDK version: 23

### iOS
Add camera usage description to Info.plist:
```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required for liveness detection</string>
```