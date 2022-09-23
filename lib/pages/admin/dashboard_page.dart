import 'package:fl_chart/fl_chart.dart';
import 'package:manage_devices_app/constants/app_color.dart';
import 'package:manage_devices_app/constants/app_strings.dart';
import 'package:manage_devices_app/constants/app_style.dart';
import 'package:manage_devices_app/pages/admin/widgets/bar_chart_request.dart';
import 'package:manage_devices_app/pages/admin/widgets/pie_chart_request.dart';
import 'package:manage_devices_app/widgets/common/shimmer_list.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/bloc/dashbroad_bloc.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final DashbroadBloc _dashbroadBloc;
  @override
  void initState() {
    _dashbroadBloc = context.read<DashbroadBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildBarChartWeek(),
            _buildPieChartWeek(),
            _buildbBarChart12Month(),
            _buildPieChart12Month(),
            _buildPieChartAllRequest(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChartAllRequest() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(AppString.allRequest),
        StreamBuilder<bool>(
          stream: _dashbroadBloc.isLoadedDataStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              final error = snapshot.error.toString();
              return Center(
                child: Text(error),
              );
            } else if (snapshot.hasData) {
              return PieChartRequest(
                preChartPercent:
                    _dashbroadBloc.listPercentRequestTypeOfAllRequest(),
                requestChart: _dashbroadBloc.requestChart,
              );
            }
            return ShimmerList.chartShimmer;
          },
        ),
      ],
    );
  }

  Widget _buildPieChart12Month() {
    return StreamBuilder<bool>(
      stream: _dashbroadBloc.isLoadedDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          final error = snapshot.error.toString();
          return Center(
            child: Text(error),
          );
        } else if (snapshot.hasData) {
          return PieChartRequest(
            preChartPercent: _dashbroadBloc.listPercentRequestTypeIn12Month(),
            requestChart: _dashbroadBloc.requestChart,
          );
        }
        return ShimmerList.chartShimmer;
      },
    );
  }

  Widget _buildbBarChart12Month() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(AppString.monthRequest),
        StreamBuilder<List<BarChartGroupData>>(
          stream: _dashbroadBloc.monthChartDataStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              final error = snapshot.error.toString();
              return Center(
                child: Text(error),
              );
            } else if (snapshot.hasData) {
              final barChartGroupData = snapshot.data;
              return BarChartRequest(
                barGroups: barChartGroupData!,
                convertDateFromInt: _dashbroadBloc.getMonthFromDouble,
                maxY: _dashbroadBloc.quantityRequestIn12Month,
              );
            }
            return ShimmerList.chartShimmer;
          },
        ),
      ],
    );
  }

  Widget _buildPieChartWeek() {
    return StreamBuilder<bool>(
      stream: _dashbroadBloc.isLoadedDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          final error = snapshot.error.toString();
          return Center(child: Text(error));
        } else if (snapshot.hasData) {
          return PieChartRequest(
            preChartPercent: _dashbroadBloc.listPercentRequestTypeInWeek(),
            requestChart: _dashbroadBloc.requestChart,
          );
        }
        return ShimmerList.chartShimmer;
      },
    );
  }

  Widget _buildBarChartWeek() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(AppString.dayRequest),
        StreamBuilder<List<BarChartGroupData>>(
          stream: _dashbroadBloc.weekChartDataStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              final error = snapshot.error.toString();
              return Center(
                child: Text(error),
              );
            } else if (snapshot.hasData) {
              final barChartGroupData = snapshot.data;
              return BarChartRequest(
                barGroups: barChartGroupData!,
                convertDateFromInt: _dashbroadBloc.getDayFromDouble,
                maxY: _dashbroadBloc.quantityRequestInAWeek,
              );
            }
            return ShimmerList.chartShimmer;
          },
        ),
      ],
    );
  }

  Widget _buildLabel(String label) {
    return Container(
      margin: const EdgeInsets.only(left: 12, top: 12, right: 12, bottom: 30),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 4, color: AppColor.dartBlue),
        ),
      ),
      child: Text(label, style: AppStyle.blueTitle),
    );
  }
}
