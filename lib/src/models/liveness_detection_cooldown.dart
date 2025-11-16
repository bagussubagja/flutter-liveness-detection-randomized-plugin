class LivenessDetectionCooldown {
  final int failedAttempts;
  final DateTime? cooldownEndTime;
  final bool isInCooldown;

  const LivenessDetectionCooldown({
    this.failedAttempts = 0,
    this.cooldownEndTime,
    this.isInCooldown = false,
  });

  LivenessDetectionCooldown copyWith({
    int? failedAttempts,
    DateTime? cooldownEndTime,
    bool? isInCooldown,
  }) {
    return LivenessDetectionCooldown(
      failedAttempts: failedAttempts ?? this.failedAttempts,
      cooldownEndTime: cooldownEndTime ?? this.cooldownEndTime,
      isInCooldown: isInCooldown ?? this.isInCooldown,
    );
  }

  Duration get remainingCooldownTime {
    if (cooldownEndTime == null || !isInCooldown) {
      return Duration.zero;
    }
    final remaining = cooldownEndTime!.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  Map<String, dynamic> toJson() {
    return {
      'failedAttempts': failedAttempts,
      'cooldownEndTime': cooldownEndTime?.millisecondsSinceEpoch,
      'isInCooldown': isInCooldown,
    };
  }

  factory LivenessDetectionCooldown.fromJson(Map<String, dynamic> json) {
    return LivenessDetectionCooldown(
      failedAttempts: json['failedAttempts'] ?? 0,
      cooldownEndTime: json['cooldownEndTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['cooldownEndTime'])
          : null,
      isInCooldown: json['isInCooldown'] ?? false,
    );
  }
}