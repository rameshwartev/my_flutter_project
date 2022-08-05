import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './models/transaction.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    print('build() My HomePage');
    return MaterialApp(
      title: 'Personal Expense',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
      theme: ThemeData(
        splashColor: Colors.amber,
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'CarterOne',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              button: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                // backgroundColor:Theme.of(context).primaryColor,
              ),
            ),
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        colorScheme: ColorScheme.light(),
        fontFamily: 'CarterOne',
        appBarTheme: AppBarTheme(
          titleTextStyle: (TextStyle(
            fontFamily: 'Quiksand',
            fontSize: 30,
            fontWeight: FontWeight.bold,
          )),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Transaction> txlist = [
    // Transaction(
    //   id: '1',
    //   title: 'New Shoes',
    //   amount: 69.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: '2',
    //   title: 'Groceries',
    //   amount: 20.22,
    //   date: DateTime.now(),
    // ),
  ];
  bool showChart = false;

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );
    setState(() {
      txlist.add(newTx);
    });
  }

  void deleteTransaction(String id) {
    setState(() {
      return txlist.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      elevation: 4,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: NewTransaction(_addNewTransaction),
        );
      },
    );
  }

  List<Transaction> get _recentTransactions {
    return txlist.where((tx) {
      return tx.date!.isAfter(
        DateTime.now().subtract(
          Duration(
            days: 7,
          ),
        ),
      );
    }).toList();
  }

  List<Widget> buildPortraitContent(
    AppBar appBar,
    Widget txListWidget,
  ) {
    return [
      Container(
          height: (MediaQuery.of(context).size.height -
                  appBar.preferredSize.height -
                  MediaQuery.of(context).padding.top) *
              0.3,
          child: Chart(_recentTransactions)),
      txListWidget
    ];
  }

  List<Widget> buildLandscapeContent(AppBar appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        const Text('Show Chart', style: TextStyle(fontFamily: 'CarterOne')),
          Switch.adaptive(
              value: showChart,
              onChanged: (val) {
                setState(() {
                  showChart = val;
                });
              })
        ],
      ),
      showChart
          ? Container(
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.7,
              child: Chart(_recentTransactions))
          : txListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = AppBar(
      title: Text(
        'Personal Expense',
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => startAddNewTransaction(context),
          // iconSize:
        ),
      ],
    );
    final txListWidget = Container(
      height: (MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          0.7,
      child: TransactionList(txlist, deleteTransaction),
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscape) ...buildLandscapeContent(appBar, txListWidget),
            if (!isLandscape) ...buildPortraitContent(appBar, txListWidget),

            // ListView.builder(
            //   shrinkWrap: true,
            //   itemCount: txlist.length,
            //   itemBuilder: (context, index) {
            //     final txItems = txlist[index];
            //     return ListTile(
            //     dense: true,
            //     title: Text("${txItems.id}  ${txItems.title}"),
            //     subtitle: Text("${txItems.amount}   ${txItems.date}"),
            //   );
            //   }
            // ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => startAddNewTransaction(context),
            ),
    );
  }
}
