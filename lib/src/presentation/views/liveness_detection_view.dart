// ignore_for_file: depend_on_referenced_packages
import 'package:flutter_liveness_detection_randomized_plugin/index.dart';
import 'package:flutter_liveness_detection_randomized_plugin/src/core/constants/liveness_detection_step_constant.dart';
import 'package:collection/collection.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

List<CameraDescription> availableCams = [];

class LivenessDetectionView extends StatefulWidget {
  final LivenessDetectionConfig config;

  const LivenessDetectionView({
    super.key,
    required this.config,
  });

  @override
  State<LivenessDetectionView> createState() => _LivenessDetectionScreenState();
}

class _LivenessDetectionScreenState extends State<LivenessDetectionView> {
  // Camera related variables
  CameraController? _cameraController;
  int _cameraIndex = 0;
  bool _isBusy = false;
  bool _isTakingPicture = false;
  Timer? _timerToDetectFace;

  // Detection state variables
  late bool _isInfoStepCompleted;
  bool _isProcessingStep = false;
  bool _faceDetectedState = false;
  List<LivenessDetectionStepItem> _shuffledSteps = [];

  // Brightness Screen
  Future<void> setApplicationBrightness(double brightness) async {
    try {
      await ScreenBrightness.instance.setApplicationScreenBrightness(
        brightness,
      );
    } catch (e) {
      throw 'Failed to set application brightness';
    }
  }

  Future<void> resetApplicationBrightness() async {
    try {
      await ScreenBrightness.instance.resetApplicationScreenBrightness();
    } catch (e) {
      throw 'Failed to reset application brightness';
    }
  }

  // Steps related variables
  late final List<LivenessDetectionStepItem> steps;
  final GlobalKey<LivenessDetectionStepOverlayWidgetState> _stepsKey =
      GlobalKey<LivenessDetectionStepOverlayWidgetState>();

  static void shuffleListLivenessChallenge({
    required List<LivenessDetectionStepItem> list,
    required bool isSmileLast,
  }) {
    if (isSmileLast) {
      int? smileIndex = list.indexWhere(
        (item) => item.step == LivenessDetectionStep.smile,
      );

      if (smileIndex != -1) {
        LivenessDetectionStepItem smileItem = list.removeAt(smileIndex);
        list.shuffle(Random());
        list.add(smileItem);
      } else {
        list.shuffle(Random());
      }
    } else {
      list.shuffle(Random());
    }
  }

  Future<XFile?> _compressImage(XFile originalFile) async {
    final int quality = widget.config.imageQuality;

    if (quality >= 100) {
      return originalFile;
    }

    try {
      final bytes = await originalFile.readAsBytes();

      final img.Image? originalImage = img.decodeImage(bytes);
      if (originalImage == null) {
        return originalFile;
      }

      final tempDir = await getTemporaryDirectory();
      final String targetPath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      final compressedBytes = img.encodeJpg(originalImage, quality: quality);

      final File compressedFile = await File(
        targetPath,
      ).writeAsBytes(compressedBytes);

      return XFile(compressedFile.path);
    } catch (e) {
      debugPrint("Error compressing image: $e");
      return originalFile;
    }
  }

  List<T> manualRandomItemLiveness<T>(List<T> list) {
    final random = Random();
    List<T> shuffledList = List.from(list);
    for (int i = shuffledList.length - 1; i > 0; i--) {
      int j = random.nextInt(i + 1);

      T temp = shuffledList[i];
      shuffledList[i] = shuffledList[j];
      shuffledList[j] = temp;
    }
    return shuffledList;
  }

