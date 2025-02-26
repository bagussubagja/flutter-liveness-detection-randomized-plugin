import 'package:flutter/cupertino.dart';
import 'package:flutter_liveness_detection_randomized_plugin/index.dart';
import 'package:flutter_liveness_detection_randomized_plugin/src/presentation/widgets/circular_progress_widget/circular_progress_widget.dart';
import 'package:lottie/lottie.dart';

class LivenessDetectionStepOverlayWidget extends StatefulWidget {
  final List<LivenessDetectionStepItem> steps;
  final VoidCallback onCompleted;
  final Widget camera;
  final bool isFaceDetected;
  final bool showCurrentStep;
  final bool isDarkMode;
  final String locale;

  const LivenessDetectionStepOverlayWidget(
      {super.key, required this.steps, required this.onCompleted, required this.camera, required this.isFaceDetected, this.showCurrentStep = false, this.isDarkMode = true, required this.locale});

  @override
  State<LivenessDetectionStepOverlayWidget> createState() => LivenessDetectionStepOverlayWidgetState();
}

class LivenessDetectionStepOverlayWidgetState extends State<LivenessDetectionStepOverlayWidget> {
  int get currentIndex => _currentIndex;
  String locale = "id";
  bool _isLoading = false;
  int _currentIndex = 0;
  double _currentStepIndicator = 0;
  late final PageController _pageController;
  late CircularProgressWidget _circularProgressWidget;

  static const double _indicatorMaxStep = 100;
  static const double _stepIncrement = 16.67;
  static const double _heightLine = 25;

  String get stepCounter => "$_currentIndex/${widget.steps.length}";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeControllers();
      // locale = locale;
      setState(() {});
    });
    // print('showCurrentStep ${widget.showCurrentStep}');
  }

  void _initializeControllers() {
    _pageController = PageController(initialPage: 0);
    _circularProgressWidget = _buildCircularIndicator();
  }

  CircularProgressWidget _buildCircularIndicator() {
    return CircularProgressWidget(
      unselectedColor: Colors.grey,
      selectedColor: Colors.green,
      heightLine: _heightLine,
      current: _currentStepIndicator,
      maxStep: _indicatorMaxStep,
      child: widget.camera,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> nextPage() async {
    if (_isLoading) return;

    if (_currentIndex + 1 <= widget.steps.length - 1) {
      await _handleNextStep();
    } else {
      await _handleCompletion();
    }
  }

  Future<void> _handleNextStep() async {
    _showLoader();
    await Future.delayed(const Duration(milliseconds: 100));
    await _pageController.nextPage(
      duration: const Duration(milliseconds: 1),
      curve: Curves.easeIn,
    );
    await Future.delayed(const Duration(seconds: 1));
    _hideLoader();
    _updateState();
  }

  Future<void> _handleCompletion() async {
    _updateState();
    await Future.delayed(const Duration(milliseconds: 500));
    widget.onCompleted();
  }

  void _updateState() {
    setState(() {
      _currentIndex++;
      _currentStepIndicator += _stepIncrement;
      _circularProgressWidget = _buildCircularIndicator();
    });
  }

  void reset() {
    _pageController.jumpToPage(0);
    setState(() {
      _currentIndex = 0;
      _currentStepIndicator = 0;
      _circularProgressWidget = _buildCircularIndicator();
    });
  }

  void _showLoader() => setState(() => _isLoading = true);
  void _hideLoader() => setState(() => _isLoading = false);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(16),
      child: Container(
        margin: const EdgeInsets.all(12),
        height: double.infinity,
        width: double.infinity,
        color: Colors.transparent,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: widget.showCurrentStep
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          locale == "en" ? 'Back' : "Kembali",
                          style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black),
                        ),
                        Text(
                          stepCounter,
                          style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black),
                        )
                      ],
                    )
                  : Text(locale == "en" ? 'Back' : "Kembali", style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black)),
            ),
            _buildBody(),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        _buildCircularCamera(),
        const SizedBox(height: 16),
        _buildFaceDetectionStatus(),
        const SizedBox(height: 16),
        _buildStepPageView(),
        const SizedBox(height: 16),
        widget.isDarkMode ? _buildLoaderDarkMode() : _buildLoaderLightMode(),
      ],
    );
  }

  Widget _buildCircularCamera() {
    return SizedBox(
      height: 300,
      width: 300,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(1000),
        child: _circularProgressWidget,
      ),
    );
  }

  Widget _buildFaceDetectionStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          child: widget.isDarkMode
              ? LottieBuilder.asset(
                  widget.isFaceDetected
                      ? 'packages/flutter_liveness_detection_randomized_plugin/src/core/assets/face-detected.json'
                      : 'packages/flutter_liveness_detection_randomized_plugin/src/core/assets/face-id-anim.json',
                  height: widget.isFaceDetected ? 32 : 22,
                  width: widget.isFaceDetected ? 32 : 22,
                )
              : ColorFiltered(
                  colorFilter: ColorFilter.mode(widget.isFaceDetected ? Colors.green : Colors.black, BlendMode.modulate),
                  child: LottieBuilder.asset(
                    widget.isFaceDetected
                        ? 'packages/flutter_liveness_detection_randomized_plugin/src/core/assets/face-detected.json'
                        : 'packages/flutter_liveness_detection_randomized_plugin/src/core/assets/face-id-anim.json',
                    height: widget.isFaceDetected ? 32 : 22,
                    width: widget.isFaceDetected ? 32 : 22,
                  )),
        ),
        const SizedBox(width: 16),
        Text(
          widget.isFaceDetected
              ? locale == "en"
                  ? 'User Face Found'
                  : "Wajah Pengguna Ditemukan"
              : locale == "en"
                  ? 'User Face Not Found...'
                  : "Wajah Pengguna Tidak Ditemukan...",
          style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black),
        ),
      ],
    );
  }

  Widget _buildStepPageView() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 10,
      width: MediaQuery.of(context).size.width,
      child: AbsorbPointer(
        absorbing: true,
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.steps.length,
          itemBuilder: _buildStepItem,
        ),
      ),
    );
  }

  Widget _buildStepItem(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: widget.isDarkMode ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 30),
        padding: const EdgeInsets.all(10),
        child: Text(
          widget.steps[index].title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: widget.isDarkMode ? Colors.white : Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildLoaderDarkMode() {
    return Center(
      child: CupertinoActivityIndicator(
        color: !_isLoading ? Colors.transparent : Colors.white,
      ),
    );
  }

  Widget _buildLoaderLightMode() {
    return Center(
      child: CupertinoActivityIndicator(
        color: _isLoading ? Colors.transparent : Colors.white,
      ),
    );
  }
}
