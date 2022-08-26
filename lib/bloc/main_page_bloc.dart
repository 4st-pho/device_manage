import 'dart:async';

class MainPageBloc {

  final StreamController<int> _controller = StreamController<int>();
  Stream<int> get stream => _controller.stream;

  void onPageChange(int index) {
    _controller.sink.add(index);
  }

  void dispose() {
    _controller.close();
  }
}
