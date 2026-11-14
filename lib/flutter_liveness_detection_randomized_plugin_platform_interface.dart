import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_liveness_detection_randomized_plugin_method_channel.dart';

abstract class FlutterLivenessDetectionRandomizedPluginPlatform
    extends PlatformInterface {
  /// Constructs a FlutterLivenessDetectionRandomizedPluginPlatform.
  FlutterLivenessDetectionRandomizedPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterLivenessDetectionRandomizedPluginPlatform _instance =
      MethodChannelFlutterLivenessDetectionRandomizedPlugin();

  /// The default instance of [FlutterLivenessDetectionRandomizedPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterLivenessDetectionRandomizedPlugin].
  static FlutterLivenessDetectionRandomizedPluginPlatform get instance =>
      _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterLivenessDetectionRandomizedPluginPlatform] when
  /// they register themselves.
  static set instance(
    FlutterLivenessDetectionRandomizedPluginPlatform instance,
  ) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
