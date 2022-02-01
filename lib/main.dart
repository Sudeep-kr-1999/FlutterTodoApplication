import 'package:flutter/material.dart';
import 'db/task.dart';
import 'screens/new_task_screen.dart';
import 'screens/home_screen.dart';
import 'route/routing.dart' as routing;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Scheduler',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        initialRoute: routing.homeScreenRoute,
        home: const MyHomePage(),
        // routes: {
        //   routing.newTaskScreenRoute: (context) => const NewTaskScreen(),
        //   routing.homeScreenRoute: (context) => const MyHomePage(),
        // },
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
        });
  }
}


// HERE WE HAVE TO PUSH SCREEN RIGHT HERE
// Navigator.push(context,
//     MaterialPageRoute(builder: (context) => (const NewTaskScreen())));
// ===========================================================================
