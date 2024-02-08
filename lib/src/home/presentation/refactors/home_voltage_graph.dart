import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeVoltageGraph extends StatefulWidget {
  const HomeVoltageGraph({super.key});

  @override
  State<HomeVoltageGraph> createState() => _HomeVoltageGraphState();
}

class _HomeVoltageGraphState extends State<HomeVoltageGraph>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(10),
        width: 1060,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.8),
              offset: const Offset(-6.0, -6.0),
              blurRadius: 16.0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(6.0, 6.0),
              blurRadius: 16.0,
            ),
          ],
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            RotatedBox(
              quarterTurns: 3,
              child: Container(
                padding: const EdgeInsets.only(bottom: 10, left: 10),
                child: const Text(
                  "VOLTAGE GRAPH",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  legend: Legend(
                    isVisible: true,
                  ),
                  series: <CartesianSeries>[
                    FastLineSeries(
                      name: "TPS",
                      dataSource: List.generate(10, (index) => index),
                      xValueMapper: (index, _) => index,
                      yValueMapper: (index, _) => index,
                    ),
                    FastLineSeries(
                      name: "RPM",
                      dataSource: List.generate(10, (index) => index),
                      xValueMapper: (index, _) => index,
                      yValueMapper: (index, _) => index + 5,
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
