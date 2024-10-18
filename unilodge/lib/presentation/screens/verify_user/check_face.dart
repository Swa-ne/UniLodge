import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:unilodge/bloc/verify_user/verify_user_bloc.dart';
import 'package:unilodge/bloc/verify_user/verify_user_event.dart';
import 'package:unilodge/bloc/verify_user/verify_user_state.dart';
import 'package:unilodge/common/utils/google_ml_kit.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

late List<CameraDescription> _cameras;

class CheckFaceScreen extends StatefulWidget {
  const CheckFaceScreen({super.key});
  @override
  _CheckFaceScreenState createState() => _CheckFaceScreenState();
}

class _CheckFaceScreenState extends State<CheckFaceScreen> {
  CameraController? controller;
  bool _isCameraInitialized = false;
  bool _isLoading = false;
  bool isFaceInsideOval = false;
  late VerifyUserBloc _verifyBloc;

  FaceDetector faceDetector =
      GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
    enableContours: true,
    enableClassification: true,
    enableTracking: true,
    enableLandmarks: true,
  ));

  @override
  void initState() {
    super.initState();
    _verifyBloc = BlocProvider.of<VerifyUserBloc>(context);
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
    }
  }

  Future<void> captureAndProcessImage() async {
    try {
      if (!controller!.value.isInitialized) return;

      final image = await controller!.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);

      // Process the image for face detection
      await processImage(inputImage);
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  Future<void> processImage(InputImage inputImage) async {
    final faces = await faceDetector.processImage(inputImage);

    if (mounted) {
      setState(() {
        if (faces.length > 0) {
          final filePath = inputImage.filePath;
          if (filePath != null && filePath.isNotEmpty) {
            File imageFile = File(filePath);
            return _verifyBloc.add(CheckFaceEvent(imageFile));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.face_retouching_natural_outlined,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Oops, make sure your face is clearly visible with enough light!",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
            backgroundColor: Colors.redAccent,
            shape: StadiumBorder(),
            behavior: SnackBarBehavior.floating,
          ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return BlocListener<VerifyUserBloc, VerifyUserState>(
      listener: (context, state) {
        if (state is VerifyUserLoading) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is VerifyUserSuccess) {
          setState(() {
            _isLoading = false;
          });
          controller?.dispose();
          context.go('/home');
        } else if (state is VerifyUserError) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Face doesn't match your id.")),
          );
        } else if (state is CheckFaceSuccess) {
          return _verifyBloc.add(VerifyUserEvent());
        } else if (state is CheckFaceError) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..scale(-1.0, 1.0),
                    child: CameraPreview(controller!),
                  ),
                );
              },
            ),
            // Face ID Lottie animation
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: Lottie.asset(
                "assets/animation/face_id_ring.json",
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: FloatingActionButton(
                  onPressed: captureAndProcessImage,
                  shape: const CircleBorder(),
                  backgroundColor: Colors.blue, // You can adjust the color
                  // Set a fixed size for the button
                  mini: false,
                  child: const Icon(Icons.camera),
                ),
              ),
            ),
            if (_isLoading)
              Positioned.fill(
                child: Stack(
                  children: [
                    // Modal barrier to prevent any interactions
                    ModalBarrier(
                      dismissible: false,
                      color: Colors.black
                          .withOpacity(0.5), // Semi-transparent background
                    ),

                    // Centered loading spinner
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            'Processing...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
