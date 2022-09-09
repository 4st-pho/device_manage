import 'dart:async';


class LoadBloc {
  bool _isLoading = false;
  final StreamController<bool> _loadController = StreamController<bool>();
  Stream<bool> get loadStream => _loadController.stream;
  void toggleState() {
    _isLoading = !_isLoading;
    _loadController.sink.add(_isLoading);
  }

  void setLoadState(bool loadState) {
    if (_isLoading != loadState) {
      _isLoading = loadState;
      _loadController.sink.add(_isLoading);
    }
  }

  void dispose() {
    _loadController.close();
  }
}
