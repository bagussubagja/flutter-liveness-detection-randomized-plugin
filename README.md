# Flutter Liveness Detection Randomized Plugin

A Flutter plugin for liveness detection with randomized challenge response method with an interaction mechanism between the user and the system in the form of a movement challenge that indicates life is detected on the face. This plugin helps implement secure biometric authentication by detecting real human presence through dynamic facial verification challenges.

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/39f28a005ba64897a23f6c7a13e41682)](https://app.codacy.com/gh/bagussubagja/flutter-liveness-detection-randomized-plugin?utm_source=github.com&utm_medium=referral&utm_content=bagussubagja/flutter-liveness-detection-randomized-plugin&utm_campaign=Badge_Grade)
[![pub package](https://img.shields.io/pub/v/flutter_liveness_detection_randomized_plugin.svg)](https://pub.dev/packages/flutter_liveness_detection_randomized_plugin)

## Preview 🪟
![Slide 16_9 - 1](https://github.com/user-attachments/assets/55e59d51-e0da-4562-879e-ae50adaced33)

https://github.com/user-attachments/assets/f7266dc9-c4a2-4fba-8684-0ead2f678180

## Features ✨

- 📱 Real-time face detection
- 🎲 Randomized challenge sequence generation
- 💫 Cross-platform support (iOS & Android) 
- 🎨 Customizable UI components
- ✅ High accuracy liveness verification
- 🚀 Simple integration API

## Getting Started 🌟

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_liveness_detection_randomized_plugin: ^1.0.0
```

## Platform Setup

### Android
Add camera permission to your AndroidManifest.xml:
```
<uses-permission android:name="android.permission.CAMERA"/>
```
Minimum SDK version: 21

### iOS
Add camera usage description to Info.plist:
```
<key>NSCameraUsageDescription</key>
<string>Camera access is required for liveness detection</string>
```
