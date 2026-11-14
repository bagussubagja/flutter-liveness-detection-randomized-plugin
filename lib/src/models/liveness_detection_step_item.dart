import 'package:flutter_liveness_detection_randomized_plugin/index.dart';

class LivenessDetectionStepItem {
  final LivenessDetectionStep step;
  final String title;
  final double? thresholdToCheck;

  LivenessDetectionStepItem({
    required this.step,
    required this.title,
    this.thresholdToCheck,
  });

  LivenessDetectionStepItem copyWith({
    LivenessDetectionStep? step,
    String? title,
    double? thresholdToCheck,
  }) {
    return LivenessDetectionStepItem(
      step: step ?? this.step,
      title: title ?? this.title,
      thresholdToCheck: thresholdToCheck ?? this.thresholdToCheck,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'step': step.index});
    result.addAll({'title': title});
    if (thresholdToCheck != null) {
      result.addAll({'thresholdToCheck': thresholdToCheck});
    }

    return result;
  }

  factory LivenessDetectionStepItem.fromMap(Map<String, dynamic> map) {
    return LivenessDetectionStepItem(
      step: LivenessDetectionStep.values[map['step'] ?? 0],
      title: map['title'] ?? '',
      thresholdToCheck: map['thresholdToCheck']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory LivenessDetectionStepItem.fromJson(String source) =>
      LivenessDetectionStepItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Liveness Detection (step: $step, title: $title, thresholdToCheck: $thresholdToCheck)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LivenessDetectionStepItem &&
        other.step == step &&
        other.title == title &&
        other.thresholdToCheck == thresholdToCheck;
  }

  @override
  int get hashCode {
    return step.hashCode ^ title.hashCode ^ thresholdToCheck.hashCode;
  }
}
