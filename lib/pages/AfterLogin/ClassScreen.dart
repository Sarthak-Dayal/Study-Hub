import 'package:flutter/material.dart';
import 'package:study_hub/pages/AddScreens/AddAssessment.dart';
import 'package:study_hub/pages/AddScreens/AddTask.dart';
import 'package:study_hub/pages/AfterLogin/Tasks.dart';
import 'package:study_hub/pages/AfterLogin/schedule.dart';
import 'package:intl/intl.dart';
import 'package:study_hub/pages/EditScreens/EditTask.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:study_hub/data/data.dart';
import 'package:validators/validators.dart' as validator;
import 'package:study_hub/pages/EditScreens/EditAssessment.dart';
import 'package:study_hub/pages/AddScreens/AddMaterial.dart';
import 'package:study_hub/pages/AfterLogin/MaterialsWebView.dart';
import 'package:study_hub/pages/AfterLogin/ClassDashboard.dart';
import 'package:study_hub/pages/AfterLogin/FancyFAB.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_hub/pages/EditScreens/EditClass.dart';
class ClassScreen extends StatefulWidget {
  final String className;
  List<bool> daysOfWeek;
  Timestamp endDate;
  Timestamp endTime;
  String link;
  Timestamp startDate;
  Timestamp startTime;
  ClassScreen({this.className, this.startTime, this.endTime, this.link, this.endDate, this.startDate, this.daysOfWeek});
  @override
  _ClassScreenState createState() => _ClassScreenState(className: className, daysOfWeek: daysOfWeek, endDate: endDate, endTime: endTime, link: link, startDate: startDate, startTime: startTime);
}

class _ClassScreenState extends State<ClassScreen> {
  futureFunction() async {
    firestoreService.assessmentsMap[currentDropdownItemSelected] = [];
    await firestoreService.getAssessmentByClass(currentDropdownItemSelected, className);
    await firestoreService.getAssessmentByClass(currentDropdownItemSelected, className);
    await firestoreService.getAssessmentByClass(currentDropdownItemSelected, className);
    await firestoreService.getAssessmentByClass(currentDropdownItemSelected, className);
    await firestoreService.getAssessmentByClass(currentDropdownItemSelected, className);

    firestoreService.tasksMap[currentDropdownItemSelected] = [];
    await firestoreService.getTaskByClass(className);
    await firestoreService.getTaskByClass(className);
    await firestoreService.getTaskByClass(className);
    await firestoreService.getTaskByClass(className);
    await firestoreService.getTaskByClass(className);

    firestoreService.materialsMap[currentDropdownItemSelected] = [];
    await firestoreService.getMaterialsByClass(className);
    await firestoreService.getMaterialsByClass(className);
    await firestoreService.getMaterialsByClass(className);
    await firestoreService.getMaterialsByClass(className);
    await firestoreService.getMaterialsByClass(className);
  }
  @override
  void initState() {
    currentTasksDropdownItemSelected = currentDropdownItemSelected;
    super.initState();
  }

