import 'package:flutter_liveness_detection_randomized_plugin/index.dart';

class LivenessDetectionTutorialScreen extends StatefulWidget {
  final VoidCallback onStartTap;
  final bool isDarkMode;
  final String locale;
  const LivenessDetectionTutorialScreen({super.key, required this.onStartTap, this.isDarkMode = false, required this.locale});

  @override
  State<LivenessDetectionTutorialScreen> createState() => _LivenessDetectionTutorialScreenState();
}

class _LivenessDetectionTutorialScreenState extends State<LivenessDetectionTutorialScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
      body: SafeArea(
        minimum: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            const SizedBox(
              height: 16,
            ),
            Text(
              widget.locale == "en" ? 'Liveness Detection - Tutorial' : "Tutorial Deteksi Aktifitas",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: widget.isDarkMode ? Colors.black87 : Colors.white,
                boxShadow: !widget.isDarkMode
                    ? [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Text(
                      '1',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: widget.isDarkMode ? Colors.white : Colors.black),
                    ),
                    subtitle: Text(
                      widget.locale == "en"
                          ? "Make sure you are in an area that has sufficient lighting and that your ears are not covered by anything"
                          : "Pastikan anda berada di area yang memiliki cahaya yang cukup dan kedua telinga anda tidak tertutup apa pun",
                      style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black),
                    ),
                    title: Text(
                      widget.locale == "en" ? "Sufficient Lighting" : "Pencahayaan yang cukup0",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: widget.isDarkMode ? Colors.white : Colors.black),
                    ),
                  ),
                  ListTile(
                    leading: Text(
                      '2',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: widget.isDarkMode ? Colors.white : Colors.black),
                    ),
                    subtitle: Text(
                      widget.locale == "en" ? "Hold the phone at eye level and look straight at the camera" : "Pegang perangkat sejajar dengan tinggi mata dan lihat lurus kedepan ke arah kamera",
                      style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black),
                    ),
                    title: Text(
                      widget.locale == "en" ? "Straight Ahead View" : "Pandangan Lurus Kedepan",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: widget.isDarkMode ? Colors.white : Colors.black),
                    ),
                  ),
                  ListTile(
                    leading: Text(
                      '3',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: widget.isDarkMode ? Colors.white : Colors.black),
                    ),
                    subtitle: Text(
                      widget.locale == "en"
                          ? "The time limit given for the liveness detection system verification process is 45 seconds"
                          : "Batas waktu yang diberikan untuk proses verifikasi sistem deteksi keaktifan adalah 45 detik",
                      style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black),
                    ),
                    title: Text(
                      widget.locale == "en" ? "Time Limit Verification" : "Verifikasi Batas Waktu",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: widget.isDarkMode ? Colors.white : Colors.black),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.isDarkMode ? Colors.black87 : Colors.white,
                foregroundColor: widget.isDarkMode ? Colors.white : Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.camera_alt_outlined),
              onPressed: () => widget.onStartTap(),
              label: Text(
                widget.locale == "en" ? "Start the Liveness Detection System" : "Mulai Sistem Deteksi Keaktifan",
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Spacer(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: Colors.grey,
                  size: 15,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Package Version: 1.0.3',
                  style: TextStyle(color: Colors.grey),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
