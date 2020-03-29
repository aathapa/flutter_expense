import 'package:flutter/material.dart';
import 'package:expenses/models/transaction.dart';

import 'package:jiffy/jiffy.dart';

class TransactionList extends StatelessWidget {
  TransactionList({@required this.transactionData});

  final TransactionHandler transactionData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: transactionData.transactionList.length,
        itemBuilder: (BuildContext context, int index) {
          Transaction transaction = transactionData.transactionList[index];
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Card(
              elevation: 5,
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  child: Padding(
                    padding: EdgeInsets.all(6),
                    child: FittedBox(
                      child: Text(
                        '\$${transaction.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                title: Text(
                  transaction.title,
                  style: Theme.of(context).textTheme.title,
                ),
                subtitle: Text(
                  Jiffy(transaction.date).format('MMMM do yyyy'),
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: GestureDetector(
                  child: Icon(Icons.delete, color: Colors.red),
                  onTap: () => transactionData.removeTransaction(index),
                ),
              ),
            ),
          );
        });
  }
}
