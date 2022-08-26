import 'dart:async';

class PickDateBloc {
  DateTime? date;

  final StreamController<DateTime?> _controller = StreamController<DateTime?>();
  Stream<DateTime?> get stream => _controller.stream;
  void pickTime(DateTime? date)  {
    if (date != null) {
      _controller.sink.add(date);
    }
  }

  void dispose() {
    _controller.close();
  }
}
