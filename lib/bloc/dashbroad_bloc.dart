import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage_devices_app/model/request.dart';
import 'package:manage_devices_app/services/clound_firestore/request_method.dart';

class DashbroadBloc {
  late final List<Request> allRequest;
  DashbroadBloc() {
    Future.wait([getAndSetAllRequest()]).then((value) {
      init();
    });
  }
  Future<void> getAndSetAllRequest() async {
    allRequest = await RequestService().getAllRequest();
  }

  void init() {
    _listBarChartGroupDataController.sink.add(barGroups);
  }

  final StreamController<List<BarChartGroupData>>
      _listBarChartGroupDataController =
      StreamController<List<BarChartGroupData>>();
  Stream<List<BarChartGroupData>> get listBarChartGroupDataStream =>
      _listBarChartGroupDataController.stream;

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

  double get quantityRequestInAWeek {
    double result = 0;
    for (BarChartGroupData item in barGroups) {
      result += item.barRods[0].toY;
    }
    return result;
  }

  List<BarChartGroupData> get barGroups {
    return List.generate(7, (index) {
      DateTime weekDay = DateTime.now().subtract(Duration(days: 6 - index));
      double toY = 0;
      for (Request request in allRequest) {
        if (request.createdAt.day == weekDay.day &&
            request.createdAt.month == weekDay.month &&
            request.createdAt.year == weekDay.year) {
          toY++;
        }
      }
      final int x = getIntValueFromDate(weekDay);
      return BarChartGroupData(
        x: x,
        barRods: [
          BarChartRodData(
            toY: toY,
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

  void dispose() {}
}