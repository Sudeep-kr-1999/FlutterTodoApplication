import 'package:flutter/material.dart';

// used to display UI
const String noRepeat = "No Repeat";
const defaultListID = 1;

// repeat cycle options
enum RepeatCycle {
  onceADay,
  onceADayMonFri,
  onceAWeek,
  onceAMonth,
  onceAYear,
  other,
}

String repeatCycleToUIString(RepeatCycle r) {
  Map<RepeatCycle, String> mapper = {
    RepeatCycle.onceADay: "Once A Day",
    RepeatCycle.onceADayMonFri: "Once A Day( Mon-Fri )",
    RepeatCycle.onceAWeek: "Once A Week",
    RepeatCycle.onceAMonth: "Once A Month",
    RepeatCycle.onceAYear: "Once A Year",
    RepeatCycle.other: "Other...",
  };
  return (mapper[r]!);
}

// repeat tenure if other option is selected
enum Tenure { days, weeks, months, years }

// if repeat options other is selected
class RepeatFrequency {
  RepeatFrequency({required this.num, required this.tenure});
  int num;
  Tenure tenure;
}

// create the task
class Task {
  // task instance variable
  int taskID;
  int taskListID;
  int? parentTaskID; //used for repeated task instances only
  String taskName;
  DateTime? deadlineDate;
  TimeOfDay? deadlineTime;
  bool isFinished;
  bool isRepeating;

  // constructor of new task
  Task({
    required this.taskName,
    required this.taskID,
    required this.isFinished,
    required this.isRepeating,
    this.parentTaskID,
    this.deadlineDate,
    this.deadlineTime,
    required this.taskListID,
  });

  // update the task as finished
  void finishTask() {
    isFinished = true;
  }

  Map<String, Object?> toMap() {
    Map<String, Object?> taskAsMap = {
      "taskID": taskID,
      "taskListID": taskListID,
      "parentTaskID": null,
      "taskName": taskName,
      "deadlineDate":
          deadlineDate == null ? null : deadlineDate!.microsecondsSinceEpoch,
      "deadlineTime":
          deadlineTime == null ? null : intFromTimeofDay(deadlineTime!),
      "isFinished": isFinished == true ? 1 : 0,
      "isRepeating": isRepeating == true ? 1 : 0,
    };
    return taskAsMap;
  }

  static Task? fromMap(Map<String, dynamic> taskAsMap) {
    Task task = Task(
      taskID: taskAsMap["taskID"],
      taskListID: taskAsMap["taskListID"],
      parentTaskID: taskAsMap["parentTaskID"],
      taskName: taskAsMap["taskName"],
      deadlineDate: taskAsMap["deadlineDate"] == null
          ? null
          : DateTime.fromMicrosecondsSinceEpoch(taskAsMap["deadlineDate"]),
      deadlineTime: taskAsMap["deadlineTime"] == null
          ? null
          : timeOfDayFromInt(taskAsMap["deadlineTime"]),
      isFinished: taskAsMap["isFinished"] == 0 ? false : true,
      isRepeating: taskAsMap["isRepeating"] == 0 ? false : true,
    );
    return task;
  }
}

int intFromTimeofDay(TimeOfDay tod) {
  return (tod.minute + 60 * tod.hour);
}

TimeOfDay timeOfDayFromInt(int todInt) {
  return TimeOfDay(hour: todInt ~/ 60, minute: todInt % 60);
}

// ----------------------------------------------------------------------

class RepeatingTask {
  // repeating task instance variables
  int taskListID;
  int repeatingTaskId;
  String repeatingTaskName;
  RepeatCycle repeatCycle;
  RepeatFrequency? repeatFrequency;
  DateTime deadlineDate;
  DateTime? deadlineTime;

  RepeatingTask({
    required this.repeatingTaskId,
    required this.repeatingTaskName,
    required this.repeatCycle,
    required this.deadlineDate,
    this.repeatFrequency,
    this.deadlineTime,
    required this.taskListID,
  });
}

class TaskList {
  int listID;
  String listName;
  bool isActive;
  TaskList({
    required this.listID,
    required this.listName,
    required this.isActive,
  });

  static TaskList fromMap(Map<String, dynamic> taskListAsMap) {
    return TaskList(
      listID: taskListAsMap["listID"],
      listName: taskListAsMap["listName"],
      isActive: taskListAsMap["isActive"] == 1 ? true : false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "listID": listID,
      "listName": listName,
      "isActive": isActive == true ? 1 : 0,
    };
  }
}
