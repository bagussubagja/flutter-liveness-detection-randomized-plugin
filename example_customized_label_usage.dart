// Example of correct customizedLabel usage

// ignore_for_file: unused_local_variable

import 'package:flutter_liveness_detection_randomized_plugin/index.dart';

void exampleUsage() {
  // ✅ CORRECT: Skip blink and lookDown, use custom labels for others
  final config1 = LivenessDetectionConfig(
    useCustomizedLabel: true,
    customizedLabel: LivenessDetectionLabelModel(
      blink: '', // Empty string = skip this challenge
      lookUp: 'Tengok Atas', // Custom label
      lookDown: '', // Empty string = skip this challenge
      lookLeft: null, // null = use default label "Look LEFT"
      lookRight: null, // null = use default label "Look RIGHT"
      smile: 'Senyum Dong!', // Custom label
    ),
  );
  // Result: Only lookUp, lookLeft, lookRight, smile challenges will appear

  // ✅ CORRECT: Use all challenges with custom labels
  final config2 = LivenessDetectionConfig(
    useCustomizedLabel: true,
    customizedLabel: LivenessDetectionLabelModel(
      blink: 'Kedipkan Mata',
      lookUp: 'Lihat Atas',
      lookDown: 'Lihat Bawah',
      lookLeft: 'Lihat Kiri',
      lookRight: 'Lihat Kanan',
      smile: 'Tersenyum',
    ),
  );
  // Result: All 6 challenges with Indonesian labels

  // ✅ CORRECT: Mix of custom, default, and skipped
  final config3 = LivenessDetectionConfig(
    useCustomizedLabel: true,
    customizedLabel: LivenessDetectionLabelModel(
      blink: null, // Use default "Blink 2-3 Times"
      lookUp: '', // Skip
      lookDown: '', // Skip
      lookLeft: 'Turn Left Please',
      lookRight: 'Turn Right Please',
      smile: null, // Use default "Smile"
    ),
  );
  // Result: Only blink, lookLeft, lookRight, smile challenges

  // ❌ WRONG: This will throw assertion error
  // final configWrong = LivenessDetectionConfig(
  //   useCustomizedLabel: true,
  //   customizedLabel: null, // ERROR: Cannot be null when useCustomizedLabel is true
  // );

  // ✅ CORRECT: Use default behavior
  final config4 = LivenessDetectionConfig(
    useCustomizedLabel: false, // customizedLabel will be ignored
    shuffleListWithSmileLast: true, // This works with default steps
  );
}
