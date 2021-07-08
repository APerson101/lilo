import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lilo/models/wallet.dart';
import 'package:lilo/views/transactions/transactioncontroller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:styled_widget/styled_widget.dart';

// import 'package:get/route_manager.dart';
// import 'package:lilo/models/wallet.dart';
// import 'package:lilo/repositories/rapyd/walletRepository.dart';
// import 'package:lilo/repositories/user_repo.dart';
// import 'package:lilo/views/transactions/bloc/transactions_bloc.dart';

import 'TransactionTableView.dart';

class TransactionsView extends StatelessWidget {
  final TransactionsController controller = Get.put(TransactionsController());
  TransactionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: content(context));
  }

  content(context) {
    return ListView(children: [
      ElevatedButton(
          onPressed: () {
            if (controller.currentState.value == transactionsState.summary)
              controller.currentState.value = transactionsState.detailed;
            if (controller.currentState.value == transactionsState.detailed)
              controller.currentState.value = transactionsState.summary;
          },
          child: Text('change')),
      contentdecider(context)
    ]);
  }

  contentdecider(BuildContext context) {
    return Obx(() {
      if (controller.currentState.value == transactionsState.loading)
        return Center(child: CircularProgressIndicator());
      if (controller.currentState.value == transactionsState.detailed)
        return tableView(controller.allTransactions.value, context);
      if (controller.currentState.value == transactionsState.summary)
        return showGraph();
      return Container();
    });
  }

  showGraph() {
    List items = [];
    //controller.getDashData();

    ChartAxis axis = DateTimeCategoryAxis();

    return ObxValue((vl) {
      if (view.value == currentView.all) {
        //show debit/credit
        axis = CategoryAxis();
        items = controller.getDashData();
      }
      if (view.value == currentView.creditSources) {
        //show credit sources
        items = controller.getCreditSources();
      }
      if (view.value == currentView.debitSources) {
        //show debit sources

        items = controller.getDebitSources();
      }
      if (view.value == currentView.creditPersons) {
        //show credit persons

        items = controller.getCreditPersons();
      }
      if (view.value == currentView.debitPersons) {
        //show  debit presons
        items = controller.getDeditPersons();
      }
      return Center(
          child: Container(
              child: SfCartesianChart(
        primaryXAxis: axis,
        series: <ChartSeries>[
          ColumnSeries<dynamic, dynamic>(
              onPointTap: (ChartPointDetails point) {
                mapper(point.pointIndex!, items);
              },
              dataSource: items,
              xValueMapper: (dynamic sales, _) {
                return Xmapper(sales);
                // sales.time;
              },
              yValueMapper: (dynamic sales, _) {
                return Ymapper(sales);
              },
              pointColorMapper: (dynamic current, _) {
                return colorMapper(current);
              },
              // Sets the corner radius
              borderRadius: BorderRadius.all(Radius.circular(15)))
        ],
      )).constrained(width: 400, height: 400));
    }, view);

    // });
  }

  Color colorMapper(dynamic thing) {
    if (view.value == currentView.all) {
      var vii = (thing as GraphData);
      if (vii.source == "credit") return Colors.green;
      return Colors.red;
    }
    if (view.value == currentView.creditSources) {
      //wants to see credit persons
      switch ((thing as FinanceData).source) {
        case "walletTransfer":
          return Colors.blue;
        case "bankCredit":
          return Colors.amber;
        case "payoutIn":
          return Colors.cyanAccent;
      }
    }
    return Colors.yellowAccent;
  }

  var view = currentView.all.obs;

  Xmapper(dynamic thing) {
    return thing.source;
    if (view.value == currentView.all) {
      return (thing as GraphData).source;
    }
    if (view.value == currentView.creditSources) {
      //wants to see credit persons
      return (thing as FinanceData).source;
    }
    if (view.value == currentView.credit) {
      //wants to see debit presons
      view.value = currentView.debitPersons;
    }
  }

  Ymapper(dynamic thing) {
    return thing.amount;
    if (view.value == currentView.all) {
      return (thing as GraphData).amount;
    }
    if (view.value == currentView.creditSources) {
      //wants to see credit persons
      // return (thing as CreditData).amount;
    }
    if (view.value == currentView.credit) {
      //wants to see debit presons
      view.value = currentView.debitPersons;
    }
  }

  mapper(int index, List items) {
    if (view.value == currentView.all) {
      //wants to see credit details

      if ((items as List<GraphData>)[index].source == 'credit') {
        print('we would show credit');
        view.value = currentView.creditSources;
      } else {
        view.value = currentView.debitSources;

        print('we would show debit');
      }
    }
    if (view.value == currentView.creditSources) {
      //wants to see credit persons
      controller.selectedsource.value =
          (items as List<FinanceData>)[index].source;
      print('we want to show: ${(items as List<FinanceData>)[index].source}');
      // view.value = currentView.creditPersons;
      view.value = currentView.creditPersons;
    }
    if (view.value == currentView.debitSources) {
      //wants to see debit presons
      controller.selectedsource.value =
          (items as List<FinanceData>)[index].source;
      print('we want to show: ${(items as List<FinanceData>)[index].source}');
      view.value = currentView.debitPersons;
    }
  }
}

tableView(List<Transaction> allTransactions, BuildContext context) {
  TransactionTableView _transactiontable = TransactionTableView(
      allTransaction: allTransactions,
      onRowPressed: showdetails,
      context: context);

  return PaginatedDataTable(
      header: Text('Transactions History'),
      columns: [
        DataColumn(label: Text('amount')),
        DataColumn(label: Text('currency')),
        DataColumn(label: Text('type')),
        DataColumn(label: Text('created_at')),
        DataColumn(label: Text('status')),
        DataColumn(label: Text('id')),
        DataColumn(label: Text('more')),
      ],
      actions: [
        //this is where the sort and filter would go
      ],
      showCheckboxColumn: false,
      source: _transactiontable);
}

showdetails(Transaction currentTransaction, BuildContext context) async {
  if (!currentTransaction.id.startsWith('wt_')) return;
  // String details =
  //     await controller.loadtransactiondetails(currentTransaction.id);
  // showdialog(details, context);
}

showdialog(String details, BuildContext context) {
  showAboutDialog(context: context, children: [Text(details)]);
}

enum currentView {
  credit,
  debit,
  creditSources,
  debitSources,
  creditPersons,
  debitPersons,
  all
}

class GraphData {
  double amount;
  String source;
  DateTime time;
  GraphData({
    required this.amount,
    required this.source,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'type': source,
      'time': time.millisecondsSinceEpoch,
    };
  }

  factory GraphData.fromMap(Map<String, dynamic> map) {
    return GraphData(
      amount: map['amount'],
      source: map['source'],
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
    );
  }

  GraphData copyWith({
    double? amount,
    String? type,
    DateTime? time,
  }) {
    return GraphData(
      amount: amount ?? this.amount,
      source: type ?? this.source,
      time: time ?? this.time,
    );
  }
}
