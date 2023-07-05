import 'package:expense_tracker/bar%20graph/individual_bar.dart';

class BarData{
  final double SunAmount;
  final double MonAmount;
  final double TueAmount;
  final double WedAmount;
  final double ThuAmount;
  final double FriAmount;
  final double SatAmount;

  BarData({
    required this.SunAmount,
    required this.MonAmount,
    required this.TueAmount,
    required this.WedAmount,
    required this.ThuAmount,
    required this.FriAmount,
    required this.SatAmount,

  });

  List<IndividualBar> barData=[];

//initializing bar data:

  void initializeBarData(){
    barData =[
      //y is gonna be the amount for each day and x is gonna be 1,2,3...
      //Sunday:
      IndividualBar(x: 0, y: SunAmount),
      //Mon
      IndividualBar(x: 1, y: MonAmount),
      //Tue
      IndividualBar(x: 2, y: TueAmount),
      //Wed
      IndividualBar(x: 3, y: WedAmount),
      //Thu
      IndividualBar(x: 4, y: ThuAmount),
      //Fri
      IndividualBar(x: 5, y: FriAmount),
      //Sat
      IndividualBar(x: 6, y: SatAmount),

    ];
  }
}



