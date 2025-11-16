import 'package:flutter_liveness_detection_randomized_plugin/index.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: HomeView()),
  );
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<String?> capturedImages = [];
  String? imgPath;
  int livenessScenario = 0;
  final int totalScenarios = 8;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(12),
          children: [
            if (imgPath != null) ...[
              const Text(
                'Result Liveness Detection',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Align(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(File(imgPath!), fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            Text(
              'Liveness Scenario ${livenessScenario + 1}/$totalScenarios',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _getScenarioDescription(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt_rounded),
              onPressed: () async {
                final config = _getTestConfig();
                final String? response =
                    await FlutterLivenessDetectionRandomizedPlugin.instance
                        .livenessDetection(context: context, config: config);
                if (mounted) {
                  setState(() {
                    imgPath = response;
                  });
                }
              },
              label: const Text('Start Liveness Detection'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  livenessScenario = (livenessScenario + 1) % totalScenarios;
                });
              },
              child: const Text('Next Liveness Scenario'),
            ),
          ],
        ),
      ),
    );
  }

  String _getScenarioDescription() {
    switch (livenessScenario) {
      case 0:
        return 'Default: Smile always last + Info screen';
      case 1:
        return 'Random shuffle: No smile priority';
      case 2:
        return 'Dark mode + High resolution + No info';
      case 3:
        return 'Custom labels: All steps with Indonesian';
      case 4:
        return 'Skip steps: Only 3 challenges (blink, smile, lookUp)';
      case 5:
        return 'Low quality + Duration timer + Cooldown enabled';
      case 6:
        return 'Max brightness off + No snackbar + Hide steps';
      case 7:
        return 'All features: Custom + Timer + Cooldown + Dark';
      default:
        return '';
    }
  }

  LivenessDetectionConfig _getTestConfig() {
    switch (livenessScenario) {
      case 0: // Default scenario
        return LivenessDetectionConfig(
          cameraResolution: ResolutionPreset.medium,
          imageQuality: 100,
          isEnableMaxBrightness: true,
          durationLivenessVerify: 45,
          showDurationUiText: false,
          startWithInfoScreen: true,
          useCustomizedLabel: false,
          enableCooldownOnFailure: false,
          isEnableSnackBar: true,
          shuffleListWithSmileLast: true,
          isDarkMode: false,
          showCurrentStep: true,
        );
      case 1: // Random shuffle
        return LivenessDetectionConfig(
          cameraResolution: ResolutionPreset.medium,
          imageQuality: 85,
          isEnableMaxBrightness: true,
          durationLivenessVerify: 30,
          showDurationUiText: false,
          startWithInfoScreen: false,
          useCustomizedLabel: false,
          enableCooldownOnFailure: false,
          isEnableSnackBar: true,
          shuffleListWithSmileLast: false,
          isDarkMode: false,
          showCurrentStep: true,
        );
      case 2: // Dark mode + High res
        return LivenessDetectionConfig(
          cameraResolution: ResolutionPreset.high,
          imageQuality: 100,
          isEnableMaxBrightness: true,
          durationLivenessVerify: 60,
          showDurationUiText: false,
          startWithInfoScreen: false,
          useCustomizedLabel: false,
          enableCooldownOnFailure: false,
          isEnableSnackBar: true,
          shuffleListWithSmileLast: true,
          isDarkMode: true,
          showCurrentStep: true,
        );
      case 3: // Custom labels Indonesian
        return LivenessDetectionConfig(
          cameraResolution: ResolutionPreset.medium,
          imageQuality: 90,
          isEnableMaxBrightness: true,
          durationLivenessVerify: 45,
          showDurationUiText: false,
          startWithInfoScreen: true,
          useCustomizedLabel: true,
          enableCooldownOnFailure: false,
          isEnableSnackBar: true,
          shuffleListWithSmileLast: true,
          isDarkMode: false,
          showCurrentStep: true,
          customizedLabel: LivenessDetectionLabelModel(
            blink: 'Kedip 2-3 Kali',
            lookDown: 'Lihat ke Bawah',
            lookLeft: 'Lihat ke Kiri',
            lookRight: 'Lihat ke Kanan',
            lookUp: 'Lihat ke Atas',
            smile: 'Tersenyum Lebar',
          ),
        );
      case 4: // Skip some steps
        return LivenessDetectionConfig(
          cameraResolution: ResolutionPreset.low,
          imageQuality: 70,
          isEnableMaxBrightness: true,
          durationLivenessVerify: 30,
          showDurationUiText: false,
          startWithInfoScreen: false,
          useCustomizedLabel: true,
          enableCooldownOnFailure: false,
          isEnableSnackBar: true,
          shuffleListWithSmileLast: false,
          isDarkMode: false,
          showCurrentStep: true,
          customizedLabel: LivenessDetectionLabelModel(
            blink: 'Blink Eyes',
            lookDown: '', // Skip
            lookLeft: '', // Skip
            lookRight: '', // Skip
            lookUp: 'Look Up Please',
            smile: 'Smile Wide',
          ),
        );
      case 5: // Low quality + Timer + Cooldown
        return LivenessDetectionConfig(
          cameraResolution: ResolutionPreset.low,
          imageQuality: 50,
          isEnableMaxBrightness: true,
          durationLivenessVerify: 20,
          showDurationUiText: true,
          startWithInfoScreen: true,
          useCustomizedLabel: false,
          enableCooldownOnFailure: true,
          maxFailedAttempts: 2,
          cooldownMinutes: 5,
          isEnableSnackBar: true,
          shuffleListWithSmileLast: true,
          isDarkMode: false,
          showCurrentStep: true,
        );
      case 6: // Minimal features
        return LivenessDetectionConfig(
          cameraResolution: ResolutionPreset.medium,
          imageQuality: 80,
          isEnableMaxBrightness: false,
          durationLivenessVerify: 40,
          showDurationUiText: false,
          startWithInfoScreen: false,
          useCustomizedLabel: false,
          enableCooldownOnFailure: false,
          isEnableSnackBar: false,
          shuffleListWithSmileLast: false,
          isDarkMode: false,
          showCurrentStep: false,
        );
      case 7: // All features enabled
        return LivenessDetectionConfig(
          cameraResolution: ResolutionPreset.high,
          imageQuality: 95,
          isEnableMaxBrightness: true,
          durationLivenessVerify: 50,
          showDurationUiText: true,
          startWithInfoScreen: true,
          useCustomizedLabel: true,
          enableCooldownOnFailure: true,
          maxFailedAttempts: 3,
          cooldownMinutes: 10,
          isEnableSnackBar: true,
          shuffleListWithSmileLast: true,
          isDarkMode: true,
          showCurrentStep: true,
          customizedLabel: LivenessDetectionLabelModel(
            blink: '👁️ Kedipkan Mata',
            lookDown: '⬇️ Lihat Bawah',
            lookLeft: '⬅️ Lihat Kiri',
            lookRight: '➡️ Lihat Kanan',
            lookUp: '⬆️ Lihat Atas',
            smile: '😊 Senyum Manis',
          ),
        );
      default:
        return LivenessDetectionConfig();
    }
  }
}
