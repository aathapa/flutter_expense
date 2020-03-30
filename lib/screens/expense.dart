import 'package:expenses/models/transaction.dart';
import 'package:expenses/widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:expenses/widgets/add_transaction.dart';
import 'package:expenses/widgets/chart.dart';
import 'package:provider/provider.dart';

class Expense extends StatefulWidget {
  Expense({this.title});

  final String title;

  @override
  _ExpenseState createState() => _ExpenseState();
}

class _ExpenseState extends State<Expense> {
  bool _showChart = false;

  void addNewTransaction(BuildContext context, transactionData) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return AddTransaction(
          transactionData: transactionData,
        );
      },
    );
  }

  List<Transaction> _recentTransaction(TransactionHandler transaction) {
    return transaction.transactionList
        .where(
          (tx) => tx.date.isAfter(
            DateTime.now().subtract(
              Duration(days: 7),
            ),
          ),
        )
        .toList();
  }

  Widget renderChart(appBar, _chartHeightPercentage, transactionData) {
    return Column(
      children: <Widget>[
        Container(
          height: (MediaQuery.of(context).size.height -
                  appBar.preferredSize.height -
                  MediaQuery.of(context).padding.top) *
              _chartHeightPercentage,
          child: Chart(
            recentTransaction: _recentTransaction(transactionData),
          ),
        ),
      ],
    );
  }

  Widget rendertransactionList(appBar, transactionData) {
    return Container(
      height:
          (MediaQuery.of(context).size.height - appBar.preferredSize.height) *
              0.7,
      child: TransactionList(
        transactionData: transactionData,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TransactionHandler transactionData =
        Provider.of<TransactionHandler>(context);

    bool _isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final double _chartHeightPercentage = _isLandScape ? 0.7 : 0.3;

    final appBar = AppBar(
      title: Text(widget.title),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => {},
        )
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (_isLandScape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Show Chart',
                    style: TextStyle(fontSize: 18),
                  ),
                  Switch(
                    value: _showChart,
                    onChanged: (val) => setState(() => _showChart = val),
                  ),
                ],
              ),
            if (!_isLandScape)
              renderChart(appBar, _chartHeightPercentage, transactionData),
            if (!_isLandScape) rendertransactionList(appBar, transactionData),
            if (_isLandScape)
              _showChart
                  ? renderChart(appBar, _chartHeightPercentage, transactionData)
                  : rendertransactionList(appBar, transactionData),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => addNewTransaction(context, transactionData),
      ),
    );
  }
}
