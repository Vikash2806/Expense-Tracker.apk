import 'dart:math';

import 'package:expense_tracker/models/expense_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:core';


class HiveDatabase{
  //reference Box
  final _myBox=Hive.box("expense_database2");

  //write   data:
void saveData(List<ExpenseItem> allExpense){

  /*
Hive can store only strings and dateTime, and not custom objects like ExpenseItem
So lets convert ExpenseItem object in type that can be stored in our db

allExpense=
[

ExpenseItem(name / amount / dataTime)

]

so that above object with three values must be converted into a list that has all three value:

[
[name, amount ,dateTime ],// so its kind of list inside a list
]

 */

  List<List<dynamic>> allExpenseFormatted = [];
  //   List<List<dynamic>>: This specifies the data type of the variable allExpenseFormatted. It is a list that contains other lists. The outer list (List<List<...>>) represents the main list, and each element within the main list is an inner list.
//
//   dynamic: The inner lists can contain elements of any data type. The dynamic keyword in Dart allows for dynamic typing, meaning that the type of the elements can be determined at runtime.
//
//   allExpenseFormatted: This is the name of the variable that holds the list of lists.
//
//   = [];: This assigns an empty list ([]) to the allExpenseFormatted variable as its initial value. The [] syntax represents an empty list literal.



  for(var expense in allExpense){
    //convert each expenseItem into a list of storable types(strings,dateTime)
    List<dynamic> expenseFormatted=[
      expense.name,
      expense.amount,
      expense.dateTime,
    ];

    allExpenseFormatted.add(expenseFormatted);

  }

  //finally lets store in our database:
  _myBox.put("ALL_EXPENSES",allExpenseFormatted);//entering all the expense list inside a single database box"ALL_EXPENSE"

}
//read data
List<ExpenseItem> readData(){
  /*
  Data is stored in database as a  list of Strings + dateTime
  so lets convert our saved data  into ExpenseItem objects

   savedData=[
      [name, amount, dateTime]
   ]
    must be converted into:

    [

    ExpenseItem(name/amount/dateTime);

    ]

   */


  List savedExpenses=_myBox.get("ALL_EXPENSES")?? [];//means if it returns a null then return an empty list!!
  List<ExpenseItem> allExpenses=[];
  for(int i=0; i<savedExpenses.length;i++){
// i is the i'th particular list..
    String name=savedExpenses[i][0];
    String amount=savedExpenses[i][1];
    DateTime dateTime= savedExpenses[i][2];
    //create the expense item:
    ExpenseItem expense=ExpenseItem(
        name: name,
        amount: amount,
        dateTime:dateTime,
    );

    //add expense to over all expense list:
    allExpenses.add(expense);
  }
  return allExpenses;

}

}

