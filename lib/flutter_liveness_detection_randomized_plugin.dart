import 'package:flutter_liveness_detection_randomized_plugin/index.dart';

class FlutterLivenessDetectionRandomizedPlugin {
  FlutterLivenessDetectionRandomizedPlugin._privateConstructor();
  static final FlutterLivenessDetectionRandomizedPlugin instance =
      FlutterLivenessDetectionRandomizedPlugin._privateConstructor();
  final List<LivenessDetectionThreshold> _thresholds = [];

  List<LivenessDetectionThreshold> get thresholdConfig {
    return _thresholds;
  }

  Future<String?> livenessDetection({
    required BuildContext context,
    required LivenessDetectionConfig config,
  }) async {
    if (config.enableCooldownOnFailure) {
      LivenessCooldownService.instance.configure(
        maxFailedAttempts: config.maxFailedAttempts,
        cooldownMinutes: config.cooldownMinutes,
      );
      final cooldownState = await LivenessCooldownService.instance.getCooldownState();
      if (cooldownState.isInCooldown && context.mounted) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LivenessCooldownWidget(
              cooldownState: cooldownState,
              isDarkMode: config.isDarkMode,
              maxFailedAttempts: config.maxFailedAttempts,
            ),
          ),
        );
        return null;
      }
    }

    if (!context.mounted) return null;
    
    final String? capturedFacePath = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LivenessDetectionView(
          config: config,
        ),
      ),
    );

    if (config.enableCooldownOnFailure) {
      if (capturedFacePath != null) {
        await LivenessCooldownService.instance.recordSuccessfulAttempt();
      } else {
        await LivenessCooldownService.instance.recordFailedAttempt();
      }
    }

    return capturedFacePath;
  }

  Future<String?> getPlatformVersion() {
    return FlutterLivenessDetectionRandomizedPluginPlatform.instance
        .getPlatformVersion();
  }
}
