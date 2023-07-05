import 'package:expense_tracker/data/expense_data.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';

void main() async {
  // async is used whenever we use hive...

  //initialize Hive:
  await Hive.initFlutter();

  //open a hive database box;
   await Hive.openBox("expense_database2");




  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=>ExpenseData(),
      builder: (context,child)=> MaterialApp(
          debugShowCheckedModeBanner: false,
          home:Scaffold(
            appBar:  AppBar(
              title:Text('EXPENSE TRACKER',
              style: TextStyle(fontFamily: 'LexendPeta'),

            ),

          ),
        body:HomePage(),

        ),
      ),
    );

  }
}
//Sure! In simple terms, the provider package in Flutter helps you manage and share data (state) across different parts of your app. It's like a central store for your app's data.
//
// Imagine you have some information that multiple screens or widgets in your app need to access and use. Instead of passing that data manually from one widget to another, you can use the provider package.
//
// Here's how it works:
//
// You create a "provider" widget that holds the data you want to share. This widget can be placed at the top of your widget tree or at a relevant point where the data should be available.
//
// Other widgets in your app that need access to the data become "consumers" of the provider. They can listen to changes in the data and automatically update themselves whenever the data changes.
//
// When the data in the provider changes, the consumers are notified, and they rebuild themselves to reflect the updated data. This way, you don't need to manually pass the data around or handle the updates yourself.
