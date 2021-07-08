import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lilo/models/wallet.dart';
import 'package:provider/provider.dart';

class TransactionTableView extends DataTableSource {
  List<Transaction> allTransaction;
  BuildContext context;
  final Function(Transaction, BuildContext) onRowPressed;
  TransactionTableView(
      {required this.allTransaction,
      required this.onRowPressed,
      required this.context});

  @override
  DataRow? getRow(int index) {
    List<DataCell> currentRow = [];
    var currencyCell = DataCell(Text(allTransaction[index].currency));
    var amountCell = DataCell(Text(allTransaction[index].amount.toString()));
    var created_atCell =
        DataCell(Text(allTransaction[index].created_at.toString()));
    var type = DataCell(Text(allTransaction[index].type));
    var statusCell = DataCell(Text(allTransaction[index].status));
    var idCell = DataCell(Text(allTransaction[index].id));
    currentRow.add(currencyCell);
    currentRow.add(amountCell);
    currentRow.add(type);
    currentRow.add(created_atCell);
    currentRow.add(statusCell);
    currentRow.add(idCell);
    if (allTransaction[index].id.startsWith('wt_'))
      currentRow.add(DataCell(IconButton(
          onPressed: () => onRowPressed(allTransaction[index], context),
          icon: Icon(Icons.more_vert))));

    return DataRow(
        cells: currentRow,
        onSelectChanged: (selected) {
          if (selected != null && selected) {
            //show more details
            return onRowPressed(allTransaction[index], context);
          }
        });
  }

  showdialog(String details) {
    return AlertDialog(content: Text(details));
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => allTransaction.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
