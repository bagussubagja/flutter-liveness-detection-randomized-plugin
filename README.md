# Flutter Liveness Detection Randomized Plugin

A Flutter plugin for liveness detection with randomized challenge response method with an interaction mechanism between the user and the system in the form of a movement challenge that indicates life is detected on the face. This plugin helps implement secure biometric authentication by detecting real human presence through dynamic facial verification challenges.

[![pub package](https://img.shields.io/pub/v/flutter_liveness_detection_randomized_plugin.svg)](https://pub.dev/packages/flutter_liveness_detection_randomized_plugin)

[![Codacy Badge](https://app.codacy.com/project/badge/Grade/50b64954ad654b65b0424d266399b026)](https://app.codacy.com/gh/bagussubagja/flutter-liveness-detection-randomized-plugin/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)

## Preview 🪟
![Slide 16_9 - 1](https://github.com/user-attachments/assets/55e59d51-e0da-4562-879e-ae50adaced33)

https://github.com/user-attachments/assets/f7266dc9-c4a2-4fba-8684-0ead2f678180

## Update 1.2.0
- 🔄 **BREAKING CHANGE**: All parameters consolidated into `LivenessDetectionConfig`
- 🎯 Simplified API - only requires `context` and `config` parameters
- 📚 Updated documentation with migration guide
- 🛠️ Cleaner, more maintainable code structure

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
  flutter_liveness_detection_randomized_plugin: ^1.2.0
```

## Usage 🚀

```dart
final String? response = await FlutterLivenessDetectionRandomizedPlugin.instance.livenessDetection(
  context: context,
  config: LivenessDetectionConfig(
    // Camera & Image Settings
    cameraResolution: ResolutionPreset.medium, // Camera resolution
    imageQuality: 100, // Image quality (0-100)
    isEnableMaxBrightness: true, // Auto brightness adjustment
    
    // Detection Settings
    durationLivenessVerify: 60, // Detection timeout in seconds
    showDurationUiText: false, // Show countdown timer
    startWithInfoScreen: true, // Show tutorial screen
    
    // UI Settings
    isDarkMode: false, // Dark/light theme
    showCurrentStep: true, // Show step counter
    isEnableSnackBar: true, // Show result notifications
    shuffleListWithSmileLast: true, // Randomize challenges with smile last
    
    // Customization
    useCustomizedLabel: false, // Enable custom labels
    customizedLabel: LivenessDetectionLabelModel(
      blink: '', // Empty string to skip challenge
      lookDown: '',
      lookLeft: '',
      lookRight: '',
      lookUp: 'Tengok Atas', // Custom label
      smile: null, // null for default label
    ),
    
    // Security Features
    enableCooldownOnFailure: true, // Enable cooldown after failures
    maxFailedAttempts: 3, // Failed attempts before cooldown
    cooldownMinutes: 10, // Cooldown duration
  ),
);
```

## Configuration Parameters 📋

### Camera & Image Settings
- `cameraResolution`: Camera quality (ResolutionPreset.low/medium/high)
- `imageQuality`: Output image quality 0-100 (default: 100)
- `isEnableMaxBrightness`: Auto brightness adjustment (default: true)

### Detection Settings  
- `durationLivenessVerify`: Detection timeout in seconds (default: 45)
- `showDurationUiText`: Show countdown timer (default: false)
- `startWithInfoScreen`: Show tutorial before detection (default: false)

### UI Settings
- `isDarkMode`: Dark theme mode (default: true)
- `showCurrentStep`: Show current step number (default: false)
- `isEnableSnackBar`: Show success/failure notifications (default: true)
- `shuffleListWithSmileLast`: Randomize challenges with smile at end (default: true)

### Customization
- `useCustomizedLabel`: Enable custom challenge labels (default: false)
- `customizedLabel`: Custom labels for each challenge type

### Security Features
- `enableCooldownOnFailure`: Enable cooldown after failed attempts (default: true)
- `maxFailedAttempts`: Number of failures before cooldown (default: 3)
- `cooldownMinutes`: Cooldown duration in minutes (default: 10)

## Cooldown Feature
The plugin includes an automatic cooldown mechanism to prevent brute force attempts:
- Configurable number of failed attempts before cooldown
- Configurable cooldown duration
- Countdown timer only decreases when app is active
- Cooldown state persists through app restarts
- Users see a countdown screen during cooldown period

## Customized Steps Label
You can customize challenge labels or skip certain challenges:
- Use empty string `''` to skip a challenge
- Use `null` to keep default label
- Provide custom string for personalized labels

## Complete Example 💡

```dart
import 'package:flutter_liveness_detection_randomized_plugin/index.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final result = await FlutterLivenessDetectionRandomizedPlugin.instance.livenessDetection(
                context: context,
                config: LivenessDetectionConfig(
                  startWithInfoScreen: true,
                  isDarkMode: false,
                  showCurrentStep: true,
                  isEnableSnackBar: true,
                ),
              );
              
              if (result != null) {
                // Liveness detection successful
                print('Face captured: $result');
              } else {
                // Detection failed or cancelled
                print('Detection failed');
              }
            },
            child: Text('Start Liveness Detection'),
          ),
        ),
      ),
    );
  }
}
```

## Platform Setup

### Android
Add camera permission to your `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.CAMERA"/>
```
Minimum SDK version: 23

### iOS
Add camera usage description to `ios/Runner/Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required for liveness detection</string>
```

## Migration Guide 🔄

### From v1.0.x to v1.1.0+
All parameters are now consolidated into the `LivenessDetectionConfig` object:

**Before:**
```dart
await plugin.livenessDetection(
  context: context,
  config: LivenessDetectionConfig(...),
  isEnableSnackBar: true,
  shuffleListWithSmileLast: true,
  showCurrentStep: true,
  isDarkMode: false,
);
```

**After:**
```dart
await plugin.livenessDetection(
  context: context,
  config: LivenessDetectionConfig(
    isEnableSnackBar: true,
    shuffleListWithSmileLast: true,
    showCurrentStep: true,
    isDarkMode: false,
    // ... other parameters
  ),
);
```