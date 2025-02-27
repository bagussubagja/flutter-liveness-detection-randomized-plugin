import 'package:flutter_liveness_detection_randomized_plugin/index.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeView(),
  ));
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<String?> capturedImages = [];
  String? imgPath;

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
            const SizedBox(
              height: 12,
            ),
            Align(
              child: SizedBox(
                height: 100,
                width: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    File(imgPath!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
          ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt_rounded),
              onPressed: () async {
                final String? response = await FlutterLivenessDetectionRandomizedPlugin.instance.livenessDetection(
                  showCurrentStep: true,
                  context: context,
                  shuffleListWithSmileLast: false,
                  isEnableSnackBar: true,
                  isDarkMode: false,
                  config: LivenessDetectionConfig(
                    startWithInfoScreen: true,
                  ),
                );
                if (mounted) {
                  setState(() {
                    imgPath = response;
                  });
                }
              },
              label: const Text('Liveness Detection System')),
        ],
      )),
    );
  }
}
