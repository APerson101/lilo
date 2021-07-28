import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Activity",
                style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                        wordSpacing: 1)))
            .padding(left: 35),
        Center(
            child: Container(
          child: SfCartesianChart(
              plotAreaBorderWidth: 0.0,
              primaryXAxis: DateTimeCategoryAxis(),
              series: <ChartSeries>[
                ColumnSeries<GraphData, DateTime>(
                    dataSource: items,
                    borderWidth: 0,
                    trackBorderWidth: 0,
                    xValueMapper: (GraphData sales, _) => sales.time,
                    yValueMapper: (GraphData sales, _) => sales.amount,
                    pointColorMapper: (GraphData current, _) {
                      if (current.source == "credit") return Colors.blue;
                      return Colors.red;
                    },
                    // Sets the corner radius
                    borderRadius: BorderRadius.all(Radius.circular(50)))
              ]).constrained(height: 410),
        ).decorated(borderRadius: BorderRadius.circular(25))),
      ],
    ).constrained(height: 515);
  }
}
