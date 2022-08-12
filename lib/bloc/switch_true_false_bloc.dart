import 'dart:async';

class SwitchTrueFalseBloc {
  bool _state = false;
  SwitchTrueFalseBloc() {
    _controller.sink.add(_state);
  }
  
  final StreamController<bool> _controller = StreamController<bool>();
  Stream<bool> get stream => _controller.stream;

  void toggleState() {
    _state = !_state;
    _controller.sink.add(_state);
  }

  void dispose() {
    _controller.close();
  }
}
