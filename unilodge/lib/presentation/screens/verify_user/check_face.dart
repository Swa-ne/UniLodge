import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:unilodge/presentation/screens/verify_user/face_overlay.dart';

late List<CameraDescription> _cameras;

class CheckFaceScreen extends StatefulWidget {
  const CheckFaceScreen({super.key});
  @override
  _CheckFaceScreenState createState() => _CheckFaceScreenState();
}

class _CheckFaceScreenState extends State<CheckFaceScreen> {
  CameraController? controller; // Make the controller nullable
  bool _isCameraInitialized = false; // Flag to track camera initialization

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    try {
      _cameras = await availableCameras();
      // Find the first front camera available
      CameraDescription frontCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => throw Exception('No front camera found'),
      );
      controller = CameraController(frontCamera, ResolutionPreset.veryHigh);
      await controller!.initialize();
      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true; // Set the flag to true on success
      });
    } catch (e) {
      // Handle the error appropriately
      if (!mounted) return;
      setState(() {
        _isCameraInitialized = false;
      });
      print('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    controller?.dispose(); // Dispose safely using null-aware operator
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    if (!_isCameraInitialized) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        // alignment: Alignment.center,
        children: <Widget>[
          AspectRatio(
            aspectRatio: screenWidth / screenHeight,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..scale(-1.0, 1.0), // Flip horizontally
              child: AspectRatio(
                aspectRatio: screenWidth / screenHeight,
                child: CameraPreview(controller!),
              ),
            ),
          ),
          AspectRatio(
            aspectRatio: screenWidth / screenHeight,
            child: FaceOverlay(), // Custom overlay
          ),
        ],
      ),
    );
  }
}
