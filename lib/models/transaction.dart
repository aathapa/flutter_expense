import 'package:flutter/foundation.dart';

class Transaction {
  Transaction({
    @required this.amount,
    @required this.title,
    @required this.date,
  });

  final double amount;
  final String title;
  final DateTime date;
}

class TransactionHandler with ChangeNotifier {
  List<Transaction> transactionList = [];

  void addTransaction(Transaction transaction) {
    transactionList.add(transaction);
    notifyListeners();
  }

  void removeTransaction(int index) {
    transactionList.removeAt(index);
    notifyListeners();
  }
}
