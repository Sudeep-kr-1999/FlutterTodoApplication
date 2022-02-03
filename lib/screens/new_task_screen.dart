import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todoapplication/db/shared_data.dart';
import 'package:todoapplication/db/task.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({Key? key, this.task}) : super(key: key);
  final Task? task;
  @override
  _NewTaskScreenState createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  // todo:state variables
  Task task = Task(
    isFinished: false,
    isRepeating: false,
    taskName: "",
    taskListID: defaultListID,
    taskID: -1,
    parentTaskID: null,
    deadlineDate: null,
    deadlineTime: null,
  );
  String taskName = "";
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  RepeatCycle? chosenRepeatCycle;
  RepeatFrequency repeatFrequency =
      RepeatFrequency(num: 2, tenure: Tenure.days);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    task = widget.task ?? task;
    _dateController.text = task.deadlineDate == null
        ? ""
        : DateFormat('EEEE, d MMM, yyyy').format(task.deadlineDate!);
    _timeController.text =
        task.deadlineTime == null ? "" : task.deadlineTime!.format(context);
    _nameController.text = task.taskName;
  }

  // todo : repeat options
  List<String> options = [
    "No Repeat",
    "Once a Day",
    "Once a day(Mon-Fri)",
    "Once a Week",
    "Other"
  ];

  void datePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate:
          task.deadlineDate == null ? DateTime.now() : task.deadlineDate!,
      firstDate: DateTime.now(),
      // ignore: todo
      // TODO: lastDate should be 50/100/x years from now
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        task.deadlineDate = pickedDate;
        var dateString = DateFormat('EEEE, d MMM, yyyy').format(pickedDate);
        _dateController.text = dateString;
      });
    }
  }

  void timePicker() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        task.deadlineTime = pickedTime;
        _timeController.text = pickedTime.format(context);
      });
    }
  }

  // todo: create dropdownmenu items
  List<DropdownMenuItem<String>>? dropDownItemCreator(List<String> menuItem) {
    List<DropdownMenuItem<String>>? dropDownMenuItems = menuItem
        .map((item) =>
            ((DropdownMenuItem<String>(value: item, child: Text(item)))))
        .toList(growable: true);
    return dropDownMenuItems;
  }

  void saveNewTask() async {
    Provider.of<TodosData>(context, listen: false).addTask(task);
    Navigator.pop(context);
  }

  void updateTask() async {
    Provider.of<TodosData>(context, listen: false).updateTask(task);
    Navigator.pop(context);
  }

  void deleteTask() async {
    Provider.of<TodosData>(context, listen: false).deleteTask(task);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.task);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.check,
          size: 35,
        ),
        onPressed: () {
          if (widget.task == null) {
            saveNewTask();
          } else {
            updateTask();
          }
        },
      ),
      appBar: AppBar(
        title: Text(widget.task == null ? "New Task" : "Edit Task"),
        actions: widget.task != null
            ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: deleteTask,
                )
              ]
            : [],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Task details
            const Text(
              "What is to be done?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const SizedBox(width: 10),
                Flexible(
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                      isDense: true,
                      hintText: "Enter Task Here",
                    ),
                    onChanged: (String? value) {
                      task.taskName = value ?? task.taskName;
                    },
                  ),
                ),
                CustomIconButton(
                  iconData: Icons.mic,
                  onPressedFunction: () {},
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),

            //Date Time Input
            const Text(
              "Due Date",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            EditableFieldWithCancelButton(
              hintText: "Date not set",
              iconData: Icons.calendar_today_outlined,
              textController: _dateController,
              picker: datePicker,
              onCancel: () {
                setState(() {
                  task.deadlineDate = null;
                  _dateController.text = "";
                  task.deadlineTime = null;
                  _timeController.text = "";
                });
              },
              enableCancelButton: () {
                return (task.deadlineDate != null);
              },
            ),

            //Time Input
            const SizedBox(height: 10),
            Visibility(
              visible: task.deadlineDate != null ? true : false,
              child: EditableFieldWithCancelButton(
                hintText: "Time not set",
                iconData: Icons.access_time,
                textController: _timeController,
                picker: timePicker,
                onCancel: () {
                  setState(() {
                    task.deadlineTime = null;
                    _timeController.text = "";
                  });
                },
                enableCancelButton: () {
                  return (task.deadlineTime != null);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Notifications",
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task.deadlineDate != null
                        ? "Day summary on the same day at 8:00 am."
                        : "No notifications if date not set",
                  ),
                  const SizedBox(height: 4),
                  Visibility(
                    child: const Text(
                      "Individual notification on time",
                    ),
                    visible: task.deadlineTime != null,
                  ),
                ],
              ),
            ),

            //Repeating Info
            const SizedBox(height: 20),
            const Text(
              "Repeat",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            Row(
              children: [
                const SizedBox(width: 10),
                DropdownButton<dynamic>(
                  items: () {
                    List<DropdownMenuItem<dynamic>> items = [];
                    items.add(const DropdownMenuItem<dynamic>(
                      child: Text(
                        noRepeat,
                      ),
                      value: noRepeat,
                    ));
                    for (var value in RepeatCycle.values) {
                      items.add(DropdownMenuItem<dynamic>(
                        child: Text(
                          repeatCycleToUIString(value),
                        ),
                        value: value,
                      ));
                    }

                    //values.add(noRepeat);
                    return (items);
                  }(),
                  value: chosenRepeatCycle ?? noRepeat,
                  onChanged: (dynamic chosenValue) {
                    if (chosenValue != null) {
                      if (chosenValue == noRepeat) {
                        setState(() {
                          chosenRepeatCycle = null;
                        });
                      } else {
                        setState(() {
                          chosenRepeatCycle = chosenValue;
                        });
                      }
                    }
                  },
                ),
              ],
            ),
            Visibility(
              visible: chosenRepeatCycle == RepeatCycle.other,
              child: Column(children: [
                const SizedBox(height: 10),
                Row(children: [
                  const SizedBox(width: 10),
                  DropdownButton<int>(
                    items: [2, 3, 4, 5, 6, 7, 8, 9, 10]
                        .map((int t) => DropdownMenuItem<int>(
                              child: Text(t.toString()),
                              value: t,
                            ))
                        .toList(),
                    value: repeatFrequency.num,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          repeatFrequency.num = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<Tenure>(
                    items: Tenure.values
                        .map((Tenure t) => DropdownMenuItem<Tenure>(
                              child: Text(describeEnum(t)),
                              value: t,
                            ))
                        .toList(),
                    value: repeatFrequency.tenure,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          repeatFrequency.tenure = value;
                        });
                      }
                    },
                  )
                ])
              ]),
            ),

            const SizedBox(height: 30),
            const Text(
              "Select a List",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child:
                      Consumer<TodosData>(builder: (context, todosData, child) {
                    List<DropdownMenuItem<int>> menuItems = [];
                    for (var taskList in todosData.activeListsByID.values) {
                      menuItems.add(
                        DropdownMenuItem<int>(
                          child: Text(taskList.listName),
                          value: taskList.listID,
                        ),
                      );
                    }
                    return DropdownButton<int>(
                      isExpanded: true,
                      items: menuItems,
                      value: task.taskListID,
                      onChanged: (value) {
                        task.taskListID = value ?? task.taskListID;
                        setState(() {});
                      },
                    );
                  }),
                ),
                const SizedBox(width: 5),
                CustomIconButton(
                    iconData: Icons.playlist_add,
                    onPressedFunction: () {
                      String listName = "";
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Add a list"),
                            content: TextField(
                              onChanged: (value) {
                                listName = value;
                              },
                              decoration: const InputDecoration(
                                  hintText: "Enter name of the list"),
                            ),
                            actions: [
                              TextButton(
                                child: const Text("OK"),
                                onPressed: () {
                                  Provider.of<TodosData>(context, listen: false)
                                      .addList(listName);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }),
                const SizedBox(width: 5),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditableFieldWithCancelButton extends StatelessWidget {
  const EditableFieldWithCancelButton({
    Key? key,
    required this.hintText,
    required this.iconData,
    required this.textController,
    required this.picker,
    required this.onCancel,
    required this.enableCancelButton,
  }) : super(key: key);

  final String hintText;
  final IconData iconData;
  final TextEditingController textController;
  final void Function() picker;
  final void Function() onCancel;
  final bool Function() enableCancelButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 5),
        Flexible(
          child: TextField(
            controller: textController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
              isDense: true,
              hintText: hintText,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white60,
                ),
              ),
            ),
            onTap: picker,
            enableInteractiveSelection: false,
            showCursor: false,
            readOnly: true,
          ),
        ),
        const SizedBox(width: 5),
        CustomIconButton(
          iconData: iconData,
          onPressedFunction: picker,
        ),
        Visibility(
            child: CustomIconButton(
              iconData: Icons.cancel_rounded,
              onPressedFunction: onCancel,
            ),
            visible: enableCancelButton()),
      ],
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final IconData iconData;
  final void Function() onPressedFunction;
  const CustomIconButton({
    required this.iconData,
    required this.onPressedFunction,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize: Size.zero),
        onPressed: onPressedFunction,
        child: Icon(
          iconData,
          color: Colors.black,
        ));
  }
}
