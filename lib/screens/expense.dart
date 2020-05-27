import 'dart:io';

import 'package:expenses/models/transaction.dart';
import 'package:expenses/widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expenses/widgets/add_transaction.dart';
import 'package:expenses/widgets/chart.dart';
import 'package:provider/provider.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class Expense extends StatefulWidget {
  Expense({this.title});

  final String title;

  @override
  _ExpenseState createState() => _ExpenseState();
}

class _ExpenseState extends State<Expense> with WidgetsBindingObserver {
  bool _showChart = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    print(state);
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
  }

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

  Widget renderbody(
      _isLandScape, appBar, _chartHeightPercentage, transactionData) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (_isLandScape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Show Chart',
                    style: Theme.of(context).textTheme.title,
                  ),
                  Switch.adaptive(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    TransactionHandler transactionData =
        Provider.of<TransactionHandler>(context);

    bool _isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final double _chartHeightPercentage = _isLandScape ? 0.7 : 0.3;

    final appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(widget.title),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => addNewTransaction(context, transactionData),
                )
              ],
            ),
          )
        : AppBar(
            title: Text(widget.title),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => {},
              )
            ],
          );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar,
            child: renderbody(
                _isLandScape, appBar, _chartHeightPercentage, transactionData),
          )
        : Scaffold(
            appBar: appBar,
            body: renderbody(
                _isLandScape, appBar, _chartHeightPercentage, transactionData),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => addNewTransaction(context, transactionData),
            ),
          );
  }
}
