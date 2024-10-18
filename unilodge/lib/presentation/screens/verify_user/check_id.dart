import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:unilodge/bloc/verify_user/verify_user_bloc.dart';
import 'package:unilodge/bloc/verify_user/verify_user_event.dart';
import 'package:unilodge/bloc/verify_user/verify_user_state.dart';
import 'package:unilodge/common/utils/google_ml_kit.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:unilodge/presentation/screens/verify_user/rectangle.dart';

class CheckIDScreen extends StatefulWidget {
  const CheckIDScreen({super.key});
  @override
  _CheckIDScreenState createState() => _CheckIDScreenState();
}

class _CheckIDScreenState extends State<CheckIDScreen> {
  CameraController? controller;
  bool _isCameraInitialized = false;
  bool isFaceInsideOval = false;
  late List<CameraDescription> _cameras;
  late VerifyUserBloc _verifyBloc;
  bool _isLoading = false;

  FaceDetector faceDetector =
      GoogleMlKit.vision.faceDetector(FaceDetectorOptions());
  TextRecognizer textRecognizer = TextRecognizer();

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
      CameraDescription backCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => throw Exception('No back camera found'),
      );
      controller = CameraController(backCamera, ResolutionPreset.veryHigh);
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
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    if (mounted) {
      setState(() {
        if (faces.isNotEmpty) {
          if (recognizedText.text.isNotEmpty) {
            for (TextBlock block in recognizedText.blocks) {
              for (TextLine line in block.lines) {
                String currentLine = line.text;
                if (isSimilar(currentLine, 'PHINMA EDUCATION') ||
                    isSimilar(
                        currentLine, 'MAKING LIVES BETTER THROUGH EDUCATION')) {
                  final filePath = inputImage.filePath;
                  if (filePath != null && filePath.isNotEmpty) {
                    File imageFile = File(filePath);
                    return _verifyBloc.add(CheckIdEvent(imageFile));
                  }
                }
              }
            }
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "No valid ID detected. Please make sure it's a school ID.",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
              backgroundColor: Color.fromARGB(255, 214, 203, 203),
              shape: StadiumBorder(),
              behavior: SnackBarBehavior.floating,
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "No valid ID detected. Please make sure it's a valid ID.",
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
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Oops, make sure your id is clearly visible with enough light!",
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
        } else if (state is CheckIdSuccess) {
          setState(() {
            _isLoading = false;
          });
          controller?.dispose();
          context.go('/face-details');
        } else if (state is CheckIdError) {
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
            Positioned.fill(
              child: CameraPreview(controller!),
            ),
            // Face ID Lottie animation

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
            const RectangleOverlay(
              color: Colors.cyan,
            ),
            // Loading indicator overlay
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
                        children: [
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

  bool isSimilar(String recognizedText, String targetText,
      {int threshold = 5}) {
    recognizedText = recognizedText.toLowerCase();
    targetText = targetText.toLowerCase();

    // Calculate Levenshtein distance and check if it's within the threshold
    int distance = levenshteinDistance(recognizedText, targetText);
    return distance <= threshold;
  }

  int levenshteinDistance(String s1, String s2) {
    List<List<int>> dp =
        List.generate(s1.length + 1, (_) => List.filled(s2.length + 1, 0));

    for (int i = 0; i <= s1.length; i++) {
      for (int j = 0; j <= s2.length; j++) {
        if (i == 0) {
          dp[i][j] = j; // Insert all characters of s2
        } else if (j == 0) {
          dp[i][j] = i; // Delete all characters of s1
        } else if (s1[i - 1] == s2[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1]; // No change
        } else {
          dp[i][j] = 1 +
              [
                dp[i - 1][j], // Remove
                dp[i][j - 1], // Insert
                dp[i - 1][j - 1] // Replace
              ].reduce((a, b) => a < b ? a : b);
        }
      }
    }

    return dp[s1.length][s2.length];
  }
}
