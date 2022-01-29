enum RepeatCycle {
  onceADay,
  onceADayMonFri,
  onceAWeek,
  onceAMonth,
  other,
}
enum Tenure {
  days,
  weeks,
  months,
  years,
}

class RepeatFrequency {
  int num;
  Tenure tenure;
  RepeatFrequency({required this.num, required this.tenure});
}

class Task {
  String taskListid;
  String taskId;
  // used for repeated task only
  String? parentTasktaskId;
  String taskName = "";
  DateTime? deadLineDate;
  DateTime? deadLineTime;
  bool finished;
  bool skipped;
  Task({
    required this.taskListid,
    required this.taskId,
    required this.taskName,
    required this.finished,
    required this.skipped,
    this.deadLineDate,
    this.deadLineTime,
    this.parentTasktaskId,
  }) {
    if (deadLineDate == null) {
      // if condition false it will show the error
      assert(deadLineTime == null);
    }
  }
}

class RepeatingTask {
  String taskListid;
  String repeatedTaskId;
  String repeatingTaskName;
  RepeatCycle repeatCycle;
  RepeatFrequency? repeatFrequency;
  DateTime? deadLineTime;
  DateTime deadLineDate;
  RepeatingTask({
    required this.taskListid,
    required this.repeatedTaskId,
    required this.repeatingTaskName,
    required this.repeatCycle,
    this.repeatFrequency,
    required this.deadLineDate,
    this.deadLineTime,
  });
}

class TaskList {
  String taskListId;
  String taskListName;
  List<Task> nonRepeatingTask = [];
  List<RepeatingTask> repeatingTask = [];
  List<Task> repeatingTaskInstance = [];
  TaskList({
    required this.taskListId,
    required this.taskListName,
    required this.nonRepeatingTask,
    required this.repeatingTask,
    required this.repeatingTaskInstance,
  });
}
