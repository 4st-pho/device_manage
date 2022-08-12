import 'package:flutter/material.dart';
import 'package:manage_devices_app/pages/admin/widgets/chart.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: const[
          BarChartSample2()
        ],),
      ),
    );
  }
}
