import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/enums/error_type.dart';
import 'package:manage_devices_app/model/request.dart';
import 'package:manage_devices_app/model/request_chart.dart';
import 'package:manage_devices_app/services/clound_firestore/request_service.dart';

class DashbroadBloc {
  List<Request> _allRequest = [];
  List<Request> _requestInNearestWeek = [];
  List<Request> _requestInNearest12Month = [];
  final List<RequestChart> requestChart = [
    RequestChart(
        errorType: ErrorType.noError,
        alias: AppString.newDevice,
        color: const Color(0xff0293ee)),
    RequestChart(
        errorType: ErrorType.software,
        alias: AppString.software,
        color: const Color(0xff845bef)),
    RequestChart(
        errorType: ErrorType.hardware,
        alias: AppString.hardware,
        color: const Color.fromARGB(255, 242, 131, 34)),
  ];
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
    DateTime date = DateTime.now();
    DateTime tempDate = DateTime.now();
    DateTime nextMonth = DateTime(date.year, date.month + 1);
    DateTime twelveMonthsAgo = DateTime(date.year, date.month - 12);
    _requestInNearest12Month = _allRequest.where((request) {
      tempDate = DateTime(date.year, date.month);
      if (tempDate.isAfter(twelveMonthsAgo) && tempDate.isBefore(nextMonth)) {
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
      final int x = getIntValueFromDate(weekDay);
      return BarChartGroupData(
        x: x,
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
      final int x = getIntValueFromMonthDate(monthDate);
      return BarChartGroupData(
        x: x,
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

  String getDayFromDouble(double value) {
    switch (value.toInt()) {
      case 0:
        return 'Mon';
      case 1:
        return 'Tue';
      case 2:
        return 'Wed';
      case 3:
        return 'Thu';
      case 4:
        return 'Fri';
      case 5:
        return 'Sat';
      case 6:
        return 'Sn';
      default:
        return '';
    }
  }

  int getIntValueFromDate(DateTime weekDay) {
    switch (DateFormat('EE').format(weekDay)) {
      case 'Mon':
        return 0;
      case 'Tue':
        return 1;
      case 'Wed':
        return 2;
      case 'Thu':
        return 3;
      case 'Fri':
        return 4;
      case 'Sat':
        return 5;
      case 'Sun':
        return 6;
      default:
        return 0;
    }
  }

  String getMonthFromDouble(double value) {
    switch (value.toInt()) {
      case 0:
        return '1';
      case 1:
        return '2';
      case 2:
        return '3';
      case 3:
        return '4';
      case 4:
        return '5';
      case 5:
        return '6';
      case 6:
        return '7';
      case 7:
        return '8';
      case 8:
        return '9';
      case 9:
        return '10';
      case 10:
        return '11';
      case 11:
        return '12';
      default:
        return '';
    }
  }

  int getIntValueFromMonthDate(DateTime weekDay) {
    switch (DateFormat('MMM').format(weekDay)) {
      case 'Jan':
        return 0;
      case 'Feb':
        return 1;
      case 'Mar':
        return 2;
      case 'Apr':
        return 3;
      case 'May':
        return 4;
      case 'Jun':
        return 5;
      case 'Jul':
        return 6;
      case 'Aug':
        return 7;
      case 'Sep':
        return 8;
      case 'Oct':
        return 9;
      case 'Nov':
        return 10;
      case 'Dec':
        return 11;
      default:
        return 0;
    }
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
