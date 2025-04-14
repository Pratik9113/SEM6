import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AddTask> {
  final TextEditingController _todoTitle = TextEditingController();
  final TextEditingController _todoDescription = TextEditingController();
  final TextEditingController _todoDate = TextEditingController();
  final TextEditingController _todoTime = TextEditingController();

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _todoDate.text =
            "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
      });
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _todoTime.text = pickedTime.format(context);
      });
    }
  }

  Future<void> _uploadTask() async {
    if (_todoTitle.text.isEmpty ||
        _todoDescription.text.isEmpty ||
        _todoDate.text.isEmpty ||
        _todoTime.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields!")),
      );
      return;
    }
    try {
      final data = await FirebaseFirestore.instance.collection("tasks").add(
        {
          "title": _todoTitle.text.trim(),
          "description": _todoDescription.text.trim(),
          "date": _todoDate.text.trim(),
          "time": _todoTime.text.trim()
        },
      );
      _todoTitle.clear();
      _todoDescription.clear();
      _todoDate.clear();
      _todoTime.clear();
      print(data.id);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add task!")),
      );
    }
  }

  @override
  void dispose() {
    _todoTitle.dispose();
    _todoDescription.dispose();
    _todoDate.dispose();
    _todoTime.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Todos')),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 35,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: TextField(
              controller: _todoTitle,
              decoration: InputDecoration(
                labelText: 'Enter your todo title',
                labelStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: TextField(
              controller: _todoDescription,
              decoration: InputDecoration(
                labelText: 'Enter your todo description',
                labelStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: TextField(
              controller: _todoDate,
              decoration: InputDecoration(
                labelText: 'Enter your Date',
                suffixIcon: Icon(Icons.calendar_month),
                labelStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
                border: OutlineInputBorder(),
              ),
              onTap: _pickDate,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: TextField(
              controller: _todoTime,
              decoration: InputDecoration(
                labelText: 'Enter your Time',
                suffixIcon: Icon(Icons.timelapse),
                labelStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
                border: OutlineInputBorder(),
              ),
              onTap: _pickTime,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () async {
                await _uploadTask();
              },
              child: Text(
                'ADD TODO',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
