import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_hub/pages/AfterLogin/Assessments.dart';
import 'package:time_range/time_range.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'package:validators/validators.dart' as validator;
import 'package:study_hub/data/data.dart';
import 'package:study_hub/pages/AfterLogin/schedule.dart';
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

class AddClassPage extends StatefulWidget {
  AddClassPage({Key key}) : super(key: key);

  @override
  AddClassPageState createState() => AddClassPageState();
}

class AddClassPageState extends State<AddClassPage> {
  AddClassFormData classData = AddClassFormData();
  List<bool> daysSelected = List.filled(7, false);
  DateTime _currentStartDateSelected;
  DateTime _currentEndDateSelected;
  TimeOfDay _currentStartTimeSelected;
  TimeOfDay _currentEndTimeSelected;
  bool loading;
  String error;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    setState(() {
      _currentStartDateSelected = DateTime.now();
      _currentEndDateSelected = DateTime.now();
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
    var currentYearSelected = currentDropdownItemSelected;
    DateTime now = DateTime.now();
    DateTime firstDate = DateTime.utc(now.year - 5, 1, 1);
    DateTime lastDate = DateTime.utc(now.year + 5, 1, 1);
    DateTime startDate;
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
                  "New Class",
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
                                await firestoreService.addClass(currentDropdownItemSelected, classData.className, classData.daysOfWeek, classData.startDate, classData.endDate, classData.startTime, classData.endTime, classData.classLink);
                                await firestoreService.getClasses(currentDropdownItemSelected);
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
                                  "CREATE CLASS",
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
