import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class Vision {
  Vision._();

  static final Vision instance = Vision._();

  FaceDetector faceDetector([FaceDetectorOptions? options]) {
    return FaceDetector(options: options ?? FaceDetectorOptions());
  }
}

class GoogleMlKit {
  GoogleMlKit._();

  static final Vision vision = Vision.instance;
}
