import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:study_hub/data/data.dart';
import 'package:study_hub/pages/AfterLogin/schedule.dart';
import 'package:study_hub/pages/AfterLogin/Tasks.dart';
import 'package:intl/intl.dart';
import 'package:study_hub/main.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AddTaskPage extends StatefulWidget {
  AddTaskPage({Key key}) : super(key: key);

  @override
  AddTaskPageState createState() => AddTaskPageState();
}

class AddTaskPageState extends State<AddTaskPage> {
  String currentClassSelected;
  List<bool> typeSelections = [true, false, false];
  bool toggleOn = true;
  Widget toggleWidget = Icon(
    Icons.toggle_on_rounded,
    color: Color(0xFF00417D),
    size: 70,
  );
  AddTaskFormData taskData = AddTaskFormData();
  DateTime _currentDateSelected;
  DateTime _currentRevisionDateSelected;
  TimeOfDay _currentTimeSelected;
  bool loading;
  String error;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState(){
    super.initState();
    initializing();
  }
  void initializing() async{
    var androidInitilize = new AndroidInitializationSettings('app_icon');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings = new InitializationSettings(iOS: iOSinitilize, android: androidInitilize);
    fltrNotification = new FlutterLocalNotificationsPlugin();
    await fltrNotification.initialize(initilizationsSettings);
    setState(() {
      _currentDateSelected = DateTime.now();
    });
  }

  void buttonPressed() {
    setState(() {
      if (error != null) error = null;
      if (_currentDateSelected != null&&_currentTimeSelected!=null)
        taskData.dateTime = Timestamp.fromDate(DateTime(_currentDateSelected.year, _currentDateSelected.month, _currentDateSelected.day, _currentTimeSelected.hour, _currentTimeSelected.minute));
      else
        error = "Select a valid date and time";


      if(currentClassSelected!=null) taskData.className = currentClassSelected;
      else error = "Select a class. Create one if you have not yet for this year.";

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
                    "Add",
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
                    "New Task",
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
                        FutureBuilder(
                            future: getClassesTwice(),
                            builder: (context, _) {
                              List<String> ClassOptions = [];
                              for (var Class in firestoreService.returnList) {
                                ClassOptions.add(Class[0]);
                              }
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    5 / MockupHeight * contextHeight),
                                child: Container(
                                  color: Color(0XFFDEF3FF),
                                  child: DropdownButton<String>(
                                    dropdownColor: Color(0XFFDEF3FF),
                                    iconEnabledColor:
                                    Theme.of(context).primaryColor,
                                    iconDisabledColor:
                                    Theme.of(context).primaryColor,
                                    items: ClassOptions.map((String ClassOption) {
                                      return DropdownMenuItem(
                                        value: ClassOption,
                                        child: Text(
                                          "  " + ClassOption,
                                          style: TextStyle(
                                            fontSize: 18.0 /
                                                850.9090909090909 *
                                                contextHeight,
                                            color: Theme.of(context).primaryColor,
                                            fontFamily: 'Abel',
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String val) {
                                      setState(() {
                                        currentClassSelected = val;
                                      });
                                    },
                                    value: currentClassSelected,
                                  ),
                                ),
                              );
                            }),
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
                                      await firestoreService.addTask(taskData.TaskName, taskData.dateTime, taskData.remindMe, false, taskData.type, taskData.className);
                                      await firestoreService.getAllTasks();
                                      await firestoreService.getAllTasks();
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
                                        "ADD TASK",
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
  final String hintText;
  // ignore: non_constant_identifier_names
  final Function Validator;
  final Function onSaved;
  final bool isPassword;
  final bool isEmail;
  final Color textColor;
  BuildTextFormField({
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
