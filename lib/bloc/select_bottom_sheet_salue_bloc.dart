import 'dart:async';

class SelectBottomSheetValueBloc {
  dynamic value;
  final Future<List<dynamic>> getData;
  SelectBottomSheetValueBloc(this.getData);

  final StreamController<dynamic> _controller =
      StreamController<dynamic>.broadcast();
  Stream<dynamic> get stream => _controller.stream;
  void onChooseValue(dynamic valueParam) {
    value = valueParam;
    _controller.sink.add(value);
  }

  void onClear() {
    value = null;
    _controller.sink.add(value);
  }

  void sink() {
    _controller.sink.add(value);
  }

  void dispose() {
    _controller.close();
  }
}
