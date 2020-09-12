import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/helper_functions/helper_functions.dart';
import 'package:flutter_todo/services/database.dart';
import 'package:flutter_todo/widgets/widget.dart';

class Home extends StatefulWidget {
  String username;
  String userEmail;
  Home({this.username, this.userEmail});
  @override
  _HomeState createState() => _HomeState();
}

String uid = "cQjyqzkq5jcNYPAZQpq6ffEbZqp1";

class _HomeState extends State<Home> {
  Stream<QuerySnapshot> taskStream;
  DatabaseServices databaseServices = new DatabaseServices();
  String date;
  TextEditingController taskEdittingController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    databaseServices.getTasks(uid).then((val) {
      taskStream = val;
      setState(() {});
    });

    var now = DateTime.now();
    date =
        "${HelperFunctions.getWeek(now.weekday)} ${HelperFunctions.getYear(now.month)} ${now.day}";
  }

  Widget taskList() {
    return StreamBuilder<QuerySnapshot>(
      stream: taskStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.only(top: 16),
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return TaskTile(
                    snapshot.data.documents[index].data["isCompleted"],
                    snapshot.data.documents[index].data["task"],
                    snapshot.data.documents[index].documentID,
                  );
                })
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Widgets().mainAppbar(),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            width: 600,
            child: Column(
              children: [
                Text(
                  "My Day",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text("$date"),
                Row(
                  children: [
                    Expanded(
                      // width: 500,
                      child: TextField(
                        controller: taskEdittingController,
                        decoration: InputDecoration(hintText: "task"),
                        onChanged: (val) {
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(width: 6),
                    taskEdittingController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              Map<String, dynamic> taskMap = {
                                "task": taskEdittingController.text,
                                "isCompleted": false,
                              };
                              DatabaseServices().updateTask(uid, taskMap);
                              taskEdittingController.text = "";
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 5),
                                child: Text("ADD")))
                        : Container(),
                  ],
                ),
                Container(child: taskList())
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TaskTile extends StatefulWidget {
  final bool isCompleted;
  final String task;
  final String documentId;

  TaskTile(this.isCompleted, this.task, this.documentId);

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Map<String, bool> taskMap = {
                  "isCompleted": !widget.isCompleted,
                };
                DatabaseServices()
                    .updateCompleted(uid, widget.documentId, taskMap);
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black87, width: 1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: widget.isCompleted
                    ? Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 16,
                      )
                    : Container(),
              ),
            ),
            SizedBox(width: 8),
            Text(
              widget.task,
              style: TextStyle(
                  color: widget.isCompleted
                      ? Colors.black
                      : Colors.black87.withOpacity(0.7),
                  fontSize: 17,
                  decoration: widget.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                DatabaseServices().deleteTask(
                  uid,
                  widget.documentId,
                );
              },
              child: Icon(
                Icons.close,
                size: 13,
                color: Colors.black87.withOpacity(0.7),
              ),
            )
          ],
        ));
  }
}
