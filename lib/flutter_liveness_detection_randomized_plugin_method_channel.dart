import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_liveness_detection_randomized_plugin_platform_interface.dart';

/// An implementation of [FlutterLivenessDetectionRandomizedPluginPlatform] that uses method channels.
class MethodChannelFlutterLivenessDetectionRandomizedPlugin
    extends FlutterLivenessDetectionRandomizedPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel(
    'flutter_liveness_detection_randomized_plugin',
  );

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
