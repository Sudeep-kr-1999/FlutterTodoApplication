import 'package:flutter/material.dart';
import './screens/newtaskscreen.dart';
import './screens/routing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(),
      routes: {newTask: (context) => (const NewTaskScreen())},
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Track Your Plans"),
        backgroundColor: Colors.deepPurple,
        elevation: 5,
        shadowColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              margin: const EdgeInsets.fromLTRB(15, 10, 10, 0),
              color: Colors.purple,
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: const Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Text(
                  "Active Tasks",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Scrollbar(
                scrollbarOrientation: ScrollbarOrientation.right,
                isAlwaysShown: true,
                thickness: 5,
                radius: const Radius.circular(50),
                interactive: true,
                child: ListView(
                  children: const [
                    ActivityCard("Pay Fees", "21-01-2021", "will pay the fees"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.purple,
        elevation: 5,
        splashColor: Colors.grey,
        onPressed: () {
          // HERE WE HAVE TO PUSH SCREEN RIGHT HERE
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => (const NewTaskScreen())));
          // ===========================================================================
          // HERE WE USE ROUTE INFORMATION FROM routes parameter
          Navigator.pushNamed(context, newTask);
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class ActivityCard extends StatelessWidget {
  final String? header, date, list;
  const ActivityCard(
    this.header,
    this.date,
    this.list, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          elevation: 5,
          borderOnForeground: true,
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  child: Checkbox(value: false, onChanged: (bool? value) {}),
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
                      header!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(date!),
                    Text(list!),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