  int _currentNavIndex = 0;
  String className;
  List<bool> daysOfWeek;
  Timestamp endDate;
  Timestamp endTime;
  String link;
  Timestamp startDate;
  Timestamp startTime;
  _ClassScreenState({this.className, this.daysOfWeek, this.endDate, this.endTime, this.link, this.startDate, this.startTime});
  @override
  Widget build(BuildContext context) {
    Widget dashboardFab = FancyFab();
    Widget taskFab = FloatingActionButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AddTaskPage()));
      },
      child: Image.asset("images/Add.png"),
      backgroundColor: Colors.white,
    );
    Widget assessmentFab = FloatingActionButton(
        child: Image.asset("images/Add.png"),
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddAssessmentPage()));
        });
    Widget materialsFab = FloatingActionButton(
        child: Image.asset("images/Add.png"),
        backgroundColor: Colors.white,
        onPressed: () {
          file = null;
          fileName = null;
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddMaterialPage()));
        });
    List<Widget> FloatingActionButtons = [dashboardFab, taskFab, assessmentFab, materialsFab];
    print(className);
    final List<Widget> _children = [
      Center(
          child: BuildClassDashBoardView(
        className: className,
      )),
      Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Center(
              child: BuildTasksClassView(
            className: className,
          )),
        ],
      ),
      Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Center(
              child: BuildAssessmentsClassView(
            className: className,
          )),
        ],
      ),
      Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Center(
              child: BuildMaterialsClassView(
            className: className,
          )),
        ],
      ),
      Center(child: Text("Page5"))
    ];
    final contextHeight = MediaQuery.of(context).size.height;
    final appBarHeight = 1.0 / 11 * contextHeight;
    return Scaffold(
      floatingActionButton: FloatingActionButtons[_currentNavIndex],
      body: _children[_currentNavIndex],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(10 / 850.9090909090909 * contextHeight),
          child: AppBar(
            actions: [
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 13,
                    ),
                    Row(
                      children: [
                        Theme(
                          data: Theme.of(context).copyWith(
                            cardColor: Color(0XFFEFEEEE),
                          ),
                          child: PopupMenuButton(
                            onSelected: (i) async {
                              if (i == 1) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                          "Delete Class",
                                          style: TextStyle(
                                              fontSize: 24.0 / 850.9090909090909 * contextHeight,
                                              color: Theme.of(context).primaryColor,
                                              fontFamily: 'Abel',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        content: Text(
                                            "Are you sure you want to delete this class? This will get rid of all the tasks, materials and assessments in the class.",
                                          style: TextStyle(
                                              fontSize: 18.0 / 850.9090909090909 * contextHeight,
                                              color: Theme.of(context).primaryColor,
                                              fontFamily: 'Abel',
                                              ),
                                        ),
                                        actions: [
                                          FlatButton(
                                            onPressed: ()async{
                                              await firestoreService.deleteClass(className);
                                              await futureFunction();
                                              firestoreService.returnList = [];
                                              await firestoreService.getClasses(currentDropdownItemSelected);
                                              await firestoreService.getClasses(currentDropdownItemSelected);
                                              await firestoreService.getClasses(currentDropdownItemSelected);
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>SchedulePage()));
                                            },
                                            child: Text(
                                              "Confirm",
                                              style: TextStyle(
                                                fontSize: 18.0 / 850.9090909090909 * contextHeight,
                                                color: Theme.of(context).primaryColor,
                                                fontFamily: 'Abel',
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              }
                              if(i==0){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditClassPage(className: className,ogClassName: className,startDate: startDate,startTime: startTime,endDate: endDate,endTime: endTime,daysOfWeek: daysOfWeek,link: link,)));
                              }
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuItem>[
                              PopupMenuItem(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    Text(
                                      'Edit',
                                      style: TextStyle(
                                        fontSize: 18.0 /
                                            850.9090909090909 *
                                            contextHeight,
                                        color: Theme.of(context).primaryColor,
                                        fontFamily: 'Abel',
                                      ),
                                    ),
                                  ],
                                ),
                                value: 0,
                              ),
                              PopupMenuItem(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    Text(
                                      'Delete',
                                      style: TextStyle(
                                        fontSize: 18.0 /
                                            850.9090909090909 *
                                            contextHeight,
                                        color: Theme.of(context).primaryColor,
                                        fontFamily: 'Abel',
                                      ),
                                    ),
                                  ],
                                ),
                                value: 1,
                              ),
                            ],
                            child: Icon(
                              Icons.more_horiz,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
            leading: Column(children: [
              SizedBox(
                height: 16 / 850.9090909090909 * contextHeight,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios)),
            ]),
            centerTitle: true,
            title: Column(children: [
              SizedBox(
                height: (16) / 850.9090909090909 * contextHeight,
              ),
              Text(
                className,
                style: TextStyle(
                  fontSize: (24.0) / 850.9090909090909 * contextHeight,
                  color: Colors.white,
                  fontFamily: 'Abel',
                ),
              ),
            ]),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            _currentNavIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        currentIndex:
            _currentNavIndex, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.check_circle),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
              icon: new Icon(Icons.assessment), label: 'Assessments'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Materials')
        ],
      ),
    );
  }
}

class BuildTasksClassView extends StatefulWidget {
  final String className;
  BuildTasksClassView({this.className});
  @override
  _BuildTasksClassViewState createState() =>
      _BuildTasksClassViewState(className: className);
}

