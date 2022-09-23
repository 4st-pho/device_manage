import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:manage_devices_app/constants/app_color.dart';
import 'package:manage_devices_app/enums/error_type.dart';
import 'package:manage_devices_app/model/request_chart.dart';
import 'package:manage_devices_app/pages/admin/widgets/indicator.dart';

class PieChartRequest extends StatelessWidget {
  final Map<ErrorType, double> preChartPercent;
  final List<RequestChart> requestChart;
  const PieChartRequest({
    Key? key,
    required this.preChartPercent,
    required this.requestChart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        color: AppColor.background,
        child: Row(
          children: [
            const SizedBox(height: 18),
            _buildChart(),
            _buildNote(),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: PieChart(
          PieChartData(
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 0,
              centerSpaceRadius: 40,
              sections: showingSections()),
        ),
      ),
    );
  }

  Widget _buildNote() {
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: requestChart.map(
          (r) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Indicator(
                color: r.color,
                text: r.alias,
                isSquare: true,
              ),
            );
          },
        ).toList());
  }

  List<PieChartSectionData> showingSections() {
    const fontSize = 16.0;
    const radius = 50.0;
    return List.generate(
      ErrorType.values.length,
      (i) {
        final key = ErrorType.values[i];
        for (var rc in requestChart) {
          if (rc.errorType == key) {
            return PieChartSectionData(
              color: rc.color,
              value: preChartPercent[key],
              title: '${preChartPercent[key]}%',
              radius: radius,
              titleStyle: const TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffffffff)),
            );
          }
        }
        return PieChartSectionData(
          color: Colors.blueGrey.shade800,
          value: 0,
          title: '',
          radius: radius,
          titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff)),
        );
      },
    );
  }
}
