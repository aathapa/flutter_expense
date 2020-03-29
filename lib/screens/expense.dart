import 'package:expenses/models/transaction.dart';
import 'package:expenses/widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:expenses/widgets/add_transaction.dart';
import 'package:expenses/widgets/chart.dart';
import 'package:provider/provider.dart';

class Expense extends StatelessWidget {
  Expense({this.title});

  final String title;

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

  @override
  Widget build(BuildContext context) {
    TransactionHandler transactionData =
        Provider.of<TransactionHandler>(context);

    final appBar = AppBar(
      title: Text(title),
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
            Container(
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.3,
              child: Chart(
                recentTransaction: _recentTransaction(transactionData),
              ),
            ),
            Container(
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height) *
                  0.7,
              child: TransactionList(
                transactionData: transactionData,
              ),
            )
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