class _BuildTasksClassViewState extends State<BuildTasksClassView> {
  String className;
  _BuildTasksClassViewState({this.className});
  int scoreInput;
  Future getClassTasks() async {
    print(className);
    currentTasksDropdownItemSelected = currentDropdownItemSelected;
    firestoreService.tasksMap[currentDropdownItemSelected] = [];
    await firestoreService.getTaskByClass(className);
    print("Below!");
    print(firestoreService.tasksMap[currentDropdownItemSelected]);
    await firestoreService.getTaskByClass(className);
    print("Below!");
    print(firestoreService.tasksMap[currentDropdownItemSelected]);
    await firestoreService.getTaskByClass(className);
    await firestoreService.getTaskByClass(className);
    print("Below!");
    print(firestoreService.tasksMap[currentDropdownItemSelected]);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final contextHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: SizedBox(
        height: 676.6 / 850.9090909090909 * contextHeight,
        width: 360 / 850.9090909090909 * contextHeight,
        child: FutureBuilder(
          future: getClassTasks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (firestoreService
                  .tasksMap[currentDropdownItemSelected].isNotEmpty)
                return RefreshIndicator(
                  onRefresh: () async {
                    print(currentDropdownItemSelected);
                    await getClassTasks();
                    setState(() {});
                  },
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: firestoreService
                        .tasksMap[currentDropdownItemSelected].length,
                    itemBuilder: (context, index) {
                      final tasksName = firestoreService
                          .tasksMap[currentDropdownItemSelected][index][0];
                      final dueDate = firestoreService
                          .tasksMap[currentDropdownItemSelected][index][1];
                      final type = firestoreService
                          .tasksMap[currentDropdownItemSelected][index][4];
                      final className = firestoreService
                          .tasksMap[currentDropdownItemSelected][index][5];
                      return Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: Color(0XFFEFEEEE),
                              child: SizedBox(
                                height: 90 / 850.9090909090909 * contextHeight,
                                width: MediaQuery.of(context).size.width,
                                child: ListTile(
                                  isThreeLine: true,
                                  trailing: Theme(
                                    data: Theme.of(context).copyWith(
                                      cardColor: Color(0XFFEFEEEE),
                                    ),
                                    child: PopupMenuButton(
                                      onSelected: (i) async {
                                        if (i == 2) {
                                          await firestoreService.deleteTask(
                                              tasksName,
                                              dueDate,
                                              type,
                                              className);
                                          firestoreService.tasksMap[
                                              currentDropdownItemSelected] = [];
                                          getClassTasks().then((_) {
                                            setState(() {});
                                          });
                                          await getClassTasks().then((_) {
                                            setState(() {});
                                          });
                                          await getClassTasks().then((_) {
                                            setState(() {});
                                          });
                                        }
                                        if (i == 1) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditTaskPage(
                                                        taskName: tasksName,
                                                        className: className,
                                                        dueDate:
                                                            dueDate.toDate(),
                                                        type: type,
                                                        ogDueDate:
                                                            dueDate.toDate(),
                                                        ogTaskName: tasksName,
                                                        ogType: type,
                                                      )));
                                        }
                                        if (i == 0) {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    "Mark as Done",
                                                    style: TextStyle(
                                                      fontSize: 24.0 /
                                                          850.9090909090909 *
                                                          contextHeight,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontFamily: 'Abel',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  content: Text(
                                                    "Are you sure you want to mark this task and done and discard it?",
                                                    style: TextStyle(
                                                      fontSize: 18.0 /
                                                          850.9090909090909 *
                                                          contextHeight,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontFamily: 'Abel',
                                                    ),
                                                  ),
                                                  actions: [
                                                    FlatButton(
                                                      onPressed: () async {
                                                        await firestoreService
                                                            .deleteTask(
                                                                tasksName,
                                                                dueDate,
                                                                type,
                                                                className);
                                                        firestoreService
                                                                .tasksMap[
                                                            currentDropdownItemSelected] = [];
                                                        await getClassTasks()
                                                            .then((_) {
                                                          setState(() {});
                                                        });
                                                        await getClassTasks()
                                                            .then((_) {
                                                          setState(() {});
                                                        });
                                                        await getClassTasks()
                                                            .then((_) {
                                                          setState(() {});
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        "Confirm",
                                                        style: TextStyle(
                                                          fontSize: 18.0 /
                                                              850.9090909090909 *
                                                              contextHeight,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontFamily: 'Abel',
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                );
                                              });
                                        }

                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuItem>[
                                        PopupMenuItem(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.check_circle,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              Text(
                                                'Done',
                                                style: TextStyle(
                                                  fontSize: 18.0 /
                                                      850.9090909090909 *
                                                      contextHeight,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontFamily: 'Abel',
                                                ),
                                              ),
                                            ],
                                          ),
                                          value: 0,
                                        ),
                                        PopupMenuItem(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.edit,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              Text(
                                                'Edit',
                                                style: TextStyle(
                                                  fontSize: 18.0 /
                                                      850.9090909090909 *
                                                      contextHeight,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontFamily: 'Abel',
                                                ),
                                              ),
                                            ],
                                          ),
                                          value: 1,
                                        ),
                                        PopupMenuItem(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              Text(
                                                'Delete',
                                                style: TextStyle(
                                                  fontSize: 18.0 /
                                                      850.9090909090909 *
                                                      contextHeight,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontFamily: 'Abel',
                                                ),
                                              ),
                                            ],
                                          ),
                                          value: 2,
                                        ),
                                      ],
                                      child: Icon(
                                        Icons.more_horiz,
                                        size: 40,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                  leading: Icon(
                                    type == "Revision"
                                        ? Icons.book
                                        : (type == "Assignment"
                                            ? Icons.assignment
                                            : Icons.view_agenda),
                                    color: Theme.of(context).primaryColor,
                                    size: 45,
                                  ),
                                  title: Text(
                                    tasksName,
                                    style: TextStyle(
                                      fontFamily: 'Abel',
                                      fontSize: 16.0 /
                                          850.9090909090909 *
                                          contextHeight,
                                    ),
                                  ),
                                  subtitle: Text(
                                    type +
                                        " - " +
                                        className +
                                        "\n" +
                                        "${DateFormat.yMMMd("en").format(dueDate.toDate())}" +
                                        " at " +
                                        "${DateFormat.jm("en").format(dueDate.toDate())}",
                                    style: TextStyle(
                                      fontFamily: 'Abel',
                                      fontSize: 14.0 /
                                          850.9090909090909 *
                                          contextHeight,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0 / 850.9090909090909 * contextHeight,
                          )
                        ],
                      );
                    },
                  ),
                );
              else {
                final contextHeight = MediaQuery.of(context).size.height;
                final appBarHeight = 1.0 / 11 * contextHeight;
                return Column(
                  children: [
                    SizedBox(
                      height: (contextHeight -
                                  appBarHeight -
                                  100 / 850.9090909090909 * contextHeight) /
                              2.0 -
                          1.0 / 100.0 * contextHeight,
                    ),
                    Center(
                      child: Text(
                        "No tasks here!",
                        style: TextStyle(
                          fontSize: 24.0 / 850.9090909090909 * contextHeight,
                          color: Theme.of(context).primaryColor,
                          fontFamily: 'Abel',
                        ),
                      ),
                    ),
                  ],
                );
              }
            }
            return Center(
              child: SizedBox(
                height: 10,
                child: LinearProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class BuildAssessmentsClassView extends StatefulWidget {
  final String className;
  BuildAssessmentsClassView({this.className});
  @override
  _BuildAssessmentsClassViewState createState() =>
      _BuildAssessmentsClassViewState(className: className);
}

class _BuildAssessmentsClassViewState extends State<BuildAssessmentsClassView> {
  final String className;
  _BuildAssessmentsClassViewState({this.className});
  ScoreData quizScoreData = ScoreData();
  ScoreData testScoreData = ScoreData();
  ScoreData otherScoreData = ScoreData();
  int scoreInput;
  Future getAllAssessmentsAndScores() async {
    firestoreService.assessmentsMap[currentDropdownItemSelected] = [];
    await firestoreService.getAssessmentByClass(
        currentDropdownItemSelected, className);
    await firestoreService.getAssessmentByClass(
        currentDropdownItemSelected, className);
    await firestoreService.getAssessmentByClass(
        currentDropdownItemSelected, className);
    await firestoreService.getAssessmentByClass(
        currentDropdownItemSelected, className);
  }

  @override
  Widget build(BuildContext context) {
    final contextHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: SizedBox(
        height: 676 / 850.9090909090909 * contextHeight,
        width: 360 / 850.9090909090909 * contextHeight,
        child: FutureBuilder(
          future: getAllAssessmentsAndScores(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (firestoreService
                  .assessmentsMap[currentDropdownItemSelected].isNotEmpty)
                return RefreshIndicator(
                  onRefresh: () async {
                    print(currentDropdownItemSelected);
                    await firestoreService.getAssessmentByClass(
                        currentDropdownItemSelected, className);
                    setState(() {});
                  },
                  child: CustomScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          if (index >=
                              firestoreService
                                  .assessmentsMap[currentDropdownItemSelected]
                                  .length) return null;
                          final assessmentName = firestoreService
                                  .assessmentsMap[currentDropdownItemSelected]
                              [index][0];
                          final type = firestoreService
                                  .assessmentsMap[currentDropdownItemSelected]
                              [index][1];
                          final date = firestoreService
                                  .assessmentsMap[currentDropdownItemSelected]
                              [index][2];
                          final time = firestoreService
                                  .assessmentsMap[currentDropdownItemSelected]
                              [index][3];
                          final bool regRev = firestoreService
                                  .assessmentsMap[currentDropdownItemSelected]
                              [index][4];
                          final regRevInterval = firestoreService
                                  .assessmentsMap[currentDropdownItemSelected]
                              [index][5];
                          final regRevStartDate = firestoreService
                                  .assessmentsMap[currentDropdownItemSelected]
                              [index][6];
                          final className = firestoreService
                                  .assessmentsMap[currentDropdownItemSelected]
                              [index][9];
                          return Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  color: Color(0XFFEFEEEE),
                                  child: SizedBox(
                                    height:
                                        75 / 850.9090909090909 * contextHeight,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListTile(
                                      isThreeLine: true,
                                      trailing: Theme(
                                        data: Theme.of(context).copyWith(
                                          cardColor: Color(0XFFEFEEEE),
                                        ),
                                        child: PopupMenuButton(
                                          onSelected: (i) async {
                                            print("Selected " + i.toString());
                                            if (i == 2) {
                                              await firestoreService
                                                  .deleteAssessment(
                                                      assessmentName,
                                                      className,
                                                      type,
                                                      time,
                                                      date);
                                              firestoreService.assessmentsMap[
                                                  currentDropdownItemSelected] = [];
                                              await firestoreService
                                                  .getAssessmentByClass(
                                                      currentDropdownItemSelected,
                                                      className)
                                                  .then((_) {
                                                setState(() {});
                                              });
                                              await firestoreService
                                                  .getAssessmentByClass(
                                                      currentDropdownItemSelected,
                                                      className)
                                                  .then((_) {
                                                setState(() {});
                                              });
                                              await firestoreService
                                                  .getAssessmentByClass(
                                                      currentDropdownItemSelected,
                                                      className)
                                                  .then((_) {
                                                setState(() {});
                                              });
                                            } else if (i == 1) {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    final _FormKey =
                                                        GlobalKey<FormState>();
                                                    return AlertDialog(
                                                      title: Text(
                                                        "Add Score",
                                                        style: TextStyle(
                                                            fontSize: 24.0 /
                                                                850.9090909090909 *
                                                                contextHeight,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontFamily: 'Abel',
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      content: Form(
                                                        key: _FormKey,
                                                        child: TextFormField(
                                                          maxLength: 3,
                                                          decoration:
                                                              InputDecoration(
                                                                  hintText:
                                                                      "%"),
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          validator: (v) {
                                                            if (!validator
                                                                    .isInt(v) ||
                                                                !(0 <=
                                                                    int.parse(
                                                                        v)) ||
                                                                !(150 >=
                                                                    int.parse(
                                                                        v))) {
                                                              return "Enter a percentage between 0 and 150";
                                                            } else {
                                                              scoreInput =
                                                                  int.parse(v);
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ),
                                                      actions: [
                                                        FlatButton(
                                                          onPressed: () async {
                                                            if (_FormKey
                                                                .currentState
                                                                .validate()) {
                                                              await firestoreService
                                                                  .addScore(
                                                                      scoreInput,
                                                                      type)
                                                                  .then(
                                                                      (_) async {
                                                                await firestoreService
                                                                    .deleteAssessment(
                                                                        assessmentName,
                                                                        className,
                                                                        type,
                                                                        time,
                                                                        date);
                                                                firestoreService
                                                                        .assessmentsMap[
                                                                    currentDropdownItemSelected] = [];
                                                                await firestoreService
                                                                    .getAssessmentByClass(
                                                                        currentDropdownItemSelected,
                                                                        className)
                                                                    .then((_) {
                                                                  setState(
                                                                      () {});
                                                                }).catchError(
                                                                        (error) {
                                                                  print(error);
                                                                });
                                                                await firestoreService
                                                                    .getAssessmentByClass(
                                                                        currentDropdownItemSelected,
                                                                        className)
                                                                    .then((_) {
                                                                  setState(
                                                                      () {});
                                                                }).catchError(
                                                                        (error) {
                                                                  print(error);
                                                                });
                                                                await firestoreService
                                                                    .getAssessmentByClass(
                                                                        currentDropdownItemSelected,
                                                                        className)
                                                                    .then((_) {
                                                                  setState(
                                                                      () {});
                                                                }).catchError(
                                                                        (error) {
                                                                  print(error);
                                                                });
                                                              }).catchError(
                                                                      (error) {
                                                                print(error);
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            }
                                                          },
                                                          child: Text(
                                                            "Add Score",
                                                            style: TextStyle(
                                                              fontSize: 18.0 /
                                                                  850.9090909090909 *
                                                                  contextHeight,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              fontFamily:
                                                                  'Abel',
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    );
                                                  });
                                            } else if (i == 0) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditAssessmentPage(
                                                            className:
                                                                className,
                                                            date: date.toDate(),
                                                            time: TimeOfDay
                                                                .fromDateTime(time
                                                                    .toDate()),
                                                            type: type,
                                                            name:
                                                                assessmentName,
                                                            regRev: regRev,
                                                            regRevInterval:
                                                                regRevInterval,
                                                            revisionDate:
                                                                regRevStartDate
                                                                    .toDate(),
                                                            ogDate:
                                                                date.toDate(),
                                                            ogName:
                                                                assessmentName,
                                                            ogRegRev: regRev,
                                                            ogRegRevInterval:
                                                                regRevInterval,
                                                            ogRevisionDate:
                                                                regRevStartDate
                                                                    .toDate(),
                                                            ogTime: TimeOfDay
                                                                .fromDateTime(time
                                                                    .toDate()),
                                                            ogType: type,
                                                          )));
                                            }
                                          },
                                          itemBuilder: (BuildContext context) =>
                                              <PopupMenuItem>[
                                            PopupMenuItem(
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.edit,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  Text(
                                                    'Edit',
                                                    style: TextStyle(
                                                      fontSize: 18.0 /
                                                          850.9090909090909 *
                                                          contextHeight,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontFamily: 'Abel',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              value: 0,
                                            ),
                                            PopupMenuItem(
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.add_chart,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  Text(
                                                    'Add Score',
                                                    style: TextStyle(
                                                      fontSize: 18.0 /
                                                          850.9090909090909 *
                                                          contextHeight,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontFamily: 'Abel',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              value: 1,
                                            ),
                                            PopupMenuItem(
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.delete,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                      fontSize: 18.0 /
                                                          850.9090909090909 *
                                                          contextHeight,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontFamily: 'Abel',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              value: 2,
                                            ),
                                          ],
                                          child: Icon(
                                            Icons.more_horiz,
                                            size: 40,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                      leading: Icon(
                                        type == "Quiz"
                                            ? Icons.ballot
                                            : (type == "Test"
                                                ? Icons.assessment
                                                : Icons.assignment),
                                        color: Theme.of(context).primaryColor,
                                        size: 45,
                                      ),
                                      title: Text(
                                        assessmentName,
                                        style: TextStyle(
                                          fontFamily: 'Abel',
                                          fontSize: 18.0 /
                                              850.9090909090909 *
                                              contextHeight,
                                        ),
                                      ),
                                      subtitle: Text(
                                        type +
                                            " - " +
                                            className +
                                            "\n" +
                                            "${DateFormat.yMMMd("en").format(date.toDate())}" +
                                            " at " +
                                            TimeOfDay.fromDateTime(
                                                    time.toDate())
                                                .format(context),
                                        style: TextStyle(
                                          fontFamily: 'Abel',
                                          fontSize: 14.0 /
                                              850.9090909090909 *
                                              contextHeight,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    10.0 / 850.9090909090909 * contextHeight,
                              ),
                            ],
                          );
                        }),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 40,
                        ),
                      )
                    ],
                  ),
                );
              else {
                final contextHeight = MediaQuery.of(context).size.height;
                final appBarHeight = 1.0 / 11 * contextHeight;
                return Column(
                  children: [
                    SizedBox(
                      height: (contextHeight -
                                  appBarHeight -
                                  100 / 850.9090909090909 * contextHeight) /
                              2.0 -
                          1.0 / 100.0 * contextHeight,
                    ),
                    Center(
                      child: Text(
                        "No assessments here!",
                        style: TextStyle(
                          fontSize: 24.0 / 850.9090909090909 * contextHeight,
                          color: Theme.of(context).primaryColor,
                          fontFamily: 'Abel',
                        ),
                      ),
                    ),
                  ],
                );
              }
            }
            return Center(
              child: SizedBox(
                height: 10,
                child: LinearProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class BuildMaterialsClassView extends StatefulWidget {
  final String className;
  BuildMaterialsClassView({this.className});
  @override
  _BuildMaterialsClassViewState createState() =>
      _BuildMaterialsClassViewState(className: className);
}

class _BuildMaterialsClassViewState extends State<BuildMaterialsClassView> {
  final String className;
  _BuildMaterialsClassViewState({this.className});
  int scoreInput;
  Future getClassMaterials() async {
    firestoreService.materialsMap[currentDropdownItemSelected] = [];
    await firestoreService.getMaterialsByClass(className);
    await firestoreService.getMaterialsByClass(className);
    await firestoreService.getMaterialsByClass(className);
    await firestoreService.getMaterialsByClass(className);
    await firestoreService.getMaterialsByClass(className);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final contextHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: SizedBox(
        height: 676 / 850.9090909090909 * contextHeight,
        width: 360 / 850.9090909090909 * contextHeight,
        child: FutureBuilder(
          future: getClassMaterials(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (firestoreService
                  .materialsMap[currentDropdownItemSelected].isNotEmpty)
                return RefreshIndicator(
                  onRefresh: () async {
                    print(currentDropdownItemSelected);
                    await getClassMaterials();
                    setState(() {});
                    await getClassMaterials();
                    setState(() {});
                    await getClassMaterials();
                    setState(() {});
                    await getClassMaterials();
                    setState(() {});
                    await getClassMaterials();
                    setState(() {});
                  },
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: firestoreService
                        .materialsMap[currentDropdownItemSelected].length,
                    itemBuilder: (context, index) {
                      final MaterialName = firestoreService
                          .materialsMap[currentDropdownItemSelected][index][0];
                      final dateAdded = firestoreService
                          .materialsMap[currentDropdownItemSelected][index][1];
                      final downloadLink = firestoreService
                          .materialsMap[currentDropdownItemSelected][index][2];
                      final type = firestoreService
                          .materialsMap[currentDropdownItemSelected][index][3];
                      final className = firestoreService
                          .materialsMap[currentDropdownItemSelected][index][4];
                      return Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: Color(0XFFEFEEEE),
                              child: SizedBox(
                                height: 75 / 850.9090909090909 * contextHeight,
                                width: MediaQuery.of(context).size.width,
                                child: ListTile(
                                  isThreeLine: true,
                                  trailing: Theme(
                                    data: Theme.of(context).copyWith(
                                      cardColor: Color(0XFFEFEEEE),
                                    ),
                                    child: PopupMenuButton(
                                      onSelected: (i) async {
                                        if (i == 1) {
                                          firestoreService.materialsMap[
                                              currentDropdownItemSelected] = [];
                                          await storageService.deleteFile(
                                              MaterialName,
                                              className,
                                              currentDropdownItemSelected,
                                              downloadLink,
                                              type);
                                          await getClassMaterials();
                                          await getClassMaterials();
                                          await getClassMaterials();
                                          await getClassMaterials();
                                          await getClassMaterials();
                                          setState(() {});
                                        } else if (i == 0) {
                                          Navigator.of(context).push(
                                              (MaterialPageRoute(
                                                  builder: (context) =>
                                                      MaterialsWebView(
                                                        Link: downloadLink,
                                                        type: type,
                                                        name: MaterialName,
                                                        className: className,
                                                      ))));
                                        }
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuItem>[
                                        PopupMenuItem(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.open_in_new_rounded,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              Text(
                                                'Open',
                                                style: TextStyle(
                                                  fontSize: 18.0 /
                                                      850.9090909090909 *
                                                      contextHeight,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontFamily: 'Abel',
                                                ),
                                              ),
                                            ],
                                          ),
                                          value: 0,
                                        ),
                                        PopupMenuItem(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              Text(
                                                'Delete',
                                                style: TextStyle(
                                                  fontSize: 18.0 /
                                                      850.9090909090909 *
                                                      contextHeight,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontFamily: 'Abel',
                                                ),
                                              ),
                                            ],
                                          ),
                                          value: 1,
                                        ),
                                      ],
                                      child: Icon(
                                        Icons.more_horiz,
                                        size: 40,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                  leading: Icon(
                                    type.toLowerCase() == ".jpg" ||
                                            type.toLowerCase() == ".png" ||
                                            type.toLowerCase() == ".bmp" ||
                                            type.toLowerCase() == ".gif" ||
                                            type.toLowerCase() == ".svg" ||
                                            type.toLowerCase() == ".tiff"
                                        ? Icons.image
                                        : (type == ".pdf"
                                            ? Icons.picture_as_pdf
                                            : type == ".docx" ||
                                                    type == ".ppt" ||
                                                    type == ".pptx" ||
                                                    type == ".xls" ||
                                                    type == ".xlsx" ||
                                                    type == ".doc" ||
                                                    type == ".txt"
                                                ? Icons.article
                                                : type == ".mp4" ||
                                                        type == ".avi" ||
                                                        type == ".h264" ||
                                                        type == ".mov"
                                                    ? Icons.play_circle_filled
                                                    : type == "Link"
                                                        ? Icons.link
                                                        : Icons.storage),
                                    color: Theme.of(context).primaryColor,
                                    size: 45,
                                  ),
                                  title: Text(
                                    MaterialName + type,
                                    style: TextStyle(
                                      fontFamily: 'Abel',
                                      fontSize: 18.0 /
                                          850.9090909090909 *
                                          contextHeight,
                                    ),
                                  ),
                                  subtitle: Text(
                                    className +
                                        "\n" +
                                        "Added ${DateFormat.yMMMd("en").format(dateAdded.toDate())}" +
                                        " at " +
                                        "${DateFormat.jm("en").format(dateAdded.toDate())}",
                                    style: TextStyle(
                                      fontFamily: 'Abel',
                                      fontSize: 14.0 /
                                          850.9090909090909 *
                                          contextHeight,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0 / 850.9090909090909 * contextHeight,
                          )
                        ],
                      );
                    },
                  ),
                );
              else {
                final contextHeight = MediaQuery.of(context).size.height;
                final appBarHeight = 1.0 / 11 * contextHeight;
                return Column(
                  children: [
                    SizedBox(
                      height: (contextHeight -
                                  appBarHeight -
                                  100 / 850.9090909090909 * contextHeight) /
                              2.0 -
                          1.0 / 100.0 * contextHeight,
                    ),
                    Center(
                      child: Text(
                        "No Materials here!",
                        style: TextStyle(
                          fontSize: 24.0 / 850.9090909090909 * contextHeight,
                          color: Theme.of(context).primaryColor,
                          fontFamily: 'Abel',
                        ),
                      ),
                    ),
                  ],
                );
              }
            }
            return Center(
              child: SizedBox(
                height: 10,
                child: LinearProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
