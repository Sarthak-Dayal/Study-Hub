import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_hub/pages/AfterLogin/Drawer.dart';
import 'package:study_hub/services/auth.dart';
import '../BeforeLogin/login_page.dart' as loginPage;
import 'package:study_hub/pages/AfterLogin/Assessments.dart';
import 'package:study_hub/pages/AfterLogin/schedule.dart';
import 'package:study_hub/pages/AfterLogin/Tasks.dart';
import 'package:study_hub/pages/AfterLogin/ClassScreen.dart';
import 'package:study_hub/pages/AfterLogin/Materials.dart';
import 'package:study_hub/pages/AfterLogin/MaterialsWebView.dart';
import 'package:study_hub/pages/AddScreens/AddAssessment.dart';
import 'package:study_hub/pages/AddScreens/AddMaterial.dart';
import 'package:study_hub/pages/AddScreens/AddClass.dart';
import 'package:study_hub/pages/AddScreens/AddTask.dart';
import 'package:study_hub/services/firestore.dart';
import 'package:study_hub/services/storage.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:study_hub/data/data.dart';
import 'package:validators/validators.dart' as validator;
import 'package:study_hub/pages/EditScreens/EditAssessment.dart';
import 'package:study_hub/pages/EditScreens/EditTask.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:study_hub/pages/AfterLogin/FancyFAB.dart';
String email = loginPage.email;
var currentDashboardDropdownItemSelected = "2020 - 2021";

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    currentTasksDropdownItemSelected = currentDashboardDropdownItemSelected;
    currentAssessmentDropdownItemSelected =
        currentDashboardDropdownItemSelected;
    currentMaterialDropdownItemSelected = currentDashboardDropdownItemSelected;
    currentDropdownItemSelected = currentDashboardDropdownItemSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = new DateTime.now();
    List<String> yearOptions = [
      (now.year - 5).toString() + " - " + (now.year - 4).toString(),
      (now.year - 4).toString() + " - " + (now.year - 3).toString(),
      (now.year - 3).toString() + " - " + (now.year - 2).toString(),
      (now.year - 2).toString() + " - " + (now.year - 1).toString(),
      (now.year - 1).toString() + " - " + now.year.toString(),
      now.year.toString() + " - " + (now.year + 1).toString(),
      (now.year + 1).toString() + " - " + (now.year + 2).toString(),
      (now.year + 2).toString() + " - " + (now.year + 3).toString(),
      (now.year + 3).toString() + " - " + (now.year + 4).toString(),
      (now.year + 4).toString() + " - " + (now.year + 5).toString(),
      (now.year + 5).toString() + " - " + (now.year + 6).toString(),
    ];
    final contextHeight = MediaQuery.of(context).size.height;
    var preTextWidth = MediaQuery.of(context).size.width *
        (1.0 / 19.0) /
        850.9090909090909 *
        contextHeight;
    AuthService _auth = AuthService();
    final appBarHeight = 1.0 / 11 * contextHeight;
    BuildContext context2;
    return Scaffold(
      drawer: SideDrawer(page: "dashboard"),
      body: Builder(builder: (context) {
        context2 = context;
        return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          SizedBox(
            height: 1.0 / 100.0 * contextHeight,
          ),
          Row(
            children: [
              SizedBox(
                width: preTextWidth,
              ),
              Text(
                "Year: ",
                style: TextStyle(
                  fontSize: (18.0) / 850.9090909090909 * contextHeight,
                  color: Theme.of(context).primaryColor,
                  fontFamily: 'Abel',
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(
                    5 / 850.9090909090909 * contextHeight),
                child: SizedBox(
                  height: 30 / 850.9090909090909 * contextHeight,
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    child: DropdownButton<String>(
                      dropdownColor: Theme.of(context).primaryColor,
                      iconEnabledColor: Colors.white,
                      iconDisabledColor: Colors.white,
                      items: yearOptions.map((String yearOption) {
                        return DropdownMenuItem(
                          value: yearOption,
                          child: Text(
                            "  " + yearOption,
                            style: TextStyle(
                              fontSize:
                                  18.0 / 850.9090909090909 * contextHeight,
                              color: Colors.white,
                              fontFamily: 'Abel',
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String val) {
                        setState(() {
                          currentDashboardDropdownItemSelected = val;
                        });
                      },
                      value: currentDashboardDropdownItemSelected,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 20),
          BuildDashBoardView(),
        ]);
      }),
      backgroundColor: Color(0xFFDEF3FF),
      floatingActionButton: FancyFab(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(10 / 850.9090909090909 * contextHeight),
          child: AppBar(
            automaticallyImplyLeading: false,
            leading: Column(children: [
              SizedBox(
                height: 16 / 850.9090909090909 * contextHeight,
              ),
              GestureDetector(
                onTap: () {
                  Scaffold.of(context2).openDrawer();
                },
                child: Image.asset(
                  "images/MenuIcon.png",
                  scale: 1.25 * 850.9090909090909 / contextHeight,
                ),
              ),
            ]),
            centerTitle: true,
            title: Column(children: [
              SizedBox(
                height: (16) / 850.9090909090909 * contextHeight,
              ),
              Text(
                "DASHBOARD",
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
    );
  }
}

class BuildDashBoardView extends StatefulWidget {
  @override
  _BuildDashBoardViewState createState() => _BuildDashBoardViewState();
}

class _BuildDashBoardViewState extends State<BuildDashBoardView> {
  futureFunction() async {
    currentTasksDropdownItemSelected = currentDashboardDropdownItemSelected;
    currentAssessmentDropdownItemSelected =
        currentDashboardDropdownItemSelected;
    currentMaterialDropdownItemSelected = currentDashboardDropdownItemSelected;
    currentDropdownItemSelected = currentDashboardDropdownItemSelected;

    await firestoreService.getClasses(currentDashboardDropdownItemSelected);
    await firestoreService.getClasses(currentDashboardDropdownItemSelected);
    await firestoreService.getClasses(currentDashboardDropdownItemSelected);

    await firestoreService
        .getAllAssessments(currentDashboardDropdownItemSelected);
    await firestoreService
        .getAllAssessments(currentDashboardDropdownItemSelected);
    await firestoreService
        .getAllAssessments(currentDashboardDropdownItemSelected);

    await firestoreService.getAllTasks();
    await firestoreService.getAllTasks();
    await firestoreService.getAllTasks();

    await firestoreService.getAllMaterials();
    await firestoreService.getAllMaterials();
    await firestoreService.getAllMaterials();

    await firestoreService.getScores("Test");
    await firestoreService.getScores("Test");
    await firestoreService.getScores("Test");

    await firestoreService.getScores("Quiz");
    await firestoreService.getScores("Quiz");
    await firestoreService.getScores("Quiz");

    await firestoreService.getScores("Other");
    await firestoreService.getScores("Other");
    await firestoreService.getScores("Other");
  }

  ScoreData quizScoreData = ScoreData();
  ScoreData testScoreData = ScoreData();
  ScoreData otherScoreData = ScoreData();
  int scoreInput;
  Future getAllAssessmentsAndScores() async {
    await firestoreService
        .getAllAssessments(currentAssessmentDropdownItemSelected);
    await firestoreService
        .getAllAssessments(currentAssessmentDropdownItemSelected);
    await firestoreService
        .getAllAssessments(currentAssessmentDropdownItemSelected);

    await firestoreService.getScores("Quiz");
    await firestoreService.getScores("Quiz");
    await firestoreService.getScores("Quiz");
    await firestoreService.getScores("Test");
    await firestoreService.getScores("Test");
    await firestoreService.getScores("Test");
    await firestoreService.getScores("Other");
    await firestoreService.getScores("Other");
    await firestoreService.getScores("Other");
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
        height: 680 / 850.9090909090909 * contextHeight,
        width: 360 / 850.9090909090909 * contextHeight,
        child: FutureBuilder(
          future: futureFunction(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (firestoreService
                  .assessmentsMap[currentAssessmentDropdownItemSelected]
                  .isNotEmpty||firestoreService.tasksMap[currentAssessmentDropdownItemSelected].isNotEmpty||firestoreService.returnList.isNotEmpty||firestoreService.materialsMap[currentAssessmentDropdownItemSelected].isNotEmpty)
                return RefreshIndicator(
                  onRefresh: () async {
                    print(currentDropdownItemSelected);
                    await futureFunction();
                    setState(() {});
                  },
                  child: CustomScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          ///no.of items in the horizontal axis
                          crossAxisCount: 2,
                        ),

                        ///Lazy building of list
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            int numItems;
                            String title;
                            if(index==0){
                              numItems = firestoreService.returnList.length;
                              title = "Classes";
                            }
                            if(index==1){
                              numItems = firestoreService.tasksMap[currentDashboardDropdownItemSelected].length;
                              title = "Tasks";
                            }
                            if(index==2){
                              numItems = firestoreService.assessmentsMap[currentDashboardDropdownItemSelected].length;
                              title = "Assessments";
                            }
                            if(index==3){
                              numItems = firestoreService.materialsMap[currentDashboardDropdownItemSelected].length;
                              title = "Materials";
                            }
                            /// To convert this infinite list to a list with "n" no of items,
                            /// uncomment the following line:
                            /// if (index > n) return null;
                            return listItem(Theme.of(context).primaryColor,
                                "$numItems", title);
                          },

                          /// Set childCount to limit no.of items
                          childCount: 4,
                        ),
                      ),
                      firestoreService.returnList.isNotEmpty
                          ? SliverToBoxAdapter(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Classes",
                                    style: TextStyle(
                                      fontSize: 24.0 /
                                          850.9090909090909 *
                                          contextHeight,
                                      color: Theme.of(context).primaryColor,
                                      fontFamily: 'Abel',
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              ),
                            )
                          : SizedBox(),
                      firestoreService.returnList.isNotEmpty
                          ? SliverList(
                              delegate:
                                  SliverChildBuilderDelegate((context, index) {
                                if (index >= firestoreService.returnList.length)
                                  return null;
                                String DaysString = "";
                                List days = [
                                  "Su",
                                  "M",
                                  "Tu",
                                  "W",
                                  "Th",
                                  "F",
                                  "S"
                                ];
                                for (var i = 0;
                                    i <
                                        firestoreService
                                            .returnList[index].length;
                                    i++) {
                                  if (firestoreService.returnList[index][1][i])
                                    DaysString += days[i];
                                }
                                String startTime =
                                    "${DateFormat.jm("en").format(firestoreService.returnList[index][4].toDate())}";
                                String endTime =
                                    "${DateFormat.jm("en").format(firestoreService.returnList[index][5].toDate())}";
                                final Link = firestoreService.returnList[index]
                                        [6]
                                    .toString();
                                return Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        color: Color(0XFFEFEEEE),
                                        child: SizedBox(
                                          height: 75 /
                                              850.9090909090909 *
                                              contextHeight,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: ListTile(
                                            trailing: Text(
                                              DaysString,
                                              style: TextStyle(
                                                fontFamily: 'Abel',
                                                fontSize: 12.0 /
                                                    850.9090909090909 *
                                                    contextHeight,
                                              ),
                                            ),
                                            leading: Column(
                                              children: [
                                                Text(
                                                  startTime,
                                                  style: TextStyle(
                                                    fontFamily: 'Abel',
                                                    fontSize: 12.0 /
                                                        850.9090909090909 *
                                                        contextHeight,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20 /
                                                      850.9090909090909 *
                                                      contextHeight,
                                                ),
                                                Text(
                                                  endTime,
                                                  style: TextStyle(
                                                    fontFamily: 'Abel',
                                                    fontSize: 12.0 /
                                                        850.9090909090909 *
                                                        contextHeight,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            title: Text(
                                              "${firestoreService.returnList[index][0]}",
                                              style: TextStyle(
                                                fontFamily: 'Abel',
                                                fontSize: 18.0 /
                                                    850.9090909090909 *
                                                    contextHeight,
                                              ),
                                            ),
                                            subtitle: InkWell(
                                              onTap: () async {
                                                if (await canLaunch(Link))
                                                  await launch(Link);
                                                else {
                                                  if (await canLaunch(
                                                      "https://" + Link))
                                                    await launch(
                                                        "https://" + Link);
                                                  else if (await canLaunch(
                                                      "http://" + Link))
                                                    await launch(
                                                        "http://" + Link);
                                                  else
                                                    throw "Could not launch ${Link}";
                                                }
                                              },
                                              child: Text(
                                                Link,
                                                style: TextStyle(
                                                  fontFamily: 'Abel',
                                                  fontSize: 12.0 /
                                                      850.9090909090909 *
                                                      contextHeight,
                                                  color: Colors.blue,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0 /
                                          850.9090909090909 *
                                          contextHeight,
                                    )
                                  ],
                                );
                              }),
                            )
                          : SizedBox(),
                      firestoreService
                              .tasksMap[currentDashboardDropdownItemSelected]
                              .isNotEmpty
                          ? SliverToBoxAdapter(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Tasks",
                                    style: TextStyle(
                                      fontSize: 24.0 /
                                          850.9090909090909 *
                                          contextHeight,
                                      color: Theme.of(context).primaryColor,
                                      fontFamily: 'Abel',
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              ),
                            )
                          : SizedBox(),
                      firestoreService
                              .tasksMap[currentDashboardDropdownItemSelected]
                              .isNotEmpty
                          ? SliverList(
                              delegate:
                                  SliverChildBuilderDelegate((context, index) {
                                if (index >=
                                    firestoreService
                                        .tasksMap[
                                            currentDashboardDropdownItemSelected]
                                        .length) return null;
                                final tasksName = firestoreService.tasksMap[
                                    currentTasksDropdownItemSelected][index][0];
                                final dueDate = firestoreService.tasksMap[
                                    currentTasksDropdownItemSelected][index][1];
                                final type = firestoreService.tasksMap[
                                    currentTasksDropdownItemSelected][index][4];
                                final className = firestoreService.tasksMap[
                                    currentTasksDropdownItemSelected][index][5];
                                return Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        color: Color(0XFFEFEEEE),
                                        child: SizedBox(
                                          height: 90 /
                                              850.9090909090909 *
                                              contextHeight,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: ListTile(
                                            isThreeLine: true,
                                            trailing: Theme(
                                              data: Theme.of(context).copyWith(
                                                cardColor: Color(0XFFEFEEEE),
                                              ),
                                              child: PopupMenuButton(
                                                onSelected: (i) async {
                                                  if (i == 2) {
                                                    await firestoreService
                                                        .deleteTask(
                                                            tasksName,
                                                            dueDate,
                                                            type,
                                                            className);
                                                    firestoreService.tasksMap[
                                                        currentTasksDropdownItemSelected] = [];
                                                    await firestoreService
                                                        .getAllTasks()
                                                        .then((_) {
                                                      setState(() {});
                                                    });
                                                    await firestoreService
                                                        .getAllTasks()
                                                        .then((_) {
                                                      setState(() {});
                                                    });
                                                    await firestoreService
                                                        .getAllTasks()
                                                        .then((_) {
                                                      setState(() {});
                                                    });
                                                  }
                                                  if (i == 1) {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                EditTaskPage(
                                                                  taskName:
                                                                      tasksName,
                                                                  className:
                                                                      className,
                                                                  dueDate: dueDate
                                                                      .toDate(),
                                                                  type: type,
                                                                  ogDueDate: dueDate
                                                                      .toDate(),
                                                                  ogTaskName:
                                                                      tasksName,
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
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                fontFamily:
                                                                    'Abel',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            content: Text(
                                                              "Are you sure you want to mark this task and done and discard it?",
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
                                                            actions: [
                                                              FlatButton(
                                                                onPressed:
                                                                    () async {
                                                                  await firestoreService.deleteTask(
                                                                      tasksName,
                                                                      dueDate,
                                                                      type,
                                                                      className);
                                                                  firestoreService
                                                                          .tasksMap[
                                                                      currentTasksDropdownItemSelected] = [];
                                                                  await firestoreService
                                                                      .getAllTasks()
                                                                      .then(
                                                                          (_) {
                                                                    setState(
                                                                        () {});
                                                                  });
                                                                  await firestoreService
                                                                      .getAllTasks()
                                                                      .then(
                                                                          (_) {
                                                                    setState(
                                                                        () {});
                                                                  });
                                                                  await firestoreService
                                                                      .getAllTasks()
                                                                      .then(
                                                                          (_) {
                                                                    setState(
                                                                        () {});
                                                                  });
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                  "Confirm",
                                                                  style:
                                                                      TextStyle(
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
                                                  }
                                                },
                                                itemBuilder:
                                                    (BuildContext context) =>
                                                        <PopupMenuItem>[
                                                  PopupMenuItem(
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.check_circle,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ),
                                                        Text(
                                                          'Done',
                                                          style: TextStyle(
                                                            fontSize: 18.0 /
                                                                850.9090909090909 *
                                                                contextHeight,
                                                            color: Theme.of(
                                                                    context)
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
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ),
                                                        Text(
                                                          'Edit',
                                                          style: TextStyle(
                                                            fontSize: 18.0 /
                                                                850.9090909090909 *
                                                                contextHeight,
                                                            color: Theme.of(
                                                                    context)
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
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ),
                                                        Text(
                                                          'Delete',
                                                          style: TextStyle(
                                                            fontSize: 18.0 /
                                                                850.9090909090909 *
                                                                contextHeight,
                                                            color: Theme.of(
                                                                    context)
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
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                            ),
                                            leading: Icon(
                                              type == "Revision"
                                                  ? Icons.book
                                                  : (type == "Assignment"
                                                      ? Icons.assignment
                                                      : Icons.view_agenda),
                                              color: Theme.of(context)
                                                  .primaryColor,
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
                                      height: 10.0 /
                                          850.9090909090909 *
                                          contextHeight,
                                    )
                                  ],
                                );
                              }),
                            )
                          : SizedBox(),
                      firestoreService
                              .assessmentsMap[
                                  currentDashboardDropdownItemSelected]
                              .isNotEmpty
                          ? SliverToBoxAdapter(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Assessments",
                                    style: TextStyle(
                                      fontSize: 24.0 /
                                          850.9090909090909 *
                                          contextHeight,
                                      color: Theme.of(context).primaryColor,
                                      fontFamily: 'Abel',
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              ),
                            )
                          : SizedBox(),
                      firestoreService
                              .assessmentsMap[
                                  currentDashboardDropdownItemSelected]
                              .isNotEmpty
                          ? SliverList(
                              delegate:
                                  SliverChildBuilderDelegate((context, index) {
                                if (index >=
                                    firestoreService
                                        .assessmentsMap[
                                            currentAssessmentDropdownItemSelected]
                                        .length) return null;
                                final assessmentName = firestoreService
                                            .assessmentsMap[
                                        currentAssessmentDropdownItemSelected]
                                    [index][0];
                                final type = firestoreService.assessmentsMap[
                                        currentAssessmentDropdownItemSelected]
                                    [index][1];
                                final date = firestoreService.assessmentsMap[
                                        currentAssessmentDropdownItemSelected]
                                    [index][2];
                                final time = firestoreService.assessmentsMap[
                                        currentAssessmentDropdownItemSelected]
                                    [index][3];
                                final bool regRev = firestoreService
                                            .assessmentsMap[
                                        currentAssessmentDropdownItemSelected]
                                    [index][4];
                                final regRevInterval = firestoreService
                                            .assessmentsMap[
                                        currentAssessmentDropdownItemSelected]
                                    [index][5];
                                final regRevStartDate = firestoreService
                                            .assessmentsMap[
                                        currentAssessmentDropdownItemSelected]
                                    [index][6];
                                final className = firestoreService
                                            .assessmentsMap[
                                        currentAssessmentDropdownItemSelected]
                                    [index][9];
                                return Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        color: Color(0XFFEFEEEE),
                                        child: SizedBox(
                                          height: 75 /
                                              850.9090909090909 *
                                              contextHeight,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: ListTile(
                                            isThreeLine: true,
                                            trailing: Theme(
                                              data: Theme.of(context).copyWith(
                                                cardColor: Color(0XFFEFEEEE),
                                              ),
                                              child: PopupMenuButton(
                                                onSelected: (i) async {
                                                  print("Selected " +
                                                      i.toString());
                                                  if (i == 2) {
                                                    await firestoreService
                                                        .deleteAssessment(
                                                            assessmentName,
                                                            className,
                                                            type,
                                                            time,
                                                            date);
                                                    firestoreService
                                                            .assessmentsMap[
                                                        currentAssessmentDropdownItemSelected] = [];
                                                    await firestoreService
                                                        .getAllAssessments(
                                                            currentAssessmentDropdownItemSelected)
                                                        .then((_) {
                                                      setState(() {});
                                                    });
                                                    await firestoreService
                                                        .getAllAssessments(
                                                            currentAssessmentDropdownItemSelected)
                                                        .then((_) {
                                                      setState(() {});
                                                    });
                                                    await firestoreService
                                                        .getAllAssessments(
                                                            currentAssessmentDropdownItemSelected)
                                                        .then((_) {
                                                      setState(() {});
                                                    });
                                                  } else if (i == 1) {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          final _FormKey =
                                                              GlobalKey<
                                                                  FormState>();
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
                                                                  fontFamily:
                                                                      'Abel',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            content: Form(
                                                              key: _FormKey,
                                                              child:
                                                                  TextFormField(
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
                                                                          .isInt(
                                                                              v) ||
                                                                      !(0 <=
                                                                          int.parse(
                                                                              v)) ||
                                                                      !(150 >=
                                                                          int.parse(
                                                                              v))) {
                                                                    return "Enter a percentage between 0 and 150";
                                                                  } else {
                                                                    scoreInput =
                                                                        int.parse(
                                                                            v);
                                                                  }
                                                                  return null;
                                                                },
                                                              ),
                                                            ),
                                                            actions: [
                                                              FlatButton(
                                                                onPressed:
                                                                    () async {
                                                                  if (_FormKey
                                                                      .currentState
                                                                      .validate()) {
                                                                    await firestoreService
                                                                        .addScore(
                                                                            scoreInput,
                                                                            type)
                                                                        .then(
                                                                            (_) async {
                                                                      await firestoreService.deleteAssessment(
                                                                          assessmentName,
                                                                          className,
                                                                          type,
                                                                          time,
                                                                          date);
                                                                      firestoreService
                                                                              .assessmentsMap[
                                                                          currentAssessmentDropdownItemSelected] = [];
                                                                      await firestoreService
                                                                          .getAllAssessments(
                                                                              currentAssessmentDropdownItemSelected)
                                                                          .then(
                                                                              (_) {
                                                                        setState(
                                                                            () {});
                                                                      }).catchError(
                                                                              (error) {
                                                                        print(
                                                                            error);
                                                                      });
                                                                      await firestoreService
                                                                          .getAllAssessments(
                                                                              currentAssessmentDropdownItemSelected)
                                                                          .then(
                                                                              (_) {
                                                                        setState(
                                                                            () {});
                                                                      }).catchError(
                                                                              (error) {
                                                                        print(
                                                                            error);
                                                                      });
                                                                      await firestoreService
                                                                          .getAllAssessments(
                                                                              currentAssessmentDropdownItemSelected)
                                                                          .then(
                                                                              (_) {
                                                                        setState(
                                                                            () {});
                                                                      }).catchError(
                                                                              (error) {
                                                                        print(
                                                                            error);
                                                                      });
                                                                    }).catchError(
                                                                            (error) {
                                                                      print(
                                                                          error);
                                                                    });
                                                                    Navigator.pop(
                                                                        context);
                                                                  }
                                                                },
                                                                child: Text(
                                                                  "Add Score",
                                                                  style:
                                                                      TextStyle(
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
                                                                  date: date
                                                                      .toDate(),
                                                                  time: TimeOfDay
                                                                      .fromDateTime(
                                                                          time.toDate()),
                                                                  type: type,
                                                                  name:
                                                                      assessmentName,
                                                                  regRev:
                                                                      regRev,
                                                                  regRevInterval:
                                                                      regRevInterval,
                                                                  revisionDate:
                                                                      regRevStartDate
                                                                          .toDate(),
                                                                  ogDate: date
                                                                      .toDate(),
                                                                  ogName:
                                                                      assessmentName,
                                                                  ogRegRev:
                                                                      regRev,
                                                                  ogRegRevInterval:
                                                                      regRevInterval,
                                                                  ogRevisionDate:
                                                                      regRevStartDate
                                                                          .toDate(),
                                                                  ogTime: TimeOfDay
                                                                      .fromDateTime(
                                                                          time.toDate()),
                                                                  ogType: type,
                                                                )));
                                                  }
                                                },
                                                itemBuilder:
                                                    (BuildContext context) =>
                                                        <PopupMenuItem>[
                                                  PopupMenuItem(
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.edit,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ),
                                                        Text(
                                                          'Edit',
                                                          style: TextStyle(
                                                            fontSize: 18.0 /
                                                                850.9090909090909 *
                                                                contextHeight,
                                                            color: Theme.of(
                                                                    context)
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
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ),
                                                        Text(
                                                          'Add Score',
                                                          style: TextStyle(
                                                            fontSize: 18.0 /
                                                                850.9090909090909 *
                                                                contextHeight,
                                                            color: Theme.of(
                                                                    context)
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
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ),
                                                        Text(
                                                          'Delete',
                                                          style: TextStyle(
                                                            fontSize: 18.0 /
                                                                850.9090909090909 *
                                                                contextHeight,
                                                            color: Theme.of(
                                                                    context)
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
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                            ),
                                            leading: Icon(
                                              type == "Quiz"
                                                  ? Icons.ballot
                                                  : (type == "Test"
                                                      ? Icons.assessment
                                                      : Icons.assignment),
                                              color: Theme.of(context)
                                                  .primaryColor,
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
                                      height: 10.0 /
                                          850.9090909090909 *
                                          contextHeight,
                                    ),
                                  ],
                                );
                              }),
                            )
                          : SizedBox(),
                      firestoreService
                              .assessmentsMap[
                                  currentDashboardDropdownItemSelected]
                              .isNotEmpty
                          ? SliverList(
                              delegate: SliverChildListDelegate([
                              SizedBox(
                                height: 50,
                              ),
                              firestoreService
                                      .scoresMap["Test"][
                                          currentAssessmentDropdownItemSelected]
                                      .isNotEmpty
                                  ? Text(
                                      "Previous Test Scores",
                                      style: TextStyle(
                                        fontSize: 24.0 /
                                            850.9090909090909 *
                                            contextHeight,
                                        color: Theme.of(context).primaryColor,
                                        fontFamily: 'Abel',
                                      ),
                                    )
                                  : SizedBox(),
                              firestoreService
                                      .scoresMap["Test"][
                                          currentAssessmentDropdownItemSelected]
                                      .isNotEmpty
                                  ? TestScoreChart(
                                      TestScoreChart._createSampleData())
                                  : SizedBox(),
                              SizedBox(
                                height: firestoreService
                                        .scoresMap["Quiz"][
                                            currentAssessmentDropdownItemSelected]
                                        .isNotEmpty
                                    ? 50
                                    : 0,
                              ),
                              firestoreService
                                      .scoresMap["Quiz"][
                                          currentAssessmentDropdownItemSelected]
                                      .isNotEmpty
                                  ? Text(
                                      "Previous Quiz Scores",
                                      style: TextStyle(
                                        fontSize: 24.0 /
                                            850.9090909090909 *
                                            contextHeight,
                                        color: Theme.of(context).primaryColor,
                                        fontFamily: 'Abel',
                                      ),
                                    )
                                  : SizedBox(),
                              firestoreService
                                      .scoresMap["Quiz"][
                                          currentAssessmentDropdownItemSelected]
                                      .isNotEmpty
                                  ? QuizScoreChart(
                                      QuizScoreChart._createSampleData())
                                  : SizedBox(),
                              SizedBox(
                                height: firestoreService
                                        .scoresMap["Other"][
                                            currentAssessmentDropdownItemSelected]
                                        .isNotEmpty
                                    ? 50
                                    : 0,
                              ),
                              firestoreService
                                      .scoresMap["Other"][
                                          currentAssessmentDropdownItemSelected]
                                      .isNotEmpty
                                  ? Text(
                                      "Previous Other Assessment Scores",
                                      style: TextStyle(
                                        fontSize: 24.0 /
                                            850.9090909090909 *
                                            contextHeight,
                                        color: Theme.of(context).primaryColor,
                                        fontFamily: 'Abel',
                                      ),
                                    )
                                  : SizedBox(),
                              firestoreService
                                      .scoresMap["Other"][
                                          currentAssessmentDropdownItemSelected]
                                      .isNotEmpty
                                  ? OtherScoreChart(
                                      OtherScoreChart._createSampleData())
                                  : SizedBox(),
                            ]))
                          : SizedBox(),
                      firestoreService
                              .materialsMap[
                                  currentDashboardDropdownItemSelected]
                              .isNotEmpty
                          ? SliverToBoxAdapter(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Materials",
                                    style: TextStyle(
                                      fontSize: 24.0 /
                                          850.9090909090909 *
                                          contextHeight,
                                      color: Theme.of(context).primaryColor,
                                      fontFamily: 'Abel',
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              ),
                            )
                          : SizedBox(),
                      firestoreService
                              .materialsMap[
                                  currentDashboardDropdownItemSelected]
                              .isNotEmpty
                          ? SliverList(delegate:
                              SliverChildBuilderDelegate((context, index) {
                              if (index >=
                                  firestoreService
                                      .materialsMap[
                                          currentDashboardDropdownItemSelected]
                                      .length) return null;
                              final MaterialName =
                                  firestoreService.materialsMap[
                                          currentMaterialDropdownItemSelected]
                                      [index][0];
                              final dateAdded = firestoreService.materialsMap[
                                      currentMaterialDropdownItemSelected]
                                  [index][1];
                              final downloadLink =
                                  firestoreService.materialsMap[
                                          currentMaterialDropdownItemSelected]
                                      [index][2];
                              final type = firestoreService.materialsMap[
                                      currentMaterialDropdownItemSelected]
                                  [index][3];
                              final className = firestoreService.materialsMap[
                                      currentMaterialDropdownItemSelected]
                                  [index][4];
                              return Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      color: Color(0XFFEFEEEE),
                                      child: SizedBox(
                                        height: 75 /
                                            850.9090909090909 *
                                            contextHeight,
                                        width:
                                            MediaQuery.of(context).size.width,
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
                                                      currentMaterialDropdownItemSelected] = [];
                                                  await storageService.deleteFile(
                                                      MaterialName,
                                                      className,
                                                      currentMaterialDropdownItemSelected,
                                                      downloadLink, type);
                                                  await firestoreService
                                                      .getAllMaterials();
                                                  await firestoreService
                                                      .getAllMaterials();
                                                  await firestoreService
                                                      .getAllMaterials();
                                                  setState(() {});
                                                } else if (i == 0) {
                                                  Navigator.of(context).push(
                                                      (MaterialPageRoute(
                                                          builder: (context) =>
                                                              MaterialsWebView(
                                                                Link:
                                                                    downloadLink,
                                                                type: type,
                                                                name:
                                                                    MaterialName,
                                                                className:
                                                                    className,
                                                              ))));
                                                }
                                              },
                                              itemBuilder:
                                                  (BuildContext context) =>
                                                      <PopupMenuItem>[
                                                PopupMenuItem(
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .open_in_new_rounded,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                      Text(
                                                        'Open',
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
                                                          color:
                                                              Theme.of(context)
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
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                          leading: Icon(
                                            type.toLowerCase() == ".jpg" ||
                                                    type.toLowerCase() ==
                                                        ".png" ||
                                                    type.toLowerCase() ==
                                                        ".bmp" ||
                                                    type.toLowerCase() ==
                                                        ".gif" ||
                                                    type.toLowerCase() ==
                                                        ".svg" ||
                                                    type.toLowerCase() ==
                                                        ".tiff"
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
                                                                type ==
                                                                    ".avi" ||
                                                                type ==
                                                                    ".h264" ||
                                                                type == ".mov"
                                                            ? Icons
                                                                .play_circle_filled
                                                            : Icons.storage),
                                            color:
                                                Theme.of(context).primaryColor,
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
                                    height: 10.0 /
                                        850.9090909090909 *
                                        contextHeight,
                                  )
                                ],
                              );
                            }))
                          : SizedBox(),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 40,
                        ),
                      ),
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
                        "Nothing here!",
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

class QuizScoreChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  QuizScoreChart(
    this.seriesList,
  );

  factory QuizScoreChart.withSampleData() {
    return new QuizScoreChart(
      _createSampleData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: new charts.BarChart(
        seriesList,
        animate: true,
        defaultRenderer: new charts.BarRendererConfig(
            cornerStrategy: const charts.ConstCornerStrategy(30)),
      ),
    );
  }

  static _createSampleData() {
    List<dynamic> data = firestoreService.scoresMap["Quiz"]
        [currentAssessmentDropdownItemSelected];
    return [
      new charts.Series<dynamic, String>(
        id: 'Quiz Scores',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (dynamic list, _) =>
            DateFormat.yMMMd("en").format(list[1].toDate()),
        measureFn: (dynamic list, _) => list[0],
        data: data,
      )
    ];
  }
}

class TestScoreChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  TestScoreChart(
    this.seriesList,
  );

  factory TestScoreChart.withSampleData() {
    return new TestScoreChart(
      _createSampleData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: new charts.BarChart(
        seriesList,
        animate: true,
        defaultRenderer: new charts.BarRendererConfig(
            cornerStrategy: const charts.ConstCornerStrategy(30)),
      ),
    );
  }

  static _createSampleData() {
    List<dynamic> data = firestoreService.scoresMap["Test"]
        [currentAssessmentDropdownItemSelected];
    return [
      new charts.Series<dynamic, String>(
        id: 'Test Scores',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (dynamic list, _) =>
            DateFormat.yMMMd("en").format(list[1].toDate()),
        measureFn: (dynamic list, _) => list[0],
        data: data,
      )
    ];
  }
}

class OtherScoreChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  OtherScoreChart(
    this.seriesList,
  );

  factory OtherScoreChart.withSampleData() {
    return new OtherScoreChart(
      _createSampleData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: new charts.BarChart(
        seriesList,
        animate: true,
        defaultRenderer: new charts.BarRendererConfig(
            cornerStrategy: const charts.ConstCornerStrategy(30)),
      ),
    );
  }

  static _createSampleData() {
    List<dynamic> data = firestoreService.scoresMap["Other"]
        [currentAssessmentDropdownItemSelected];
    return [
      new charts.Series<dynamic, String>(
        id: 'Other Scores',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (dynamic list, _) =>
            DateFormat.yMMMd("en").format(list[1].toDate()),
        measureFn: (dynamic list, _) => list[0],
        data: data,
      )
    ];
  }
}

Widget listItem(Color color, String title, String subTitle) => Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      color: color,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$title",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white, fontSize: 60.0, fontFamily: 'Abel'),
            ),
            Text(
              "$subTitle",
              style: TextStyle(
                  color: Colors.white, fontSize: 24.0, fontFamily: 'Abel'),
            ),
          ],
        ),
      ),
    );
