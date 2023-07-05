

import 'package:expense_tracker/bar%20graph/bar_graph.dart';
import 'package:expense_tracker/data/expense_data.dart';
import 'package:expense_tracker/dateTime/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseSummary extends StatelessWidget {

  final DateTime? startOfWeek;


  const ExpenseSummary({
    Key? key,
    required this.startOfWeek,
  });

  //function to calculate the week total:
  double calculateWeekTotal(
      ExpenseData value,
      String Sunday,
      String Monday,
      String Tuesday,
      String Wednesday,
      String Thursday,
      String Friday,
      String Saturday,
      ){
    List<double> values=[
      value.calculateDailyExpenseSummary()[Sunday] ?? 0,
      value.calculateDailyExpenseSummary()[Monday] ?? 0,
      value.calculateDailyExpenseSummary()[Tuesday] ?? 0,
      value.calculateDailyExpenseSummary()[Wednesday] ?? 0,
      value.calculateDailyExpenseSummary()[Thursday] ?? 0,
      value.calculateDailyExpenseSummary()[Friday] ?? 0,
      value.calculateDailyExpenseSummary()[Saturday] ?? 0,
    ];
    double total=0;
    for(int i=0;i<values.length;i++){
      total+=values[i];
    }
    return total;

  }

  //as the bargraph exceeds the screen:
  double calculateMax(
      ExpenseData value,
      String Sunday,
      String Monday,
      String Tuesday,
      String Wednesday,
      String Thursday,
      String Friday,
      String Saturday,
      ){
    double? max=100;
    List<double> values=[
      value.calculateDailyExpenseSummary()[Sunday] ?? 0,
      value.calculateDailyExpenseSummary()[Monday] ?? 0,
      value.calculateDailyExpenseSummary()[Tuesday] ?? 0,
      value.calculateDailyExpenseSummary()[Wednesday] ?? 0,
      value.calculateDailyExpenseSummary()[Thursday] ?? 0,
      value.calculateDailyExpenseSummary()[Friday] ?? 0,
      value.calculateDailyExpenseSummary()[Saturday] ?? 0,

    ];
    //sort from smallest to the largest:
    values.sort();
    //get the largest amount which is at the end of the sorted list ..
    //and increase the cap(edge of a individual graph ) so that the bar looks full:
    max = values.last*1.3 ;
    return max==0? 100:max;//means if it 0 then the default size be 100
  }

  @override
  Widget build(BuildContext context) {
//get yyyymmdd for each days of this week:
  String sunday = convertDateTimeToString(startOfWeek!.add(const Duration(days: 0)));
  String monday = convertDateTimeToString(startOfWeek!.add(const Duration(days: 1)));
  String tueday = convertDateTimeToString(startOfWeek!.add(const Duration(days: 2)));
  String wednesday = convertDateTimeToString(startOfWeek!.add(const Duration(days: 3)));
  String thursday = convertDateTimeToString(startOfWeek!.add(const Duration(days: 4)));
  String friday = convertDateTimeToString(startOfWeek!.add(const Duration(days: 5)));
  String saturday = convertDateTimeToString(startOfWeek!.add(const Duration(days: 6)));

    return Consumer<ExpenseData>(
        builder: (context,value,child)=> Column(
          children: [
            //week Total:
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  Text('Week Total : ',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  Text(' ₹${calculateWeekTotal(
                      value,
                      sunday,
                      monday,
                      tueday,
                      wednesday,
                      thursday,
                      friday,
                      saturday)}',style: TextStyle(color: Colors.greenAccent,fontWeight: FontWeight.bold),)
                ],
              ),
            ),

            //barGraph:
            SizedBox(
            height:230,
            child: MyBarGraph(
                maxY: calculateMax(value,
                    sunday,
                    monday,
                    tueday,
                    wednesday,
                    thursday,
                    friday,
                    saturday,
                ),
                SunAmount: value.calculateDailyExpenseSummary()[sunday]??0,
                MonAmount: value.calculateDailyExpenseSummary()[monday]??0,
                TueAmount:  value.calculateDailyExpenseSummary()[tueday]??0,
                WedAmount:value.calculateDailyExpenseSummary()[wednesday]??0,
                ThuAmount:value.calculateDailyExpenseSummary()[thursday]??0,
                FriAmount: value.calculateDailyExpenseSummary()[friday]??0,
                SatAmount: value.calculateDailyExpenseSummary()[saturday]??0,
            ),
      ),
          ],
        )

    );
  }
}
