import 'package:flutter/material.dart';
import 'package:todo_app/db_helper.dart';

class Homepage extends StatefulWidget{
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
DbHelper dbHelper =DbHelper.instance;

  List<Map<String, dynamic>> tasks = [];

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  void fetchTasks() async{
    tasks = await dbHelper.fetchalltask();
    setState(() {

    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do App'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task['t_title']),
                  subtitle: Text("Due: ${task['t_duedate']}"),
                  trailing: Text(task['t_is_completed'] == 1
                      ? "Completed"
                      : "Pending"),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                bool result = await dbHelper.addTask(
                  title: "Finish Homework",
                  desc: "Complete the math and science homework.",
                  isCompleted: 0,
                  dueDate: "2024-11-20",
                  completeDate: "",
                );

                if (result) {
                  print("Task added successfully!");
                  fetchTasks();
                } else {
                  print("Failed to add task.");
                }
              },
              child: Text("Add Sample Task"),
            ),
          ),
        ],
      ),
    );
  }
}