  List<LivenessDetectionStepItem> customizedLivenessLabel(
    LivenessDetectionLabelModel label,
  ) {
    List<LivenessDetectionStepItem> customizedSteps = [];

    // Add blink step if not explicitly skipped (empty string skips)
    if (label.blink != "") {
      customizedSteps.add(
        LivenessDetectionStepItem(
          step: LivenessDetectionStep.blink,
          title: label.blink ?? "Blink 2-3 Times",
        ),
      );
    }

    // Add lookRight step if not explicitly skipped
    if (label.lookRight != "") {
      customizedSteps.add(
        LivenessDetectionStepItem(
          step: LivenessDetectionStep.lookRight,
          title: label.lookRight ?? "Look RIGHT",
        ),
      );
    }

    // Add lookLeft step if not explicitly skipped
    if (label.lookLeft != "") {
      customizedSteps.add(
        LivenessDetectionStepItem(
          step: LivenessDetectionStep.lookLeft,
          title: label.lookLeft ?? "Look LEFT",
        ),
      );
    }

    // Add lookUp step if not explicitly skipped
    if (label.lookUp != "") {
      customizedSteps.add(
        LivenessDetectionStepItem(
          step: LivenessDetectionStep.lookUp,
          title: label.lookUp ?? "Look UP",
        ),
      );
    }

    // Add lookDown step if not explicitly skipped
    if (label.lookDown != "") {
      customizedSteps.add(
        LivenessDetectionStepItem(
          step: LivenessDetectionStep.lookDown,
          title: label.lookDown ?? "Look DOWN",
        ),
      );
    }

    // Add smile step if not explicitly skipped
    if (label.smile != "") {
      customizedSteps.add(
        LivenessDetectionStepItem(
          step: LivenessDetectionStep.smile,
          title: label.smile ?? "Smile",
        ),
      );
    }

    return customizedSteps;
  }

  @override
  void initState() {
    _preInitCallBack();
    super.initState();
    if (widget.config.enableCooldownOnFailure) {
      LivenessCooldownService.instance.configure(
        maxFailedAttempts: widget.config.maxFailedAttempts,
        cooldownMinutes: widget.config.cooldownMinutes,
      );
      LivenessCooldownService.instance.initializeCooldownTimer();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _postFrameCallBack());
  }

  @override
  void dispose() {
    _timerToDetectFace?.cancel();
    _timerToDetectFace = null;
    _cameraController?.dispose();
    
    if (widget.config.isEnableMaxBrightness) {
      resetApplicationBrightness();
    }
    super.dispose();
  }

  void _preInitCallBack() {
    _isInfoStepCompleted = !widget.config.startWithInfoScreen;
    
    // Initialize and shuffle steps fresh each time
    _initializeShuffledSteps();
    
    if (widget.config.isEnableMaxBrightness) {
      setApplicationBrightness(1.0);
    }
  }

  void _postFrameCallBack() async {
    availableCams = await availableCameras();
    if (availableCams.any(
      (element) =>
          element.lensDirection == CameraLensDirection.front &&
          element.sensorOrientation == 90,
    )) {
      _cameraIndex = availableCams.indexOf(
        availableCams.firstWhere(
          (element) =>
              element.lensDirection == CameraLensDirection.front &&
              element.sensorOrientation == 90,
        ),
      );
    } else {
      _cameraIndex = availableCams.indexOf(
        availableCams.firstWhere(
          (element) => element.lensDirection == CameraLensDirection.front,
        ),
      );
    }
    if (!widget.config.startWithInfoScreen) {
      _startLiveFeed();
    }

    // Steps are shuffled fresh in _preInitCallBack
  }

