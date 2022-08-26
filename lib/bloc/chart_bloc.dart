import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage_devices_app/model/request.dart';
import 'package:manage_devices_app/services/clound_firestore/request_method.dart';

class ChartBloc {
  late final List<Request> allRequest;
  ChartBloc() {
    Future.wait([init()]);
  }
  Future<void> init() async {
    allRequest =
        await RequestMethod(firebaseFirestore: FirebaseFirestore.instance)
            .getAllRequest();
  }

  final _barsGradient = const LinearGradient(
    colors: [
      Colors.lightBlueAccent,
      Colors.greenAccent,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  List<BarChartGroupData> get barGroups {
    return List.generate(7, (index) {
      DateTime weekDay = DateTime.now().subtract(Duration(days: 6 - index));
      double toY = 0;
      int x = 0;
      for (Request request in allRequest) {
        if (request.createdAt.day == weekDay.day &&
            request.createdAt.month == weekDay.month &&
            request.createdAt.year == weekDay.year) {
          toY++;
        }
      }
      switch (DateFormat('EE').format(weekDay)) {
        case 'Mon':
          x = 0;
          break;
        case 'Tue':
          x = 1;
          break;
        case 'Wed':
          x = 2;
          break;
        case 'Thu':
          x = 3;
          break;
        case 'Fri':
          x = 4;
          break;
        case 'Sat':
          x = 5;
          break;
        case 'Sun':
          x = 6;
          break;
        default:
          x = 0;
          break;
      }
      return BarChartGroupData(
        x: x,
        barRods: [
          BarChartRodData(
            toY: toY,
            gradient: _barsGradient,
          )
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();
  }
  
}
