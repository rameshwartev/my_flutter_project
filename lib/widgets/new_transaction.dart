import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class NewTransaction extends StatefulWidget {
  final Function addtx;
   NewTransaction(this.addtx){
    print('Construtor NewTransaction');
  }

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime? selectedDate;
  void submitData() {
    if (amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);
    if (enteredTitle.isEmpty || enteredAmount <= 0 || selectedDate == null) {
      return;
    }

    widget.addtx(
      enteredTitle,
      enteredAmount,
      selectedDate,
    );
    Navigator.of(context).pop();
  }

  void presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        selectedDate = pickedDate;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    print('Build() new_treansaction');
    return SingleChildScrollView(
      child:   Container(
          // padding: EdgeInsets.only(
          //   top: 10,
          //   left: 10,
          //   right: 10,
          //   bottom: MediaQuery.of(context).viewInsets.bottom,
          // ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Title',
                  fillColor: Colors.black87,
                ),
                controller: titleController,
                onSubmitted: (_) => submitData(),
                //  onChanged: (title) {
                // TitleInput = title;
                //}
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Amount',
                  fillColor: Colors.black87,
                ),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitData(),
                //onChanged: (amount) => AmountInput = amount,
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Text(
                      selectedDate == null
                          ? 'No Date Chosen!'
                          : 'Picked Date ${DateFormat.yMd().format(selectedDate!)}',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    TextButton(
                      child: Text(
                        'Choose Date',
                        style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Theme.of(context).primaryColor),
                      ),
                      onPressed: presentDatePicker,
                    )
                  ],
                ),
              ),
              ElevatedButton(
                  child: Text(
                    'Add Transaction',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.button!.color,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: submitData,
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor)),
            ],
          ),
        ),
      
    );
  }
}
