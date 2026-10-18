// core/services/photo_service.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class PhotoService {
  final _picker = ImagePicker();

  /// Opens the camera. Returns the file path, or null if the driver cancelled.
  Future<String?> capture() async {
    final photo = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1600,
      imageQuality: 85,
    );
    return photo?.path;
  }
}

final photoServiceProvider = Provider<PhotoService>((_) => PhotoService());