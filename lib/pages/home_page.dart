

import 'dart:math';

import 'package:expense_tracker/components/expense_summary.dart';
import 'package:expense_tracker/components/expense_tile.dart';
import 'package:expense_tracker/data/expense_data.dart';
import 'package:expense_tracker/data/hive_database.dart';
import 'package:expense_tracker/models/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//text controllers:
  final newExpenseNameController=TextEditingController();
  final newExpenseAmountController=TextEditingController();


  //in our initial stage when the app just fires up:
  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      Provider.of<ExpenseData>(context,listen: false).prepareData();

    //   Provider.of<ExpenseData>: This is a method call to access an instance of the ExpenseData class using the Provider package. Provider.of<T> is a generic method that allows you to retrieve the value of the provided object of type T. In this case, it is retrieving an instance of ExpenseData.
    //
    // context: The context is a parameter that is typically available in Flutter widget classes. It represents the current build context of the widget tree. It is required for accessing providers and other services provided higher up in the widget tree.
    //
    // listen: false: This is an optional parameter passed to the Provider.of method. It specifies whether the widget should listen for changes to the provided object. By setting listen to false, the widget will not rebuild when the value of ExpenseData changes. This is useful when you only need to access the data once and don't need to react to subsequent changes.
    //
    //     .prepareData(): This is a method call on the ExpenseData instance retrieved from the provider. It invokes the prepareData() method, which presumably prepares the data used by the widget.
    //
    // Overall, this code is calling the prepareData() method of the ExpenseData class obtained from the provider, indicating that it should not listen for changes to the ExpenseData object. This is typically used in the initState() method of a widget to perform initialization tasks or fetch data before the widget is fully built.
    //

    }



//add new expense
  void addnewExpense(){
    showDialog(
        context: context,
        builder: (context)=>AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:BorderRadius.circular(10)
          ),
          backgroundColor: Colors.white,
          title: Text('Add new expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //expense name:
              TextField(
                controller: newExpenseNameController,
                decoration: InputDecoration(
                  hintText: 'Expense name'
                ),
              ),

              //expense amount:
              TextField(
                controller: newExpenseAmountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: 'Rupees'
                ),
              ),
            ],
          ),
          actions: [
            MaterialButton(
                onPressed: onCancel,
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.red.shade900,
                shape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                )
            ),
            MaterialButton(
                onPressed: onSave,
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.black),
                ),
                color: Colors.lightBlueAccent,

                shape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                )
            ),
          ],
        )
    );
  }

//delete the expense:
  void deleteExpense(ExpenseItem expense){
    Provider.of<ExpenseData>(context,listen: false).deleteExpense(expense);
  }