  void _startLiveFeed() async {
    final camera = availableCams[_cameraIndex];
    _cameraController = CameraController(
      camera,
      widget.config.cameraResolution,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    _cameraController?.initialize().then((_) {
      if (!mounted) return;
      _cameraController?.startImageStream(_processCameraImage);
      setState(() {});
    });
    _startFaceDetectionTimer();
  }

  void _startFaceDetectionTimer() {
    _timerToDetectFace = Timer(
      Duration(seconds: widget.config.durationLivenessVerify ?? 45),
      () => _onDetectionCompleted(imgToReturn: null),
    );
  }

  Future<void> _processCameraImage(CameraImage cameraImage) async {
    final camera = availableCams[_cameraIndex];
    final imageRotation = InputImageRotationValue.fromRawValue(
      camera.sensorOrientation,
    );
    if (imageRotation == null) return;

    InputImage? inputImage;

    if (Platform.isAndroid) {
      if (cameraImage.format.group == ImageFormatGroup.nv21) {
        inputImage = InputImage.fromBytes(
          bytes: cameraImage.planes[0].bytes,
          metadata: InputImageMetadata(
            size: Size(
              cameraImage.width.toDouble(),
              cameraImage.height.toDouble(),
            ),
            rotation: imageRotation,
            format: InputImageFormat.nv21,
            bytesPerRow: cameraImage.planes[0].bytesPerRow,
          ),
        );
      }
    } else if (Platform.isIOS) {
      if (cameraImage.format.group == ImageFormatGroup.bgra8888) {
        inputImage = InputImage.fromBytes(
          bytes: cameraImage.planes[0].bytes,
          metadata: InputImageMetadata(
            size: Size(
              cameraImage.width.toDouble(),
              cameraImage.height.toDouble(),
            ),
            rotation: imageRotation,
            format: InputImageFormat.bgra8888,
            bytesPerRow: cameraImage.planes[0].bytesPerRow,
          ),
        );
      }
    }

    if (inputImage != null) {
      _processImage(inputImage);
    }
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (_isBusy) return;
    _isBusy = true;

    final faces = await MachineLearningKitHelper.instance.processInputImage(
      inputImage,
    );

    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      if (faces.isEmpty) {
        _resetSteps();
        if (mounted) setState(() => _faceDetectedState = false);
      } else {
        if (mounted) setState(() => _faceDetectedState = true);
        final currentIndex = _stepsKey.currentState?.currentIndex ?? 0;
        List<LivenessDetectionStepItem> currentSteps = _getStepsToUse();
        if (currentIndex < currentSteps.length) {
          _detectFace(
            face: faces.first,
            step: currentSteps[currentIndex].step,
          );
        }
      }
    } else {
      _resetSteps();
    }

    _isBusy = false;
    if (mounted) setState(() {});
  }

  void _detectFace({
    required Face face,
    required LivenessDetectionStep step,
  }) async {
    if (_isProcessingStep) return;

    debugPrint('Current Step: $step');

    switch (step) {
      case LivenessDetectionStep.blink:
        await _handlingBlinkStep(face: face, step: step);
        break;

      case LivenessDetectionStep.lookRight:
        await _handlingTurnRight(face: face, step: step);
        break;

      case LivenessDetectionStep.lookLeft:
        await _handlingTurnLeft(face: face, step: step);
        break;

      case LivenessDetectionStep.lookUp:
        await _handlingLookUp(face: face, step: step);
        break;

      case LivenessDetectionStep.lookDown:
        await _handlingLookDown(face: face, step: step);
        break;

      case LivenessDetectionStep.smile:
        await _handlingSmile(face: face, step: step);
        break;
    }
  }

  Future<void> _completeStep({required LivenessDetectionStep step}) async {
    if (mounted) setState(() {});
    await _stepsKey.currentState?.nextPage();
    _stopProcessing();
  }

  void _takePicture() async {
    try {
      if (_cameraController == null || _isTakingPicture) return;

      if (mounted) setState(() => _isTakingPicture = true);
      await _cameraController?.stopImageStream();

      final XFile? clickedImage = await _cameraController?.takePicture();
      if (clickedImage == null) {
        _startLiveFeed();
        if (mounted) setState(() => _isTakingPicture = false);
        return;
      }

      final XFile? finalImage = await _compressImage(clickedImage);

      debugPrint('Final image path: ${finalImage?.path}');
      _onDetectionCompleted(imgToReturn: finalImage);
    } catch (e) {
      debugPrint('Error taking picture: $e');
      if (mounted) setState(() => _isTakingPicture = false);
      _startLiveFeed();
    }
  }

