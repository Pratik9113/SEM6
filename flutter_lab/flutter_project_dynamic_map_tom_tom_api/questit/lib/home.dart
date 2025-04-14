import 'package:flutter/material.dart';
import 'package:questit/task_cart.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TODOS',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          TaskCart(
            todoTitle: "Valentine Day",
            todoDescription: "QuestIT Workshop",
            todoDate: "14-02-2004",
            todoTime: "1:00 AM",
          ),
          TaskCart(
            todoTitle: "Valentine Day",
            todoDescription: "QuestIT Workshop",
            todoDate: "14-02-2004",
            todoTime: "1:00 AM",
          ),
          TaskCart(
            todoTitle: "Valentine Day",
            todoDescription: "QuestIT Workshop",
            todoDate: "14-02-2004",
            todoTime: "1:00 AM",
          ),
        ],
      ),
    );
  }
}
