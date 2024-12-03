import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/db_helper.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  TextEditingController titilecontroller = TextEditingController();
  TextEditingController descController = TextEditingController();

  DbHelper dbHelper = DbHelper.instance;

  List<Map<String, dynamic>> tasks = [];
  String dueDate = "";
  DateFormat dtformate = DateFormat.MMMMEEEEd();

  @override
  void initState() {
    super.initState();
    getTask();
  }

  void getTask() async {
    tasks = await dbHelper.fetchalltask();
    print("updated all task list");
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do App'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                var task = tasks[index]; // 'task' refers to a single task (Map) at the current index
                return ListTile(
                  leading: Checkbox(
                      value: task['t_completed'] == 1,
                      onChanged: (bool? value) async {
                        if (value != null) {
                          print("updated checkbox");
                          String title = task['t_title'];
                          String desc = task['t_desc'];
                          await dbHelper.updateTask(
                              task['t_id'], title, desc, value);
                          getTask();
                        } 
                      }),
                  title: Text(
                    task['t_title'],
                    style: TextStyle(
                        decoration: task['t_completed'] == 1
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Desc:${task['t_desc']}"),
                      Text(dtformate.format(DateTime.fromMicrosecondsSinceEpoch(int.parse(tasks[index][DbHelper.TABLE_COLUMN_COMPLETEDATE])))),

                    ],
                  ),
                  //
                  // update and delete icon
                  //
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            titilecontroller.text = task["t_title"];
                            descController.text = task["t_desc"];
                            //
                            //
                            /////Update ShowModel bottomSheet
                            //
                            //
                            showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(21)),
                                ),
                                enableDrag: false,
                                builder: (_) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(21)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            "UPDATE TASK",
                                            style: TextStyle(fontSize: 21),
                                          ),
                                          SizedBox(
                                            height: 21,
                                          ),
                                          TextField(
                                            controller: titilecontroller,
                                            decoration: InputDecoration(
                                                label: Text("Title*"),
                                                hintText: "Enter Title",
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                )),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          TextField(
                                            controller: descController,
                                            maxLines: 3,
                                            decoration: InputDecoration(
                                                label: Text("Desc*"),
                                                hintText: "Enter Desc",
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                )),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              OutlinedButton(
                                                  onPressed: () async {
                                                    if (titilecontroller
                                                            .toString()
                                                            .isNotEmpty &&
                                                        descController.toString().isNotEmpty) {
                                                      bool isCompleted = task['t_completed'] == 1;

                                                      bool check = await dbHelper
                                                          .updateTask(
                                                              task['t_id'],
                                                              titilecontroller.text.toString(), titilecontroller.text.toString(),
                                                              isCompleted);

                                                      if (check) {
                                                        Navigator.pop(context);
                                                        getTask();
                                                      }
                                                    }
                                                  },
                                                  child: Text("Update")),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Cansel")),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          icon: Icon(Icons.edit)),
                      IconButton(
                          onPressed: () async {
                            bool check = await dbHelper.deleatenote(
                                id: tasks[index]["t_id"]);
                            if (check) {
                              getTask();
                            }
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: OutlinedButton(
              onPressed: () async {
                //
                // showmodelbottomsheet
                //
                //
                titilecontroller.clear();
                descController.clear();
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(21)),
                    ),
                    enableDrag: false,
                    context: context,
                    builder: (_) {
                      return Container(
                        padding: EdgeInsets.all(13),
                        height: 500,
                        width: double.infinity,
                        child: Column(
                          children: [
                            Text(
                              "ADD TASK",
                              style: TextStyle(fontSize: 21),
                            ),
                            SizedBox(
                              height: 11,
                            ),
                            TextField(
                              controller: titilecontroller,
                              decoration: InputDecoration(
                                  label: Text("Title*"),
                                  hintText: "Enter Title",
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  )),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            TextField(
                              controller: descController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                label: Text("Description*"),
                                hintText: "Enter Desc....",
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            OutlinedButton(
                                onPressed: ()async{
                                 DateTime ? SelectedDate = await showDatePicker(context: context,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2030, 12, 22));
                                 print(SelectedDate!.microsecondsSinceEpoch.toString());
                                 dueDate = SelectedDate.microsecondsSinceEpoch.toString();
                                },
                                child: Text("chooseDate")),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton(
                                    onPressed: () async {
                                      if (titilecontroller.text.isNotEmpty &&
                                          descController.text.isNotEmpty) {
                                        bool check = await dbHelper.addTask(
                                            title: titilecontroller.text.toString(),
                                            desc: descController.text.toString(),
                                          dueDateAt: dueDate,
                                        );
                                        if (check) {
                                          titilecontroller.clear();
                                          descController.clear();
                                          Navigator.pop(
                                              context); // Close the bottom sheet
                                          getTask(); // Refresh list
                                        }
                                        /*else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Failed to add task!')),
                                          );
                                        }*/
                                      }
                                      /*else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Title and description are required!')),
                                        );
                                      }*/
                                    },
                                    child: Text("ADD")),
                                SizedBox(
                                  width: 5,
                                ),
                                OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cansel")),
                              ],
                            ),
                          ],
                        ),
                      );
                    });
              },
              child: Text("Add Task"),
            ),
          ),
        ],
      ),
    );
  }
}
