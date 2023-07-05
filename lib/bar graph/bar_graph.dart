

import 'package:expense_tracker/bar%20graph/bar_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarGraph extends StatelessWidget {
  final double? maxY;
  final double SunAmount;
  final double MonAmount;
  final double TueAmount;
  final double WedAmount;
  final double ThuAmount;
  final double FriAmount;
  final double SatAmount;

  const MyBarGraph({
    Key? key,
    required this.maxY,
    required this.SunAmount,
    required this.MonAmount,
    required this.TueAmount,
    required this.WedAmount,
    required this.ThuAmount,
    required this.FriAmount,
    required this.SatAmount,
  });

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
      SunAmount: SunAmount,
      MonAmount: MonAmount,
      TueAmount: TueAmount,
      WedAmount: WedAmount,
      ThuAmount: ThuAmount,
      FriAmount: FriAmount,
      SatAmount: SatAmount,
    );

    myBarData.initializeBarData(); // Custom created method in bar_data.dart
    return BarChart(
        BarChartData(

            maxY: maxY,
            minY: 0,
            titlesData: FlTitlesData(
              show: true,
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false,)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                    getTitlesWidget:getBottomTitles
                  )
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              drawHorizontalLine: true,
            ),
            barGroups:myBarData.barData
                .map(
                    (data) => BarChartGroupData(
                        x: data.x,
                    barRods: [
                      BarChartRodData(
                          toY: data.y,
                        color: Colors.lightBlueAccent,
                        width: 25,
                        borderRadius: BorderRadius.circular(4),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY:  maxY,
                          color: Colors.blueGrey,

                        )
                      ),
                    ],
                    ),
            ).toList()


        )
    );
  }
}

Widget getBottomTitles(double value,TitleMeta meta){
  const style=TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w300,
    fontSize: 14,
  );
  Widget text;
  switch(value.toInt()){
    case 0:
      text=const Text('Sun',style: style);
      break;
    case 1:;
      text=const Text('Mon',style: style);
      break;
    case 2:
      text=const Text('Tue',style: style);
      break;
    case 3:
      text=const Text('Wed',style: style);
      break;
    case 4:;
      text=const Text('Thu',style: style);
      break;
    case 5:
      text=const Text('Fri',style: style);
      break;
    case 6:
      text=const Text('Sat',style: style);
      break;
    default:
      text=const Text( '',style: style);

  }
  return SideTitleWidget(
      child: text,
      axisSide: meta.axisSide,
  );

}

