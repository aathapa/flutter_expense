import 'package:flutter/material.dart';
import 'screens/expense.dart';
import 'package:provider/provider.dart';
import 'package:expenses/models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 20,
                ),
              ),
        ),
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<TransactionHandler>(
            create: (_) => TransactionHandler(),
          )
        ],
        child: Expense(
          title: 'Personal Expenses',
        ),
      ),
    );
  }
}
