import 'package:flutter/material.dart';
import '../models/transaction.dart';
import'./transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transaction;
  final Function deleteTx;
  TransactionList(this.transaction, this.deleteTx){
    print('Constructer trasactionList');
  }
  @override
  Widget build(BuildContext context) {
    print('Build transactionList');
    return transaction.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: [
                Text(
                  'No transactions added yet!',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: constraints.maxHeight * 0.7,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : ListView(
          children:[ ...transaction.map((tx)=> 
           TransactionItem(
            key: ValueKey(tx.id),
            transaction: tx,
             deleteTx: deleteTx,),).toList()
          
              
           ] );
            
        
  }
}

