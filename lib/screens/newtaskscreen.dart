import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapplication/CustomIcon.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({Key? key}) : super(key: key);

  @override
  _NewTaskScreenState createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  String taskName = "";
  DateTime? _date;
  TimeOfDay? _time;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  String repetitionFrequency = "No Repeat";
  List<String> options = [
    "No Repeat",
    "Once a Day",
    "Once a day(Mon-Fri)",
    "Once a Week",
    "Other"
  ];
  List<DropdownMenuItem<String>>? dropDownItemCreator(List<String> menuItem) {
    List<DropdownMenuItem<String>>? dropDownMenuItems = menuItem
        .map((item) =>
            ((DropdownMenuItem<String>(value: item, child: Text(item)))))
        .toList(growable: true);
    return dropDownMenuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Create Your Task"),
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
              child: Text(
                "Enter Details Below",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Row(
              children: [
                const Flexible(
                    child: TextField(
                  showCursor: true,
                  decoration: InputDecoration(
                    focusColor: Colors.black,
                    contentPadding: EdgeInsets.all(0),
                    hintText: "Enter the Task",
                    fillColor: Colors.black,
                  ),
                )),
                CustomIconButton(
                  iconData: Icons.mic,
                  onPressedFunction: () => {},
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Flexible(
                    child: GestureDetector(
                  child: TextField(
                    controller: _dateController,
                    readOnly: true,
                    showCursor: true,
                    decoration: const InputDecoration(
                      focusColor: Colors.black,
                      contentPadding: EdgeInsets.all(0),
                      fillColor: Colors.black,
                      hintText: "Enter Date",
                    ),
                  ),
                )),
                CustomIconButton(
                  iconData: Icons.calendar_today,
                  onPressedFunction: () async {
                    // ignore: unused_local_variable
                    DateTime? date = await showDatePicker(
                        context: context,
                        initialDate:
                            (_date == null) ? DateTime.now() : (_date!),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100));
                    if (date != null) {
                      setState(() {
                        var dateString =
                            DateFormat('EEEE, d MMM, yyyy').format(date);
                        _date = date;
                        _dateController.text = dateString;
                      });
                    }
                  },
                ),
                Visibility(
                  // note:------ visibility false krne par wo element ht jaayega to space bhi nhi lega
                  visible: (_date == null) ? false : true,
                  child: CustomIconButton(
                      iconData: Icons.cancel_rounded,
                      onPressedFunction: () {
                        setState(() {
                          _date = null;
                          _dateController.text = "";
                        });
                      }),
                ),
              ],
            ),
            Visibility(
              visible: (_date == null) ? false : true,
              child: Row(
                children: [
                  Flexible(
                      child: TextField(
                    controller: _timeController,
                    readOnly: true,
                    showCursor: true,
                    decoration: const InputDecoration(
                      focusColor: Colors.black,
                      contentPadding: EdgeInsets.all(0),
                      fillColor: Colors.black,
                      hintText: "Enter Time",
                    ),
                  )),
                  CustomIconButton(
                    iconData: Icons.access_time,
                    onPressedFunction: () async {
                      // ignore: unused_local_variable
                      TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: (_time == null) ? TimeOfDay.now() : _time!,
                      );
                      if (time != null) {
                        setState(() {
                          _time = time;
                          var timeString = time.format(context);
                          _timeController.text = timeString;
                        });
                      }
                    },
                  ),
                  Visibility(
                    // note:------ visibility false krne par wo element ht jaayega to space bhi nhi lega
                    visible: (_time == null) ? false : true,
                    child: CustomIconButton(
                        iconData: Icons.cancel_rounded,
                        onPressedFunction: () {
                          setState(() {
                            _time = null;
                            _timeController.text = "";
                          });
                        }),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Visibility(
              visible: (_date == null) ? false : true,
              child: const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: Text(
                  "Select Repeat Option",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: (_date == null) ? false : true,
              child: DropdownButton<String>(
                  value: repetitionFrequency,
                  items: dropDownItemCreator(options),
                  onChanged: (String? chosenValue) {
                    setState(() {
                      if (chosenValue != null) {
                        if (chosenValue != options.last) {
                          // options.last="Other"
                          repetitionFrequency = chosenValue;
                        } else {
                          AlertDialog dialog = AlertDialog(
                            content: const Text("Content"),
                            actions: [
                              TextButton(
                                  onPressed: () {},
                                  child: const Text("Cancel")),
                              TextButton(
                                  onPressed: () {}, child: const Text("OK")),
                            ],
                          );
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return dialog;
                              });
                        }
                      }
                    });
                  }),
            )
          ],
        ),
      ),
    );
  }
}
