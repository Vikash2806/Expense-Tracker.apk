import 'package:expense_tracker/data/hive_database.dart';
import 'package:expense_tracker/dateTime/date_time_helper.dart';
import 'package:expense_tracker/models/expense_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
;

class ExpenseData extends ChangeNotifier {
  //list of All expenses
  List<ExpenseItem> overallExpenseList =[];
  //get expense list
  List<ExpenseItem> getallExpenseList(){
    return overallExpenseList;

  }

  //prepare data to display:
  final db=HiveDatabase();
  void prepareData(){
    //if there exist data then get it:
    if(db.readData().isNotEmpty){
      overallExpenseList=db.readData();
    }
  }


  //add new expense
  void addNewExpense(ExpenseItem newExpense){
    overallExpenseList.add(newExpense);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  // In Flutter, notifyListeners() is a method provided by the ChangeNotifier class. It is used to notify any listeners that are registered to the ChangeNotifier instance that a change has occurred in its state.
  //
  // When notifyListeners() is called, it triggers a rebuild of the widget subtree that depends on the ChangeNotifier instance. This means that any widgets that are listening to the ChangeNotifier will be rebuilt, and their UI will be updated to reflect the new state.
  //
  // Typically, notifyListeners() is called after making changes to the state managed by the ChangeNotifier object. For example, if you add a new expense to the overallExpenseList in the ExpenseData class, you would call notifyListeners() to inform any listening widgets that the expense list has been updated.

  //delete expense
  void deleteExpense(ExpenseItem Expense){
    overallExpenseList.remove(Expense);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  //get weekday (mon, tue ...) from a dateTime object
  String getDayName(DateTime dateTime){
    switch(dateTime.weekday){//. The weekday property of the DateTime class in Dart returns an integer representing the day of the week, where Monday is represented by 1 and Sunday is represented by 7.
      case 1:
        return "Mon";
      case 2:
        return "Tue";
      case 3:
        return "Wed";
      case 4:
        return "Thu";
      case 5:
        return "Fri";
      case 6:
        return "Sat";
      case 7:
        return "Sun";

      default:
        return " ";

    }
  }

  //get the date for the start of the week(sunday)

  DateTime? startOfWeekDate(){
    DateTime? startOfWeek;
    //get todays date:
    DateTime today=DateTime.now();
    //go backward from today to find sunday:
    for(int i=0;i<7;i++){
      if(getDayName(today.subtract(Duration(days: i)))=='Sun'){
        startOfWeek=today.subtract(Duration(days:i));
      }
    }
    return startOfWeek;
  }

  /*

  convert all list of expenses into a daily expense summary

  eg:
  overallExpense=[

  [food, 2023/01/30,$5],
  [hat, 2023/01/30,$52],
  [drink, 2023/02/21,$15],
  [lunch, 2023/05/23,$55],
  [food, 2023/03/13,$75],
  [food, 2023/016/20,$85],

  ]

  Daily ExpensesSummary =
  [
  [20230131:$25],
  [20230114:$26],
  [20230223:$30],
  [20230213:$24],
]
   */

  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {
      //date(yyyymmdd):amountTotalForDay
    };


//a for loop to go through each expense:
// here dailyExpenseSummary is like dictionary in python but its a map which can be accessed like array but not number here accessed with key ..
//in this for loop the expense is added to the date and if the date key is already presesnt in dailyExpenseSummary then the amount is added to the amount already present in that date if the date is not presesnt then new date key is created and the amount is added there
    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount); //parse converts the amount format to double dataype

      //here key is date is we mentioned above in the Overall expense List so we access values through the date!!
      if (dailyExpenseSummary.containsKey(date)) {
        double currentAmount = dailyExpenseSummary[date]!; //retriving the amount from date as key
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount; //updating the value
      }
      else {
        dailyExpenseSummary.addAll({date: amount}); //if date is not present condition
      }
    }
    return  dailyExpenseSummary;
  }

}
