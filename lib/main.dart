import 'package:flutter/material.dart';
import 'db/shared_data.dart';
import 'db/sqflite.dart';
import 'db/task.dart';
import 'screens/new_task_screen.dart';
import 'screens/home_screen.dart';
import 'route/routing.dart' as routing;
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SqliteDB.initDb();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodosData(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        initialRoute: routing.homeScreenRoute,
        /*routes: {
          routing.newTaskScreenRoute: (context) => NewTaskScreen(),
          routing.homeScreenRoute: (context) => const MyHomePage(),
        },*/
        onGenerateRoute: (settings) {
          var pageName = settings.name;
          var args = settings.arguments;
          if (pageName == routing.newTaskScreenRoute) {
            if (args is Task) {
              return MaterialPageRoute(
                  builder: (context) => NewTaskScreen(task: args));
            }
            return MaterialPageRoute(
                builder: (context) => const NewTaskScreen());
          }
          if (pageName == routing.homeScreenRoute) {
            return MaterialPageRoute(builder: (context) => const MyHomePage());
          }
        },
      ),
    );
  }
}


// HERE WE HAVE TO PUSH SCREEN RIGHT HERE
// Navigator.push(context,
//     MaterialPageRoute(builder: (context) => (const NewTaskScreen())));
// ===========================================================================
