import 'dart:async';

class SearchBloc {
  List<String> result = [];
  final StreamController<List<String>> _controller =
      StreamController<List<String>>();
  Stream<List<String>> get stream => _controller.stream;
  void onTextChange(String value) {
    // final data = 
  }

  void dispose() {
    _controller.close();
  }
}
