import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:study_hub/data/data.dart';
import 'package:study_hub/pages/AfterLogin/schedule.dart';
import 'package:study_hub/pages/AfterLogin/Tasks.dart';
import 'package:intl/intl.dart';
class EditTaskPage extends StatefulWidget {
  String className;
  String taskName;
  DateTime dueDate;
  String type;
  String ogTaskName;
  DateTime ogDueDate;
  String ogType;
  EditTaskPage({Key key, this.dueDate, this.taskName, this.ogDueDate, this.type, this.className, this.ogType, this.ogTaskName}) : super(key: key);

  @override
  EditTaskPageState createState() => EditTaskPageState(className: className, taskName: taskName, dueDate: dueDate, type: type, ogType: ogType, ogDueDate: ogDueDate, ogTaskName: ogTaskName,);
}

class EditTaskPageState extends State<EditTaskPage> {
  String className;
  String taskName;
  DateTime dueDate;
  String type;
  String ogTaskName;
  DateTime ogDueDate;
  String ogType;
  EditTaskPageState({this.className, this.ogTaskName, this.taskName, this.dueDate, this.ogType, this.type, this.ogDueDate});
  List<bool> typeSelections;
  bool toggleOn = true;
  Widget toggleWidget;
  AddTaskFormData taskData = AddTaskFormData();
  DateTime _currentDateSelected;
  TimeOfDay _currentTimeSelected;
  bool loading;
  String error;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    setState(() {
      _currentDateSelected = dueDate;
      _currentTimeSelected = TimeOfDay.fromDateTime(dueDate);
      toggleOn = true;
      toggleWidget = Icon(
        toggleOn==true?Icons.toggle_on_rounded:Icons.toggle_off_rounded,
        color: toggleOn==true?Color(0xFF00417D):Colors.grey,
        size: 70,
      );
      if(type=="Revision")
      typeSelections = [true, false, false];
      else if(type=="Assignment")
        typeSelections = [false, true, false];
      else
        typeSelections = [false, false, true];
    });
  }

  void buttonPressed() {
    setState(() {
      if (error != null) error = null;
      if (_currentDateSelected != null&&_currentTimeSelected!=null)
        taskData.dateTime = Timestamp.fromDate(DateTime(_currentDateSelected.year, _currentDateSelected.month, _currentDateSelected.day, _currentTimeSelected.hour, _currentTimeSelected.minute));
      else
        error = "Select a valid date and time";

      taskData.remindMe = toggleOn;

      if(typeSelections[0]==true){
        taskData.type = "Revision";
      }
      else if(typeSelections[1]==true){
        taskData.type = "Assignment";
      }
      else{
        taskData.type = "Other";
      }
      print(taskData.type);
    });
  }

  void nowLoading() {
    setState(() {
      loading = true;
    });
  }

  void doneLoading() {
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future getClassesTwice() async {
      print(currentTasksDropdownItemSelected);
      await firestoreService.getClasses(currentTasksDropdownItemSelected);
      await firestoreService.getClasses(currentTasksDropdownItemSelected);
    }

    DateTime now = DateTime.now();
    List<String> yearOptions = [];
    var preTextWidth = MediaQuery.of(context).size.width * (1.0 / 19.0);
    final contextHeight = MediaQuery.of(context).size.height;
    final MockupHeight = 850.9090909090909;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
            ),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Theme.of(context).primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(children: [
                  SizedBox.fromSize(
                    size: Size(preTextWidth, 0.0),
                  ),
                  Text(
                    "Edit",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 30.0 / MockupHeight * contextHeight,
                        color: Colors.white,
                        fontFamily: 'Abel'),
                  ),
                ]),
                SizedBox.fromSize(
                  size: Size(0.0, contextHeight * (1.0 / 90.0)),
                ),
                Row(children: [
                  SizedBox.fromSize(
                    size: Size(preTextWidth, 0.0),
                  ),
                  Text(
                    "Task",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 30.0 / MockupHeight * contextHeight,
                        color: Colors.white,
                        fontFamily: 'Abel'),
                  ),
                ]),
                SizedBox(
                  height: 10 / MockupHeight * contextHeight,
                ),
                Form(
                  key: _formKey,
                  child: Column(children: [
                    Row(children: [
                      SizedBox.fromSize(
                        size: Size(preTextWidth, 0.0),
                      ),
                      Text(
                        "Class",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18.0 / MockupHeight * contextHeight,
                          color: Color(0XFFC4C9EF),
                          fontFamily: 'Abel',
                        ),
                      ),
                    ]),
                    SizedBox(height: 10 / MockupHeight * contextHeight),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: preTextWidth,
                        ),
                        Text(
                          className,
                          style: TextStyle(
                            fontSize: 24.0 / MockupHeight * contextHeight,
                            color: Colors.white70,
                            fontFamily: 'Abel',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20 / MockupHeight * contextHeight),
                    Row(children: [
                      SizedBox.fromSize(
                        size: Size(preTextWidth, 0.0),
                      ),
                      Text(
                        "Name",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18.0 / MockupHeight * contextHeight,
                          color: Color(0XFFC4C9EF),
                          fontFamily: 'Abel',
                        ),
                      ),
                    ]),
                    BuildTextFormField(
                      initialValue: taskName,
                      hintText: "Task Name",
                      textColor: Colors.white,
                      isEmail: true,
                      Validator: (String value) {
                        if (value.isEmpty) {
                          return "Task name is required";
                        }
                        _formKey.currentState.save();
                        return null;
                      },
                      onSaved: (String value) {
                        taskData.TaskName = value;
                      },
                    ),
                    Container(
                      height: error != null
                          ? (670) / MockupHeight * contextHeight
                          : (600) / MockupHeight * contextHeight,
                      margin: EdgeInsets.only(top: (1.0 / 18.0) * contextHeight),
                      decoration: BoxDecoration(
                        color: Color(0xFFDEF3FF),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          SizedBox.fromSize(
                            size: Size(0.0, contextHeight * (1.0 / 17.0)),
                          ),
                          Row(children: [
                            SizedBox.fromSize(
                              size: Size(preTextWidth, 0.0),
                            ),
                            Text(
                              "Date",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18.0 / MockupHeight * contextHeight,
                                color: Theme.of(context).primaryColor,
                                fontFamily: 'Abel',
                              ),
                            ),
                          ]),
                          SizedBox(
                            height: contextHeight * (1.0 / 100.0),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 30 / MockupHeight * contextHeight,
                              ),
                              GestureDetector(
                                child: Text(
                                  _currentDateSelected == null
                                      ? 'Select a Date'
                                      : "${DateFormat.yMMMMd("en").format(_currentDateSelected)}",
                                  style: TextStyle(
                                    fontSize: 24.0 / MockupHeight * contextHeight,
                                    color: Colors.black,
                                    fontFamily: 'Abel',
                                  ),
                                ),
                                onTap: () {
                                  showDatePicker(
                                      context: context,
                                      initialDate:
                                      _currentDateSelected == null
                                          ? DateTime.now()
                                          : _currentDateSelected,
                                      firstDate: DateTime(now.year - 5),
                                      lastDate: DateTime(now.year + 5))
                                      .then((date) {
                                    setState(() {
                                      _currentDateSelected = date;
                                    });
                                  });
                                },
                              ),
                              SizedBox(
                                width: 10 / MockupHeight * contextHeight,
                              ),
                              GestureDetector(
                                child: Icon(
                                  Icons.calendar_today,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onTap: () {
                                  showDatePicker(
                                      context: context,
                                      initialDate:
                                      _currentDateSelected == null
                                          ? DateTime.now()
                                          : _currentDateSelected,
                                      firstDate: DateTime(now.year - 5),
                                      lastDate: DateTime(now.year + 5))
                                      .then((date) {
                                    setState(() {
                                      _currentDateSelected = date;
                                    });
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox.fromSize(
                            size: Size(0.0, contextHeight * (1.0 / 40.0)),
                          ),
                          Row(children: [
                            SizedBox.fromSize(
                              size: Size(preTextWidth, 0.0),
                            ),
                            Text(
                              "Time",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18.0 / MockupHeight * contextHeight,
                                color: Theme.of(context).primaryColor,
                                fontFamily: 'Abel',
                              ),
                            ),
                          ]),
                          SizedBox(
                            height: contextHeight * (1.0 / 100.0),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 30 / MockupHeight * contextHeight,
                              ),
                              GestureDetector(
                                child: Text(
                                  _currentTimeSelected == null
                                      ? 'Select a Time'
                                      : _currentTimeSelected.format(context),
                                  style: TextStyle(
                                    fontSize: 24.0 / MockupHeight * contextHeight,
                                    color: Colors.black,
                                    fontFamily: 'Abel',
                                  ),
                                ),
                                onTap: () {
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(hour: 00, minute: 00),
                                  ).then((value) {
                                    setState(() {
                                      _currentTimeSelected = value;
                                    });
                                  });
                                },
                              ),
                              SizedBox(
                                width: 10 / MockupHeight * contextHeight,
                              ),
                              GestureDetector(
                                child: Icon(
                                  Icons.access_time,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onTap: () {
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(hour: 00, minute: 00),
                                  ).then((value) {
                                    setState(() {
                                      _currentTimeSelected = value;
                                    });
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30 / MockupHeight * contextHeight,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: preTextWidth,
                              ),
                              Text(
                                "Type",
                                style: TextStyle(
                                  fontSize:
                                  18.0 / MockupHeight * contextHeight,
                                  color: Theme.of(context).primaryColor,
                                  fontFamily: 'Abel',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10 / MockupHeight * contextHeight,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: preTextWidth * 2,
                              ),
                              ToggleButtons(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: Center(
                                      child: Text(
                                        "Revision",
                                        style: TextStyle(
                                          fontSize:
                                          18.0 / MockupHeight * contextHeight,
                                          color: Theme.of(context).primaryColor,
                                          fontFamily: 'Abel',
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Center(
                                      child: Text(
                                        "Assignment",
                                        style: TextStyle(
                                          fontSize:
                                          18.0 / MockupHeight * contextHeight,
                                          color: Theme.of(context).primaryColor,
                                          fontFamily: 'Abel',
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Center(
                                      child: Text(
                                        "Other",
                                        style: TextStyle(
                                          fontSize:
                                          18.0 / MockupHeight * contextHeight,
                                          color: Theme.of(context).primaryColor,
                                          fontFamily: 'Abel',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                isSelected: typeSelections,
                                onPressed: (index) {
                                  if (typeSelections[index] == false) {
                                    typeSelections[index] = true;
                                    setState(() {
                                      for (var i = 0; i < 3; i++) {
                                        if (i != index) {
                                          if (typeSelections[i] == true)
                                            typeSelections[i] = false;
                                        }
                                      }
                                    });
                                  }
                                },
                                borderRadius: BorderRadius.circular(10),
                                selectedColor: Colors.white,
                              ),
                            ],
                          ),
                          loading == true
                              ? LinearProgressIndicator(
                            backgroundColor: Theme.of(context).primaryColor,
                          )
                              : error != null
                              ? CupertinoAlertDialog(
                            title: Text(
                              error != null ? error : "",
                              style: TextStyle(
                                  fontSize: 18.0 /
                                      MockupHeight *
                                      contextHeight,
                                  fontFamily: 'Abel',
                                  color: Colors.red),
                            ),
                          )
                              : SizedBox(
                            height: 50,
                          ),
                          Center(
                              child: SizedBox(
                                width: (182.0 / 207.0) *
                                    MediaQuery.of(context).size.width,
                                height: (25.0 / 448.0) * contextHeight,
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0 / MockupHeight * contextHeight),
                                  ),
                                  onPressed: () async {
                                    buttonPressed();
                                    if (_formKey.currentState.validate() && error==null) {
                                      _formKey.currentState.save();
                                      nowLoading();
                                      await firestoreService.editTask(taskData.className, taskData.TaskName, taskData.dateTime.toDate(), taskData.type, ogTaskName, ogDueDate, ogType);
                                      firestoreService.tasksMap[currentTasksDropdownItemSelected] = [];
                                      await firestoreService.getAllTasks();
                                      firestoreService.tasksMap[currentTasksDropdownItemSelected] = [];
                                      await firestoreService.getAllTasks();
                                      firestoreService.tasksMap[currentTasksDropdownItemSelected] = [];
                                      await firestoreService.getAllTasks();
                                      Navigator.push(context,
                                          MaterialPageRoute(
                                              builder: (context) => TasksPage()));
                                      doneLoading();
                                    }
                                  },
                                  color: Theme.of(context).primaryColor,
                                  textColor: Colors.white,
                                  splashColor: Colors.blue[900],
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "UPDATE TASK",
                                        style: TextStyle(
                                            fontSize:
                                            18.0 / MockupHeight * contextHeight,
                                            fontFamily: 'Abel'),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                          SizedBox(
                            height: error != null || loading == true
                                ? 20 / MockupHeight * contextHeight
                                : 0,
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BuildTextFormField extends StatelessWidget {
  final String initialValue;
  final String hintText;
  // ignore: non_constant_identifier_names
  final Function Validator;
  final Function onSaved;
  final bool isPassword;
  final bool isEmail;
  final Color textColor;
  BuildTextFormField({
    this.initialValue,
    this.hintText,
    // ignore: non_constant_identifier_names
    this.Validator,
    this.onSaved,
    this.isPassword = false,
    this.isEmail = false,
    this.textColor = Colors.black,
  });
  @override
  Widget build(BuildContext context) {
    final contextHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.fromLTRB(8.0 / 850.9090909090909 * contextHeight,
          4.0 / 850.9090909090909 * contextHeight, 8.0, 4.0),
      child: Theme(
        data: ThemeData(),
        child: TextFormField(
          initialValue: initialValue,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 24.0 / 850.9090909090909 * contextHeight,
              fontFamily: 'Abel',
              color: textColor,
            ),
            contentPadding:
            EdgeInsets.all(15.0 / 850.9090909090909 * contextHeight),
          ),
          obscureText: isPassword ? true : false,
          validator: Validator,
          onSaved: onSaved,
          keyboardType:
          isEmail ? TextInputType.emailAddress : TextInputType.text,
          style: TextStyle(
            fontSize: 24.0 / 850.9090909090909 * contextHeight,
            fontFamily: 'Abel',
            color: textColor,
          ),
        ),
      ),
    );
  }
}
