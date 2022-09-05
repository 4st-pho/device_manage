import 'dart:async';

class PickDateBloc {
  DateTime? _date;
  DateTime? get date => _date;

  final StreamController<DateTime?> _controller = StreamController<DateTime?>();
  Stream<DateTime?> get stream => _controller.stream;
  void pickTime(DateTime? date) {
    if (date != null) {
      _date = date;
      _controller.sink.add(date);
    }
  }

  void dispose() {
    _controller.close();
  }
}
