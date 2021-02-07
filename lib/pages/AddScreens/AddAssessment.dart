import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:validators/validators.dart' as validator;
import 'package:study_hub/data/data.dart';
import 'package:study_hub/pages/AfterLogin/schedule.dart';
import 'package:study_hub/pages/AfterLogin/Assessments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_hub/main.dart';
List months = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];

class AddAssessmentPage extends StatefulWidget {
  AddAssessmentPage({Key key}) : super(key: key);

  @override
  AddAssessmentPageState createState() => AddAssessmentPageState();
}

class AddAssessmentPageState extends State<AddAssessmentPage> {
  TimeOfDay _currentRevisionTimeSelected;
  String currentClassSelected;
  List<bool> typeSelections = [true, false, false];
  bool toggleOn = true;
  Widget toggleWidget = Icon(
    Icons.toggle_on_rounded,
    color: Color(0xFF00417D),
    size: 40,
  );
  AddAssessmentFormData assessmentData = AddAssessmentFormData();
  DateTime _currentDateSelected;
  DateTime _currentRevisionDateSelected;
  TimeOfDay _currentTimeSelected;
  bool loading;
  String error;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    setState(() {
      _currentDateSelected = DateTime.now();
    });
  }

  void buttonPressed() {
    setState(() {
      if (error != null) error = null;
      if (_currentDateSelected != null)
        assessmentData.date = _currentDateSelected;
      else
        error = "Select a date";

      if(_currentTimeSelected!=null) assessmentData.time = _currentTimeSelected;
      else error = "Select a valid time";

      if(currentClassSelected!=null) assessmentData.className = currentClassSelected;
      else error = "Select a class. Create one if you have not yet for this year.";

      assessmentData.regRev = toggleOn;

      if(toggleOn==true){

        if(_currentRevisionDateSelected!=null) assessmentData.regRevStartDate = _currentRevisionDateSelected;
        else error = "Select a revision start date or turn off regular revision";
        if(_currentRevisionTimeSelected==null) error = "Select a valid revision time";
      }
      else{
        assessmentData.regRevStartDate=null;
        assessmentData.regRevInterval=null;
      }
      if(typeSelections[0]==true){
        assessmentData.type = "Quiz";
      }
      else if(typeSelections[1]==true){
        assessmentData.type = "Test";
      }
      else{
        assessmentData.type = "Other";
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
      print(currentAssessmentDropdownItemSelected);
      await firestoreService.getClasses(currentAssessmentDropdownItemSelected);
      await firestoreService.getClasses(currentAssessmentDropdownItemSelected);
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
                    "New Assessment",
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
                      hintText: "Assessment Name",
                      textColor: Colors.white,
                      isEmail: true,
                      Validator: (String value) {
                        if (value.isEmpty) {
                          return "Assessment name is required";
                        }
                        _formKey.currentState.save();
                        return null;
                      },
                      onSaved: (String value) {
                        assessmentData.assessmentName = value;
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
                                      : months[_currentDateSelected.month - 1] +
                                          " " +
                                          _currentDateSelected.day.toString() +
                                          ", " +
                                          _currentDateSelected.year.toString(),
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
                            height: 10 / MockupHeight * contextHeight,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: preTextWidth,
                              ),
                              Text(
                                "Regular Revision",
                                style: TextStyle(
                                  fontSize: 18.0 / MockupHeight * contextHeight,
                                  color: Theme.of(context).primaryColor,
                                  fontFamily: 'Abel',
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    toggleOn = !toggleOn;
                                    toggleOn == true
                                        ? toggleWidget = Icon(
                                            Icons.toggle_on_rounded,
                                            color: Color(0xFF00417D),
                                            size: 40,
                                          )
                                        : toggleWidget = Icon(
                                            Icons.toggle_off_rounded,
                                            color: Colors.grey,
                                            size: 40,
                                          );
                                  });
                                },
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 1000),
                                  child: toggleWidget,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5 / MockupHeight * contextHeight,
                          ),
                          toggleOn == true
                              ? Column(children: [
                                  Row(children: [
                                    SizedBox.fromSize(
                                      size: Size(preTextWidth, 0.0),
                                    ),
                                    Text(
                                      "Revision Start Date:",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize:
                                            18.0 / MockupHeight * contextHeight,
                                        color: Theme.of(context).primaryColor,
                                        fontFamily: 'Abel',
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width:
                                              10 / MockupHeight * contextHeight,
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              5 / MockupHeight * contextHeight),
                                          child: Container(
                                            width: 140,
                                            color: Theme.of(context).primaryColor,
                                            child: Center(
                                              child: GestureDetector(
                                                child: Text(
                                                  _currentRevisionDateSelected ==
                                                          null
                                                      ? 'Select a Date'
                                                      : months[
                                                              _currentRevisionDateSelected
                                                                      .month -
                                                                  1] +
                                                          " " +
                                                          _currentRevisionDateSelected
                                                              .day
                                                              .toString() +
                                                          ", " +
                                                          _currentRevisionDateSelected
                                                              .year
                                                              .toString(),
                                                  style: TextStyle(
                                                    fontSize: 18.0 /
                                                        MockupHeight *
                                                        contextHeight,
                                                    color: Colors.white,
                                                    fontFamily: 'Abel',
                                                  ),
                                                ),
                                                onTap: () {
                                                  showDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              _currentRevisionDateSelected ==
                                                                      null
                                                                  ? DateTime.now()
                                                                  : _currentRevisionDateSelected,
                                                          firstDate: DateTime(
                                                              now.year - 5),
                                                          lastDate: DateTime(
                                                              now.year + 5))
                                                      .then((date) {
                                                    setState(() {
                                                      _currentRevisionDateSelected =
                                                          date;
                                                    });
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(children: [
                              SizedBox.fromSize(
                                size: Size(preTextWidth, 0.0),
                              ),
                              Text(
                                "Revision Time:",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize:
                                  18.0 / MockupHeight * contextHeight,
                                  color: Theme.of(context).primaryColor,
                                  fontFamily: 'Abel',
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width:
                                    47 / MockupHeight * contextHeight,
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        5 / MockupHeight * contextHeight),
                                    child: Container(
                                      width: 140,
                                      color: Theme.of(context).primaryColor,
                                      child: Center(
                                        child: GestureDetector(
                                          child: Text(
                                            _currentRevisionTimeSelected ==
                                                null
                                                ? 'Select a Time'
                                                : _currentRevisionTimeSelected.format(context),
                                            style: TextStyle(
                                              fontSize: 18.0 /
                                                  MockupHeight *
                                                  contextHeight,
                                              color: Colors.white,
                                              fontFamily: 'Abel',
                                            ),
                                          ),
                                          onTap: () {
                                            showTimePicker(
                                                context: context,
                                                initialTime:_currentRevisionTimeSelected!=null?_currentRevisionTimeSelected:TimeOfDay(hour: 0, minute: 0),
                                            )
                                                .then((time) {
                                              setState(() {
                                                _currentRevisionTimeSelected =
                                                    time;
                                              });
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: preTextWidth,
                                      ),
                                      Text(
                                        "Repeat Every:",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize:
                                              18.0 / MockupHeight * contextHeight,
                                          color: Theme.of(context).primaryColor,
                                          fontFamily: 'Abel',
                                        ),
                                      ),
                                      SizedBox(
                                        height: 40,
                                        width: 50,
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.fromLTRB(
                                              5,
                                              0,
                                              5,
                                              0,
                                            ),
                                          ),
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                            fontSize: 18.0 /
                                                850.9090909090909 *
                                                contextHeight,
                                            fontFamily: 'Abel',
                                            color: Theme.of(context).primaryColor,
                                          ),
                                          validator: (String val){
                                            if(toggleOn==true){
                                              if(validator.isInt(val)){
                                                assessmentData.regRevInterval = int.parse(val);
                                              }
                                              else{
                                                error = "Enter a valid revision interval";
                                              }
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Text(
                                        "Days",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize:
                                              18.0 / MockupHeight * contextHeight,
                                          color: Theme.of(context).primaryColor,
                                          fontFamily: 'Abel',
                                        ),
                                      ),
                                    ],
                                  ),

                                ])
                              : SizedBox(),
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
                                        "Quiz",
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
                                        "Test",
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
                                  await firestoreService.addAssessment(assessmentData.className, assessmentData.assessmentName, assessmentData.date, assessmentData.time, assessmentData.type, currentAssessmentDropdownItemSelected, assessmentData.regRev, assessmentData.regRevInterval, assessmentData.regRevStartDate);
                                  if(assessmentData.regRev==true){
                                    int i = 1;
                                    while(DateTime(assessmentData.regRevStartDate.year, assessmentData.regRevStartDate.month, assessmentData.regRevStartDate.day, _currentRevisionTimeSelected.hour,_currentRevisionTimeSelected.minute ).isBefore(DateTime(assessmentData.date.year, assessmentData.date.month, assessmentData.date.day, assessmentData.time.hour, assessmentData.time.minute))){
                                      await firestoreService.addTask(assessmentData.assessmentName+" Revision #"+i.toString(), Timestamp.fromDate(DateTime(assessmentData.regRevStartDate.year, assessmentData.regRevStartDate.month, assessmentData.regRevStartDate.day, _currentRevisionTimeSelected.hour,_currentRevisionTimeSelected.minute )), true, false, "Revision", assessmentData.className);
                                      assessmentData.regRevStartDate = assessmentData.regRevStartDate.add(Duration(days: assessmentData.regRevInterval));
                                      i++;
                                    }
                                  }
                                  await firestoreService.getAllAssessments(currentAssessmentDropdownItemSelected);
                                  await firestoreService.getAllAssessments(currentAssessmentDropdownItemSelected);
                                  await firestoreService.getAllAssessments(currentAssessmentDropdownItemSelected);
                                  
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AssessmentsPage()));
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
                                    "ADD ASSESSMENT",
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
