import 'package:expenses/models/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class AddTransaction extends StatefulWidget {
  AddTransaction({@required this.transactionData});

  final TransactionHandler transactionData;

  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  DateTime selectedDate;

  void submitData() {
    String title = titleController.text;
    double amount = amountController.text.isEmpty
        ? 0.0
        : double.parse(amountController.text);
    if (title.isEmpty || amount <= 0 || selectedDate == null) {
      return;
    }
    widget.transactionData.addTransaction(
      Transaction(
        amount: amount,
        title: title,
        date: selectedDate ?? DateTime.now(),
      ),
    );
    Navigator.of(context).pop();
    titleController.text = '';
    amountController.text = '';
  }

  void _onPressDateTimeButton() async {
    DateTime selectedDateFromPicker = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018, 01, 01),
      lastDate: DateTime.now(),
    );

    if (selectedDateFromPicker != null) {
      setState(() {
        selectedDate = selectedDateFromPicker;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(selectedDate?.DateFormat.yMMMd().format(selectedDate) ?? "no value");
    var shownDate = selectedDate != null
        ? 'Picked Date: ${DateFormat.yMd().format(selectedDate)}'
        : "No choosen date";
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
              onSubmitted: (_) => submitData(),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              controller: amountController,
              onSubmitted: (_) => submitData(),
            ),
            Container(
              height: 80,
              child: Row(
                children: [
                  Expanded(child: Text(shownDate)),
                  FlatButton(
                    child: Text(
                      'Choose date',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => _onPressDateTimeButton(),
                  )
                ],
              ),
            ),
            RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text(
                'Add Transaction',
                style: TextStyle(
                  color: Theme.of(context).textTheme.button.color,
                ),
              ),
              onPressed: () => submitData(),
            )
          ],
        ),
      ),
      elevation: 4,
    );
  }
}
