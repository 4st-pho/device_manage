import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/enums/error_type.dart';
import 'package:manage_devices_app/model/request.dart';
import 'package:manage_devices_app/services/clound_firestore/request_service.dart';

class DashbroadBloc {
  List<Request> _allRequest = [];
  List<Request> _requestInNearestWeek = [];
  List<Request> _requestInNearest12Month = [];
  DashbroadBloc() {
    getAndSetAllData().then((_) async {
      _weekChartDataController.sink.add(barGroupsWeek);
      _monthChartDataController.sink.add(barGroupsMonth);
      _isLoadedDataController.sink.add(true);
    });
  }

  /// Show WeekBarChart when BarChartGroupData added into _weekChartDataController
  final _weekChartDataController = StreamController<List<BarChartGroupData>>();
  Stream<List<BarChartGroupData>> get weekChartDataStream =>
      _weekChartDataController.stream;

  /// Show MonthBarChart when BarChartGroupData added into _monthChartDataController
  final _monthChartDataController = StreamController<List<BarChartGroupData>>();
  Stream<List<BarChartGroupData>> get monthChartDataStream =>
      _monthChartDataController.stream;

  /// Show PieChart when data loaded
  final _isLoadedDataController = StreamController<bool>.broadcast();
  Stream<bool> get isLoadedDataStream => _isLoadedDataController.stream;

  void setAllRequestInNearestWeek() {
    DateTime currentDay = DateTime.now();
    DateTime nextDay = DateTime.now().add(const Duration(days: 1));
    DateTime seventDaysAgo = currentDay.subtract(const Duration(days: 7));
    _requestInNearestWeek = _allRequest
        .where((request) =>
            request.createdAt.isAfter(seventDaysAgo) &&
            request.createdAt.isBefore(nextDay))
        .toList();
  }

  void setAllRequestInNearest12Month() {
    DateTime currentDay = DateTime.now();

    /// save temp data to calculator
    DateTime tempDay = DateTime.now();
    DateTime nextMonth = DateTime(currentDay.year, currentDay.month + 1);
    DateTime twelveMonthsAgo = DateTime(currentDay.year, currentDay.month - 12);
    _requestInNearest12Month = _allRequest.where((request) {
      tempDay = DateTime(currentDay.year, currentDay.month);
      if (tempDay.isAfter(twelveMonthsAgo) && tempDay.isBefore(nextMonth)) {
        return true;
      }
      return false;
    }).toList();
  }

  Future<void> getAndSetAllData() async {
    _allRequest = await RequestService().getAllRequest();
    setAllRequestInNearestWeek();
    setAllRequestInNearest12Month();
  }

  double get quantityRequestInAWeek {
    double result = 0;
    for (BarChartGroupData item in barGroupsWeek) {
      result += item.barRods[0].toY;
    }
    return result;
  }

  double get quantityRequestIn12Month {
    double result = 0;
    for (BarChartGroupData item in barGroupsMonth) {
      result += item.barRods[0].toY;
    }
    return result;
  }

  List<BarChartGroupData> get barGroupsWeek {
    DateTime date = DateTime.now();
    final allHeightBar = List.generate(31, (index) => 0.0);
    for (Request request in _requestInNearestWeek) {
      allHeightBar[request.createdAt.day - 1]++;
    }
    return List.generate(7, (index) {
      DateTime weekDay = date.subtract(Duration(days: 6 - index));
      final int day = weekDay.weekday;
      return BarChartGroupData(
        x: day,
        barRods: [
          BarChartRodData(
            toY: allHeightBar[weekDay.day - 1],
            gradient: const LinearGradient(
              colors: [Colors.lightBlueAccent, Colors.greenAccent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          )
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();
  }

  List<BarChartGroupData> get barGroupsMonth {
    DateTime date = DateTime.now();
    final allHeightBar = List.generate(12, (index) => 0.0);
    for (Request request in _requestInNearest12Month) {
      allHeightBar[request.createdAt.month - 1]++;
    }

    return List.generate(12, (index) {
      final monthDate = DateTime(date.year, date.month - (11 - index));
      return BarChartGroupData(
        x: monthDate.month,
        barRods: [
          BarChartRodData(
            toY: allHeightBar[monthDate.month - 1],
            gradient: const LinearGradient(
              colors: [
                Colors.lightBlueAccent,
                Colors.greenAccent,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          )
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();
  }

  Map<ErrorType, double> listPercentRequestTypeInWeek() {
    return listPercentRequestType(_requestInNearestWeek);
  }

  Map<ErrorType, double> listPercentRequestTypeIn12Month() {
    return listPercentRequestType(_requestInNearest12Month);
  }

  Map<ErrorType, double> listPercentRequestTypeOfAllRequest() {
    return listPercentRequestType(_allRequest);
  }

  /// order by order in ErrorType
  /// e.g. ErrorType{software, hardware, noError}
  ///   return {
  ///   ErrorType.software: value,
  ///   ErrorType.hardware: value,
  ///   ErrorType.noError: value,
  /// }
  Map<ErrorType, double> listPercentRequestType(List<Request> listRequest) {
    Map<ErrorType, double> result = <ErrorType, double>{};
    for (var errorType in ErrorType.values) {
      result.addAll({errorType: 0});
    }
    if (listRequest.isEmpty) {
      return result;
    }

    for (Request request in listRequest) {
      result.update(request.errorType, (value) => value + 1);
    }
    result.forEach((key, value) {
      result.update(
          key, (value) => roundDouble((value * 100 / listRequest.length), 2));
    });

    return result;
  }

  double roundDouble(double val, int places) {
    num mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  void dispose() {
    _weekChartDataController.close();
    _monthChartDataController.close();
  }
}
