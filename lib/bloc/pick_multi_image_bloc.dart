import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PickMultiImageBloc {
  List<File>? images;
  final ImagePicker _picker = ImagePicker();

  final StreamController<List<File>?> _pickImageController =
      StreamController<List<File>?>();
  Stream<List<File>?> get listImageStream => _pickImageController.stream;
  Future<void> pickImages() async {
    final List<XFile>? data = await _picker.pickMultiImage();
    if (data != null) {
      images = data.map((e) => File(e.path)).toList();
      _pickImageController.sink.add(images);
    }
  }

  void dispose() {
    _pickImageController.close();
  }
}
