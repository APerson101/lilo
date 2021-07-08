import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lilo/views/transactions/transactions.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:styled_widget/styled_widget.dart';

import 'analyzerController.dart';

class AnalyzerDashboard extends StatelessWidget {
  AnalyzerDashboard({Key? key}) : super(key: key);
  AnalyzerController controller = Get.put(AnalyzerController());

  @override
  Widget build(BuildContext context) {
    return Container(child: dashboardGraph());
  }

//shows activity by combining the data for credit and debit
//you can get the data by querrying the last 7 results and then sorting them
//by if they contain negative number...use transaction wallet history
  dashboardGraph() {
    List<GraphData> items = controller.getDashData();
    return Center(
        child: Container(
            child: SfCartesianChart(
                primaryXAxis: DateTimeCategoryAxis(),
                series: <ChartSeries>[
          ColumnSeries<GraphData, DateTime>(
              dataSource: items,
              xValueMapper: (GraphData sales, _) => sales.time,
              yValueMapper: (GraphData sales, _) => sales.amount,
              pointColorMapper: (GraphData current, _) {
                if (current.source == "credit") return Colors.green;
                return Colors.red;
              },
              // Sets the corner radius
              borderRadius: BorderRadius.all(Radius.circular(15)))
        ])).constrained(width: 400, height: 400));
  }
}