//save:
  void onSave() {
    //to check if that we are not submitting empty string on textfield:

    if (newExpenseNameController.text.isNotEmpty &&
        newExpenseAmountController.text.isNotEmpty) {

      //to show a alert box if the amount entered exceeds 1cr:
      final double expenseAmount=double.parse(newExpenseAmountController.text);
      // Check if the expense amount exceeds the limit:
      if(expenseAmount>10000000){
        showDialog(
            context: context,
            builder: (context)=>AlertDialog(
              title: Text('Amount Limit Exceeded :('),
              content: Text('The expense amount cannot exceed 1 crore .'),
              actions: [
                TextButton(
                    onPressed: (){
                      Navigator.pop(context);//pop the alertbox..
                      clear();
                    },
                    child: Text("OK")
                )
              ],
            )
        );
        return;//Stop execution and prevent the expense
      }


      ExpenseItem newExpense= ExpenseItem(
        name: newExpenseNameController.text,
        amount: newExpenseAmountController.text,
        dateTime:DateTime.now(),
      );
      //add new expense:
      Provider.of<ExpenseData>(context,listen: false).addNewExpense(newExpense);//passes newExpense to the next dart page i.e, to expense_data.dart

      //   In the code snippet you provided, the line Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense); is responsible for adding a new expense item to the ExpenseData object using the Provider package.
      //
      //   Let's break down the code and explain each part:
      //
      //   Provider.of<ExpenseData>(context, listen: false): This part retrieves the ExpenseData object from the widget tree using the Provider.of method. It looks for the nearest ancestor widget that provides an ExpenseData object and returns it. The context parameter refers to the current build context. The listen parameter is set to false, indicating that the widget doesn't need to rebuild when the ExpenseData object changes.
      //
      //       .addNewExpense(newExpense): Once the ExpenseData object is obtained, the .addNewExpense(newExpense) method is called on it. This method is responsible for adding a new expense item to the overallExpenseList list within the ExpenseData object. The newExpense object contains the name, amount, and date-time of the new expense item.
      //
      //   To summarize, this code snippet uses the Provider package to access the ExpenseData object from the widget tree. It then calls the addNewExpense method on the retrieved ExpenseData object to add a new expense item to the list. This allows for data sharing and management across different parts of the application using the ExpenseData provider.
      //

    }

      Navigator.pop(context);
      clear();

  }

  //cancel:
  void onCancel(){

    Navigator.pop(context);
    clear();
  }

  void clear(){
    newExpenseNameController.clear();
    newExpenseAmountController.clear();
  }

  //to get expense by date in search
  List<ExpenseItem> getExpensesByDate(DateTime selectedDate) {
    final allExpenses = HiveDatabase().readData();
    return allExpenses.where((expense) {
      final expenseDate = expense.dateTime;
      return expenseDate.year == selectedDate.year &&
          expenseDate.month == selectedDate.month &&
          expenseDate.day == selectedDate.day;
    }).toList();
  }




  void _showDatePicker(BuildContext context, ExpenseData value) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),//The initial date to display in the date picker. In this case, it is set to the current date using DateTime.now()
      firstDate: DateTime(2023),//The earliest date that can be selected. It is set to January 1, 2023.
      lastDate: DateTime.now(),//The latest date that can be selected. It is set to the current date.
    );

    if (selectedDate != null) {
      final expensesForSelectedDate =getExpensesByDate(selectedDate);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Expenses on ${selectedDate.toString()}'),
          content: ListView.builder(
            shrinkWrap: true,
            itemCount: expensesForSelectedDate.length,
            itemBuilder: (context, index) {
              final expense = expensesForSelectedDate[index];
              return ListTile(
                title: Text(expense.name),
                subtitle: Text(expense.amount),
                onTap: () {
                  // Handle expense tile tap if needed
                },
              );
            },
          ),
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    // Consumer<ExpenseData>: This widget is part of the provider package and is used to subscribe to changes in the ExpenseData object(When changes occur to the ExpenseData object, such as adding a new expense or deleting an existing expense, the Consumer widget detects these changes and triggers a rebuild of the widget subtree defined in the builder callback. This ensures that the UI reflects the updated state of the ExpenseData object.). It listens for changes and automatically rebuilds the widget subtree whenever the ExpenseData object changes.
    //
    // builder: (context, value, child) => Scaffold(...): The builder function is a callback that takes three parameters: context, value, and child. It defines the widget tree that will be rebuilt when the ExpenseData object changes. In this case, it returns a Scaffold widget.
    //
    // context: The current build context.
    //
    // value: The value of the ExpenseData object obtained from the provider. It represents the current state of the ExpenseData object.
    //
    // child: The child widget passed to the Consumer widget.
    return Consumer<ExpenseData>(
        builder: (context, value ,child)=>Scaffold(
        backgroundColor: Colors.grey[900],
            floatingActionButton: Column(
              mainAxisAlignment:MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                onPressed: addnewExpense,
                child:Icon(Icons.add)
                ),
                const SizedBox(height: 30),
                FloatingActionButton(
                  onPressed: () {
                    _showDatePicker(context, value);
                  },
                  child: Icon(Icons.search),
                ),

              ],
            ),

        body: ListView(
          children: [

            // weekly summary:
            ExpenseSummary(startOfWeek: value.startOfWeekDate()),
            const SizedBox(height: 30,),
            //expense data:
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: value.getallExpenseList().length ,
                itemBuilder: (context,index) {
                  return Row(
                    children: [
                      Expanded(
                        child: ExpenseTile(
                          name: value.getallExpenseList()[index].name,
                          amount: value.getallExpenseList()[index].amount,
                          dateTime: value.getallExpenseList()[index].dateTime,
                          deleteTapped: (p0) =>
                              deleteExpense(value.getallExpenseList()[index]),
                        ),
                        
                      ),
                      Icon(Icons.arrow_left_sharp,color: Colors.white,),
                    ],
                  );
                }
            )
          ],
        )
    )
    );
  }
}

