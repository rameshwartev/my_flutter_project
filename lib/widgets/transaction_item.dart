import 'dart:math';


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.deleteTx,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTx;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  MaterialColor? bgColor; 
  void initState() {
    const availableColors = [
      Colors.red,
      Colors.blue,
      Colors.lightGreen,
      Colors.purple,
    ];
    bgColor = availableColors[Random().nextInt(4)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      // shadowColor: Colors.blue,
      margin: EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 8,
      ),
      child: ListTile(
          leading: CircleAvatar(
            backgroundColor: bgColor,
            radius: 35,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: FittedBox(
                child: Text(
                  '\$${widget.transaction.amount}',
                ),
              ),
            ),
          ),
          title: Text(
            widget.transaction.title!,
            style: Theme.of(context).textTheme.headline6,
          ),
          subtitle: Text(
            DateFormat.yMMMd().format(
              widget.transaction.date!,
            ),
            style: TextStyle(
              color: Colors.black87,
            ),
          ),
          trailing: MediaQuery.of(context).size.width > 460
              ? TextButton.icon(
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).errorColor,
                  ),
                  label: Text(
                    'Delete',
                    style: TextStyle(
                      color: Theme.of(context).errorColor,
                    ),
                  ),
                  onPressed: () => widget.deleteTx(
                        widget.transaction.id,
                      ))
              : IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).errorColor,
                  ),
                  onPressed: () => widget.deleteTx(widget.transaction.id),
                )),
    );
  }
}
