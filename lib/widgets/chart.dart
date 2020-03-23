import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './chat_bar.dart';

class Chart extends StatelessWidget {
  Chart({this.recentTransaction});

  final List<Transaction> recentTransaction;

  List<Map<String, Object>> get groupTransaction {
    return List.generate(7, (int index) {
      var weekDay = DateTime.now().subtract(Duration(days: index));

      double totalSum = 0.0;

      recentTransaction.forEach((tx) {
        if (DateTime(tx.date.year, tx.date.month, tx.date.day) ==
            DateTime(weekDay.year, weekDay.month, weekDay.day)) {
          totalSum += tx.amount;
        }
      });
      return {"day": DateFormat.E().format(weekDay), "amount": totalSum};
    });
  }

  double get totalAmount =>
      groupTransaction.fold(0.0, (sum, item) => sum + item["amount"]);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(15),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupTransaction.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                label: data["day"],
                spendAmount: data["amount"],
                spendPrcAmount: totalAmount == 0.0
                    ? 0.0
                    : (data["amount"] as double) / totalAmount,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
