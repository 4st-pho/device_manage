import 'dart:async';

class MainPageBloc {

  final StreamController<int> _pageIndexController = StreamController<int>();
  Stream<int> get pageIndexStream => _pageIndexController.stream;

  void onPageChange(int index) {
    _pageIndexController.sink.add(index);
  }

  void dispose() {
    _pageIndexController.close();
  }
}
