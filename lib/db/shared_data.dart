import 'package:flutter/cupertino.dart';
import 'task.dart';
import 'package:todoapplication/db/sqflite.dart';

class TodosData extends ChangeNotifier {
  bool isDataLoaded = false;
  List<Task> activeTasks = [];
  Map<int, TaskList> activeListsByID = {};
  TodosData() {
    initTodosData();
  }
  Future<void> initTodosData() async {
    activeTasks = await SqliteDB.getAllPendingTasks();
    activeListsByID = {
      for (var t in await SqliteDB.getAllActiveLists()) t.listID: t
    };
    isDataLoaded = true;
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    var taskAsMap = task.toMap();
    taskAsMap.remove("taskID");
    int? id = await SqliteDB.insertTask(taskAsMap);
    if (id == null) {
      print("could not insert into database");
    } else {
      task.taskID = id;
      activeTasks.add(task);
      notifyListeners();
    }
  }

  Future<void> updateTask(Task task) async {
    bool success = await SqliteDB.updateTask(task);
    if (success == false) {
      print("could not update the task");
    } else {
      var index =
          activeTasks.indexWhere((element) => element.taskID == task.taskID);
      activeTasks[index] = task;
      notifyListeners();
    }
  }

  Future<void> deleteTask(Task task) async {
    bool success = await SqliteDB.deleteTask(task);
    if (success == false) {
      print("could not delete the task");
    } else {
      var index =
          activeTasks.indexWhere((element) => element.taskID == task.taskID);
      activeTasks.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> finishTask(Task task) async {
    task.isFinished = true;
    bool success = await SqliteDB.updateTask(task);
    if (success == false) {
      print("could not mark the task as finished");
    } else {
      var index =
          activeTasks.indexWhere((element) => element.taskID == task.taskID);
      activeTasks.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> addList(String listName) async {
    var taskListAsMap = {
      "listName": listName,
      "isActive": 1,
    };
    int? id = await SqliteDB.insertList(taskListAsMap);
    if (id == null) {
      print("could not insert into database");
    } else {
      taskListAsMap["listID"] = id;
      activeListsByID[id] = TaskList.fromMap(taskListAsMap);
      notifyListeners();
    }
  }
}
