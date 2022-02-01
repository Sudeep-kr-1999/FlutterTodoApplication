import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:todoapplication/route/routing.dart' as routing;
import 'package:todoapplication/db/sqflite.dart';
import 'package:todoapplication/db/task.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Task?>> taskList = SqliteDB.getAllTasks();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Stack(fit: StackFit.expand, children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(1),
                  child: Image.asset(
                    "assets/todo5.jpg",
                    fit: BoxFit.fill,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(1),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: 0, sigmaY: 0, tileMode: TileMode.mirror),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      alignment: Alignment.center,
                      child: const Text(
                        "Hello Sudeep",
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            SizedBox(
              height: 550,
              width: double.infinity,
              child: Expanded(
                child: Scrollbar(
                  scrollbarOrientation: ScrollbarOrientation.right,
                  isAlwaysShown: false,
                  thickness: 5,
                  radius: const Radius.circular(50),
                  interactive: true,
                  child: FutureBuilder<List<Task?>>(
                    future: taskList,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        var data = snapshot.data;
                        List<Widget> children = [];
                        for (Task task in data) {
                          children.add(ActivityCard(
                            header: task.taskName,
                            date: task.deadlineDate == null
                                ? ""
                                : task.deadlineDate.toString(),
                            list: task.taskListID.toString(),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, routing.newTaskScreenRoute,
                                  arguments: task);
                            },
                            task: task,
                          ));
                        }
                        return ListView(
                          padding: const EdgeInsets.all(5),
                          children: children,
                        );
                      } else if (snapshot.hasError) {
                        return const Text("Some error");
                      } else {
                        //if future has not returned
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.indigo,
        focusElevation: 10,
        elevation: 5,
        splashColor: Colors.grey,
        onPressed: () {
          // HERE WE USE ROUTE INFORMATION FROM routes parameter
          Navigator.pushNamed(context, routing.newTaskScreenRoute);
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class ActivityCard extends StatelessWidget {
  final String header, date, list;
  final Task task;
  final void Function() onTap;

  const ActivityCard({
    required this.header,
    required this.date,
    required this.list,
    required this.onTap,
    required this.task,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
            margin: const EdgeInsets.all(8.0),
            elevation: 5,
            borderOnForeground: true,
            color: Colors.white,
            shadowColor: Colors.deepPurple,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                    width: 30,
                    // checkbox execution in statefull widget
                    child: Checkbox(
                      value: false,
                      onChanged: (bool? value) async {
                        task.isFinished = true;
                        await SqliteDB.updateTask(task);
                        Navigator.pushNamedAndRemoveUntil(
                            context, routing.homeScreenRoute, (route) => false);
                      },
                      shape: const CircleBorder(),
                    ),
                  ),
                  // simply a empty container
                  const SizedBox(
                    width: 20,
                    height: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        header,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(date),
                      Text(list),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