  void _onDetectionCompleted({XFile? imgToReturn}) async {
    final String? imgPath = imgToReturn?.path;

    if (imgPath != null) {
      final File imageFile = File(imgPath);
      final int fileSizeInBytes = await imageFile.length();
      final double sizeInKb = fileSizeInBytes / 1024;
      debugPrint('Image result size : ${sizeInKb.toStringAsFixed(2)} KB');
    }
    if (widget.config.isEnableSnackBar) {
      final snackBar = SnackBar(
        content: Text(
          imgToReturn == null
              ? 'Verification of liveness detection failed, please try again. (Exceeds time limit ${widget.config.durationLivenessVerify ?? 45} second.)'
              : 'Verification of liveness detection success!',
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    if (!mounted) return;
    Navigator.of(context).pop(imgPath);
  }

  void _resetSteps() {
    List<LivenessDetectionStepItem> currentSteps = _getStepsToUse();
    
    for (var step in currentSteps) {
      final index = currentSteps.indexWhere((p1) => p1.step == step.step);
      if (index != -1) {
        currentSteps[index] = currentSteps[index].copyWith();
      }
    }
    
    if (_stepsKey.currentState?.currentIndex != 0) {
      _stepsKey.currentState?.reset();
    }
    
    if (mounted) setState(() {});
  }

  void _startProcessing() {
    if (!mounted) return;
    if (mounted) setState(() => _isProcessingStep = true);
  }

  void _stopProcessing() {
    if (!mounted) return;
    if (mounted) setState(() => _isProcessingStep = false);
  }

  /// Initialize and shuffle steps fresh each time
  void _initializeShuffledSteps() {
    List<LivenessDetectionStepItem> baseSteps;
    
    if (widget.config.useCustomizedLabel && widget.config.customizedLabel != null) {
      baseSteps = customizedLivenessLabel(widget.config.customizedLabel!);
    } else {
      baseSteps = List.from(stepLiveness); // Create a copy to avoid modifying the original
    }
    
    shuffleListLivenessChallenge(
      list: baseSteps,
      isSmileLast: widget.config.useCustomizedLabel
          ? false
          : widget.config.shuffleListWithSmileLast,
    );
    
    _shuffledSteps = baseSteps;
  }

  /// Helper method to get the shuffled steps list
  List<LivenessDetectionStepItem> _getStepsToUse() {
    return _shuffledSteps;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.config.isDarkMode ? Colors.black : Colors.white,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        _isInfoStepCompleted
            ? _buildDetectionBody()
            : LivenessDetectionTutorialScreen(
                duration: widget.config.durationLivenessVerify ?? 45,
                isDarkMode: widget.config.isDarkMode,
                onStartTap: () {
                  if (mounted) setState(() => _isInfoStepCompleted = true);
                  _startLiveFeed();
                },
              ),
      ],
    );
  }

  Widget _buildDetectionBody() {
    if (_cameraController == null ||
        _cameraController?.value.isInitialized == false) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: widget.config.isDarkMode ? Colors.black : Colors.white,
        ),
        LivenessDetectionStepOverlayWidget(
          cameraController: _cameraController,
          duration: widget.config.durationLivenessVerify,
          showDurationUiText: widget.config.showDurationUiText,
          isDarkMode: widget.config.isDarkMode,
          isFaceDetected: _faceDetectedState,
          camera: CameraPreview(_cameraController!),
          key: _stepsKey,
          steps: _getStepsToUse(),
          showCurrentStep: widget.config.showCurrentStep,
          onCompleted: () => Future.delayed(
            const Duration(milliseconds: 500),
            () => _takePicture(),
          ),
        ),
      ],
    );
  }

  Future<void> _handlingBlinkStep({
    required Face face,
    required LivenessDetectionStep step,
  }) async {
    final blinkThreshold =
        FlutterLivenessDetectionRandomizedPlugin.instance.thresholdConfig
                .firstWhereOrNull((p0) => p0 is LivenessThresholdBlink)
            as LivenessThresholdBlink?;

    if ((face.leftEyeOpenProbability ?? 1.0) <
            (blinkThreshold?.leftEyeProbability ?? 0.25) &&
        (face.rightEyeOpenProbability ?? 1.0) <
            (blinkThreshold?.rightEyeProbability ?? 0.25)) {
      _startProcessing();
      await _completeStep(step: step);
    }
  }

  Future<void> _handlingTurnRight({
    required Face face,
    required LivenessDetectionStep step,
  }) async {
    if (Platform.isAndroid) {
      final headTurnThreshold =
          FlutterLivenessDetectionRandomizedPlugin.instance.thresholdConfig
                  .firstWhereOrNull((p0) => p0 is LivenessThresholdHead)
              as LivenessThresholdHead?;
      if ((face.headEulerAngleY ?? 0) <
          (headTurnThreshold?.rotationAngle ?? -30)) {
        _startProcessing();
        await _completeStep(step: step);
      }
    } else if (Platform.isIOS) {
      final headTurnThreshold =
          FlutterLivenessDetectionRandomizedPlugin.instance.thresholdConfig
                  .firstWhereOrNull((p0) => p0 is LivenessThresholdHead)
              as LivenessThresholdHead?;
      if ((face.headEulerAngleY ?? 0) >
          (headTurnThreshold?.rotationAngle ?? 30)) {
        _startProcessing();
        await _completeStep(step: step);
      }
    }
  }

  Future<void> _handlingTurnLeft({
    required Face face,
    required LivenessDetectionStep step,
  }) async {
    if (Platform.isAndroid) {
      final headTurnThreshold =
          FlutterLivenessDetectionRandomizedPlugin.instance.thresholdConfig
                  .firstWhereOrNull((p0) => p0 is LivenessThresholdHead)
              as LivenessThresholdHead?;
      if ((face.headEulerAngleY ?? 0) >
          (headTurnThreshold?.rotationAngle ?? 30)) {
        _startProcessing();
        await _completeStep(step: step);
      }
    } else if (Platform.isIOS) {
      final headTurnThreshold =
          FlutterLivenessDetectionRandomizedPlugin.instance.thresholdConfig
                  .firstWhereOrNull((p0) => p0 is LivenessThresholdHead)
              as LivenessThresholdHead?;
      if ((face.headEulerAngleY ?? 0) <
          (headTurnThreshold?.rotationAngle ?? -30)) {
        _startProcessing();
        await _completeStep(step: step);
      }
    }
  }

  Future<void> _handlingLookUp({
    required Face face,
    required LivenessDetectionStep step,
  }) async {
    final headTurnThreshold =
        FlutterLivenessDetectionRandomizedPlugin.instance.thresholdConfig
                .firstWhereOrNull((p0) => p0 is LivenessThresholdHead)
            as LivenessThresholdHead?;
    if ((face.headEulerAngleX ?? 0) >
        (headTurnThreshold?.rotationAngle ?? 20)) {
      _startProcessing();
      await _completeStep(step: step);
    }
  }

  Future<void> _handlingLookDown({
    required Face face,
    required LivenessDetectionStep step,
  }) async {
    final headTurnThreshold =
        FlutterLivenessDetectionRandomizedPlugin.instance.thresholdConfig
                .firstWhereOrNull((p0) => p0 is LivenessThresholdHead)
            as LivenessThresholdHead?;
    if ((face.headEulerAngleX ?? 0) <
        (headTurnThreshold?.rotationAngle ?? -15)) {
      _startProcessing();
      await _completeStep(step: step);
    }
  }

  Future<void> _handlingSmile({
    required Face face,
    required LivenessDetectionStep step,
  }) async {
    final smileThreshold =
        FlutterLivenessDetectionRandomizedPlugin.instance.thresholdConfig
                .firstWhereOrNull((p0) => p0 is LivenessThresholdSmile)
            as LivenessThresholdSmile?;

    if ((face.smilingProbability ?? 0) >
        (smileThreshold?.probability ?? 0.65)) {
      _startProcessing();
      await _completeStep(step: step);
    }
  }
}
