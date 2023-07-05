import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExpenseTile extends StatelessWidget {
  final String name;
  final String amount;
  final DateTime dateTime;
  void Function(BuildContext)? deleteTapped;

  ExpenseTile({
    super.key,
    required this.name,
    required this.amount,
    required this.dateTime,
    required this.deleteTapped,

  }) ;

  @override
  Widget build(BuildContext context) {
    return  Slidable(
      endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            // delete option
            SlidableAction(
              onPressed: deleteTapped,
              backgroundColor: Colors.red.shade400,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(18),
            ),

          ]),
      child: ListTile(
        title: Text( name,
          style: TextStyle(color:Colors.lightBlueAccent),
        ),
        subtitle: Text('${dateTime.day}/${dateTime.month}/${dateTime.year}',
            style: TextStyle(color:Colors.blueGrey)),
        trailing: Text('₹${amount} ',
            style: TextStyle(color:Colors.greenAccent)),
      ),

    );
  }
}
