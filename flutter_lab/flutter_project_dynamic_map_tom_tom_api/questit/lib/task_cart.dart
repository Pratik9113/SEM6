import 'package:flutter/material.dart';

class TaskCart extends StatelessWidget {
  final String todoTitle;
  final String todoDescription;
  final String todoDate;
  final String todoTime;

  const TaskCart({
    super.key,
    required this.todoTitle,
    required this.todoDescription,
    required this.todoDate,
    required this.todoTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 247, 217),
        border: Border.all(
          style: BorderStyle.solid,
          width: 1.0,
          color: Color.fromARGB(255, 118, 118, 118),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Title : ${todoTitle}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "Description : ${todoDescription}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "Date : ${todoDate}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "Time : ${todoTime}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
