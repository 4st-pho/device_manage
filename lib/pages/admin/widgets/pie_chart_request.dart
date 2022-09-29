import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:manage_devices_app/constants/app_color.dart';
import 'package:manage_devices_app/enums/error_type.dart';
import 'package:manage_devices_app/pages/admin/widgets/indicator.dart';

class PieChartRequest extends StatefulWidget {
  final Map<ErrorType, double> preChartPercent;
  const PieChartRequest({
    Key? key,
    required this.preChartPercent,
  }) : super(key: key);

  @override
  State<PieChartRequest> createState() => _PieChartRequestState();
}

class _PieChartRequestState extends State<PieChartRequest> {
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
        children: ErrorType.values.map(
          (errorType) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Indicator(
                color: errorType.getColor,
                text: errorType.getAlias,
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
        final errorType = ErrorType.values[i];
        return PieChartSectionData(
          color: errorType.getColor,
          value: widget.preChartPercent[errorType],
          title: '${widget.preChartPercent[errorType]}%',
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
