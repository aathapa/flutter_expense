import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  ChartBar({this.label, this.spendAmount, this.spendPrcAmount});

  final String label;
  final double spendAmount;
  final double spendPrcAmount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FittedBox(child: Text('\$${spendAmount.toStringAsFixed(0)}')),
        SizedBox(
          height: 4,
        ),
        Container(
          height: 60,
          width: 10,
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    color: Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(10)),
              ),
              FractionallySizedBox(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                ),
                heightFactor: spendPrcAmount,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text('$label')
      ],
    );
  }
}
