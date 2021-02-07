import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_hub/pages/AfterLogin/Assessments.dart';
import 'package:time_range/time_range.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'package:validators/validators.dart' as validator;
import 'package:study_hub/data/data.dart';
import 'package:study_hub/pages/AfterLogin/schedule.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

class EditClassPage extends StatefulWidget {
  String className;
  String ogClassName;
  List<bool> daysOfWeek;
  Timestamp endDate;
  Timestamp endTime;
  String link;
  Timestamp startDate;
  Timestamp startTime;
  EditClassPage({Key key, this.startTime, this.startDate, this.link, this.endTime, this.endDate, this.daysOfWeek, this.className, this.ogClassName}) : super(key: key);

  @override
  EditClassPageState createState() => EditClassPageState(className: className, ogClassName: ogClassName, daysOfWeek: daysOfWeek, endDate: endDate, endTime: endTime, link: link, startDate: startDate, startTime: startTime);
}

class EditClassPageState extends State<EditClassPage> {
  String className;
  String ogClassName;
  List<bool> daysOfWeek;
  Timestamp endDate;
  Timestamp endTime;
  String link;
  Timestamp startDate;
  Timestamp startTime;
  EditClassPageState({this.ogClassName, this.className, this.daysOfWeek, this.endDate, this.endTime, this.link, this.startDate, this.startTime});
  AddClassFormData classData = AddClassFormData();
  DateTime _currentStartDateSelected;
  DateTime _currentEndDateSelected;
  TimeOfDay _currentStartTimeSelected;
  TimeOfDay _currentEndTimeSelected;
  List daysSelected;
  bool loading;
  String error;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    print("LISTSTSST\n"+daysOfWeek.toString());
    super.initState();
    setState(() {
      daysSelected = daysOfWeek;
      _currentStartDateSelected = startDate.toDate();
      _currentEndDateSelected = endDate.toDate();
      _currentStartTimeSelected = TimeOfDay.fromDateTime(startTime.toDate());
      _currentEndTimeSelected = TimeOfDay.fromDateTime(endTime.toDate());
    });
  }

  void buttonPressed() {
    setState(() {
      if (error != null) error = null;
      if(_currentStartDateSelected!=null) classData.startDate = _currentStartDateSelected;
      else error = "Select a start date";
      if(_currentEndDateSelected!=null) classData.endDate = _currentEndDateSelected;
      else error = "Select an end date";
      classData.startTime = _currentStartTimeSelected;
      classData.endTime = _currentEndTimeSelected;
      classData.daysOfWeek = daysSelected;
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
    DateTime now = DateTime.now();
    var preTextWidth = MediaQuery.of(context).size.width * (1.0 / 19.0);
    final contextHeight = MediaQuery.of(context).size.height;
    final MockupHeight = 850.9090909090909;
    return Scaffold(
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
                  "Class",
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
                child: Column(
                    children: [
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
                        initialValue: className,
                        hintText: "Class Name",
                        textColor: Colors.white,
                        isEmail: true,
                        Validator: (String value) {
                          if (value.isEmpty) {
                            return "Class name is required";
                          }
                          _formKey.currentState.save();
                          return null;
                        },
                        onSaved: (String value) {
                          classData.className = value;
                        },
                      ),
                      Container(
                        height: error!=null ? (910) / MockupHeight * contextHeight: (830) / MockupHeight * contextHeight,
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
                                "Start date",
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
                                    _currentStartDateSelected == null
                                        ? 'Select a Date'
                                        : months[
                                    _currentStartDateSelected.month - 1] +
                                        " " +
                                        _currentStartDateSelected.day.toString() +
                                        ", " +
                                        _currentStartDateSelected.year.toString(),
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
                                        _currentStartDateSelected == null
                                            ? DateTime.now()
                                            : _currentStartDateSelected,
                                        firstDate: DateTime(now.year - 5),
                                        lastDate: DateTime(now.year + 5))
                                        .then((date) {
                                      setState(() {
                                        _currentStartDateSelected = date;
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
                                        _currentStartDateSelected == null
                                            ? DateTime.now()
                                            : _currentStartDateSelected,
                                        firstDate: DateTime(now.year - 5),
                                        lastDate: DateTime(now.year + 5))
                                        .then((date) {
                                      setState(() {
                                        _currentStartDateSelected = date;
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
                                "End Date",
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
                                    _currentEndDateSelected == null
                                        ? 'Select a Date'
                                        : months[_currentEndDateSelected.month - 1] +
                                        " " +
                                        _currentEndDateSelected.day.toString() +
                                        ", " +
                                        _currentEndDateSelected.year.toString(),
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
                                        _currentEndDateSelected == null
                                            ? DateTime.now()
                                            : _currentEndDateSelected,
                                        firstDate: DateTime(now.year - 5),
                                        lastDate: DateTime(now.year + 5))
                                        .then((date) {
                                      setState(() {
                                        _currentEndDateSelected = date;
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
                                        _currentEndDateSelected == null
                                            ? DateTime.now()
                                            : _currentEndDateSelected,
                                        firstDate: DateTime(now.year - 5),
                                        lastDate: DateTime(now.year + 5))
                                        .then((date) {
                                      setState(() {
                                        _currentEndDateSelected = date;
                                      });
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox.fromSize(
                              size: Size(0.0, contextHeight * (1.0 / 17.0)),
                            ),
                            TimeRange(
                              fromTitle: Text(
                                'From',
                                style: TextStyle(
                                    fontFamily: 'Abel',
                                    fontSize: 18,
                                    color: Theme.of(context).primaryColor),
                              ),
                              toTitle: Text(
                                'To',
                                style: TextStyle(
                                    fontFamily: 'Abel',
                                    fontSize: 18,
                                    color: Theme.of(context).primaryColor),
                              ),
                              titlePadding: 20,
                              textStyle: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black87,
                                fontFamily: 'Abel',
                              ),
                              activeTextStyle: TextStyle(
                                  fontFamily: 'Abel',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              borderColor: Theme.of(context).primaryColor,
                              backgroundColor: Colors.transparent,
                              activeBackgroundColor: Theme.of(context).primaryColor,
                              firstTime: TimeOfDay(hour: 00, minute: 00),
                              lastTime: TimeOfDay(hour: 24, minute: 00),
                              initialRange: TimeRangeResult(_currentStartTimeSelected, _currentEndTimeSelected),
                              timeStep: 15,
                              timeBlock: 15,
                              onRangeCompleted: (range) => setState(() {
                                _currentStartTimeSelected = range.start;
                                _currentEndTimeSelected = range.end;
                              }),
                            ),
                            SizedBox.fromSize(
                              size: Size(0.0, contextHeight * (1.0 / 17.0)),
                            ),
                            Row(children: [
                              SizedBox(
                                width: preTextWidth,
                              ),
                              Text(
                                "Days of the week",
                                style: TextStyle(
                                  fontFamily: 'Abel',
                                  fontSize: 18.0 / MockupHeight * contextHeight,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ]),
                            SizedBox(
                              width: 350 / MockupHeight * contextHeight,
                              child: WeekdaySelector(
                                fillColor: Color(0xFFDEF3FF),
                                elevation: 3,
                                selectedElevation: 0,
                                selectedFillColor: Theme.of(context).primaryColor,
                                selectedShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(
                                      5.0 / MockupHeight * contextHeight)),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(
                                      5.0 / MockupHeight * contextHeight)),
                                ),
                                //selectedColor: Color(0xFF00417D),
                                onChanged: (int day) {
                                  setState(() {
                                    // Use module % 7 as Sunday's index in the array is 0 and
                                    // DateTime.sunday constant integer value is 7.
                                    final index = day % 7;
                                    daysSelected[index] = !daysSelected[index];
                                  });
                                },
                                values: daysSelected,
                              ),
                            ),
                            SizedBox.fromSize(
                              size: Size(0.0, contextHeight * (1.0 / 17.0)),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: preTextWidth,
                                ),
                                Text(
                                  "Class Link",
                                  style: TextStyle(
                                    fontFamily: 'Abel',
                                    fontSize: 18.0 / MockupHeight * contextHeight,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            BuildTextFormField(
                              initialValue: link,
                              hintText: "https://www.zoom.us/xxxxxxxxxxxx",
                              Validator:(String value){
                                if(!value.isEmpty && !validator.isURL(value)){
                                  return "Please enter a valid URL or leave blank.";
                                }
                                return null;
                              },
                              onSaved: (String val){
                                classData.classLink = val;
                              },
                            ),
                            loading == true
                                ? LinearProgressIndicator(
                              backgroundColor: Theme.of(context).primaryColor,
                            )
                                : error != null ? CupertinoAlertDialog(
                              title: Text(
                                error != null ? error : "",
                                style: TextStyle(
                                    fontSize:
                                    18.0 / MockupHeight * contextHeight,
                                    fontFamily: 'Abel',
                                    color: Colors.red),
                              ),
                            ): SizedBox(height: 50,),
                            Center(
                                child: SizedBox(
                                  width:
                                  (182.0 / 207.0) * MediaQuery.of(context).size.width,
                                  height: (25.0 / 448.0) * contextHeight,
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10.0 / MockupHeight * contextHeight),
                                    ),
                                    onPressed: () async {
                                      buttonPressed();
                                      if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                        nowLoading();
                                        print(currentDropdownItemSelected);
                                        final now = DateTime.now();
                                        await firestoreService.editClass(classData.className, ogClassName, classData.daysOfWeek, Timestamp.fromDate(classData.endDate), Timestamp.fromDate(DateTime(now.year, now.month, now.day, classData.endTime.hour,classData.endTime.minute )),classData.classLink, Timestamp.fromDate(classData.startDate), Timestamp.fromDate(DateTime(now.year, now.month, now.day, classData.startTime.hour,classData.startTime.minute)));
                                        firestoreService.returnList = [];
                                        firestoreService.assessmentsMap[currentDropdownItemSelected] = [];
                                        firestoreService.tasksMap[currentDropdownItemSelected] = [];
                                        firestoreService.materialsMap[currentDropdownItemSelected] = [];
                                        await firestoreService.getClasses(currentDropdownItemSelected);
                                        await firestoreService.getClasses(currentDropdownItemSelected);
                                        await firestoreService.getClasses(currentDropdownItemSelected);

                                        await firestoreService.getAllTasks();
                                        await firestoreService.getAllTasks();
                                        await firestoreService.getAllTasks();

                                        await firestoreService.getAllMaterials();
                                        await firestoreService.getAllMaterials();
                                        await firestoreService.getAllMaterials();

                                        await firestoreService.getAllAssessments(currentDropdownItemSelected);
                                        await firestoreService.getAllAssessments(currentDropdownItemSelected);
                                        await firestoreService.getAllAssessments(currentDropdownItemSelected);

                                        await firestoreService.getAllMaterials();
                                        await firestoreService.getAllMaterials();
                                        await firestoreService.getAllMaterials();

                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SchedulePage()));
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
                                          "UPDATE CLASS",
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
    );
  }
}

class BuildTextFormField extends StatelessWidget {
  String initialValue;
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
    this.initialValue
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
