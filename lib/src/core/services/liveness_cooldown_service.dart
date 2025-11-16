import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_liveness_detection_randomized_plugin/src/models/liveness_detection_cooldown.dart';

class LivenessCooldownService {
  static const String _cooldownKey = 'liveness_detection_cooldown';
  int _maxFailedAttempts = 3;
  int _cooldownMinutes = 10;

  static LivenessCooldownService? _instance;
  static LivenessCooldownService get instance {
    _instance ??= LivenessCooldownService._();
    return _instance!;
  }

  LivenessCooldownService._();

  void configure({required int maxFailedAttempts, required int cooldownMinutes}) {
    _maxFailedAttempts = maxFailedAttempts;
    _cooldownMinutes = cooldownMinutes;
  }

  Timer? _cooldownTimer;
  final StreamController<LivenessDetectionCooldown> _cooldownController =
      StreamController<LivenessDetectionCooldown>.broadcast();

  Stream<LivenessDetectionCooldown> get cooldownStream =>
      _cooldownController.stream;

  Future<LivenessDetectionCooldown> getCooldownState() async {
    final prefs = await SharedPreferences.getInstance();
    final cooldownJson = prefs.getString(_cooldownKey);

    if (cooldownJson == null) {
      return const LivenessDetectionCooldown();
    }

    final cooldown = LivenessDetectionCooldown.fromJson(
      jsonDecode(cooldownJson),
    );

    // Check if cooldown has expired
    if (cooldown.isInCooldown &&
        cooldown.remainingCooldownTime.inSeconds <= 0) {
      return await _resetCooldown();
    }

    return cooldown;
  }

  Future<LivenessDetectionCooldown> recordFailedAttempt() async {
    final currentState = await getCooldownState();

    if (currentState.isInCooldown) {
      return currentState;
    }

    final newFailedAttempts = currentState.failedAttempts + 1;

    LivenessDetectionCooldown newState;

    if (newFailedAttempts >= _maxFailedAttempts) {
      // Start cooldown
      final cooldownEndTime = DateTime.now().add(
        Duration(minutes: _cooldownMinutes),
      );

      newState = LivenessDetectionCooldown(
        failedAttempts: newFailedAttempts,
        cooldownEndTime: cooldownEndTime,
        isInCooldown: true,
      );

      _startCooldownTimer(newState);
    } else {
      newState = LivenessDetectionCooldown(
        failedAttempts: newFailedAttempts,
        cooldownEndTime: null,
        isInCooldown: false,
      );
    }

    await _saveCooldownState(newState);
    _cooldownController.add(newState);
    return newState;
  }

  Future<LivenessDetectionCooldown> recordSuccessfulAttempt() async {
    return await _resetCooldown();
  }

  Future<LivenessDetectionCooldown> _resetCooldown() async {
    const newState = LivenessDetectionCooldown();
    await _saveCooldownState(newState);
    _cooldownController.add(newState);
    _cooldownTimer?.cancel();
    return newState;
  }

  Future<void> _saveCooldownState(LivenessDetectionCooldown state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cooldownKey, jsonEncode(state.toJson()));
  }

  void _startCooldownTimer(LivenessDetectionCooldown state) {
    _cooldownTimer?.cancel();

    final remaining = state.remainingCooldownTime;
    if (remaining.inSeconds <= 0) return;

    _cooldownTimer = Timer(remaining, () async {
      await _resetCooldown();
    });
  }

  Future<void> initializeCooldownTimer() async {
    final state = await getCooldownState();
    if (state.isInCooldown && state.remainingCooldownTime.inSeconds > 0) {
      _startCooldownTimer(state);
    }
    _cooldownController.add(state);
  }

  void dispose() {
    _cooldownTimer?.cancel();
    _cooldownController.close();
  }
}
