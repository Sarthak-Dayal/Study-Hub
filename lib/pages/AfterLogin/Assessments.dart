import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_hub/data/data.dart';
import 'package:study_hub/pages/AddScreens/AddAssessment.dart';
import 'package:study_hub/pages/AfterLogin/Drawer.dart';
import 'package:study_hub/pages/EditScreens/EditAssessment.dart';
import 'package:study_hub/services/auth.dart';
import '../BeforeLogin/login_page.dart' as loginPage;
import 'schedule.dart';
import 'package:intl/intl.dart';
import 'package:validators/validators.dart' as validator;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart' as charts;

var currentAssessmentDropdownItemSelected = "2020 - 2021";
String email = loginPage.email;

class AssessmentsPage extends StatefulWidget {
  @override
  _AssessmentsPageState createState() => _AssessmentsPageState();
}

class _AssessmentsPageState extends State<AssessmentsPage> {
  Future getAllAssessmentsThrice() async {
    await firestoreService
        .getAllAssessments(currentAssessmentDropdownItemSelected);
    await firestoreService
        .getAllAssessments(currentAssessmentDropdownItemSelected);
    await firestoreService
        .getAllAssessments(currentAssessmentDropdownItemSelected);
  }

  @override
  Widget build(BuildContext context) {
    //print(email);
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
      drawer: SideDrawer(page: "assessments"),
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
                      onChanged: (String val) async {
                        print("CHANGED!");
                        print(val);
                        currentAssessmentDropdownItemSelected = val;
                        setState(() {});
                      },
                      value: currentAssessmentDropdownItemSelected,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20 / 850.9090909090909 * contextHeight,
          ),
          BuildAssessmentsView(),
        ]);
      }),
      backgroundColor: Color(0xFFDEF3FF),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddAssessmentPage()));
        },
        child: Image.asset("images/Add.png"),
        backgroundColor: Color(0xFFDEF3FF),
      ),
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
                "ALL ASSESSMENTS",
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

class BuildAssessmentsView extends StatefulWidget {
  @override
  _BuildAssessmentsViewState createState() => _BuildAssessmentsViewState();
}

class _BuildAssessmentsViewState extends State<BuildAssessmentsView> {
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
  Widget build(BuildContext context) {
    final contextHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: SizedBox(
        height: 680 / 850.9090909090909 * contextHeight,
        width: 360 / 850.9090909090909 * contextHeight,
        child: FutureBuilder(
          future: getAllAssessmentsAndScores(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (firestoreService.assessmentsMap[currentAssessmentDropdownItemSelected].isNotEmpty)
                return RefreshIndicator(
                  onRefresh: () async {
                    print(currentDropdownItemSelected);
                    await firestoreService.getAllAssessments(
                        currentAssessmentDropdownItemSelected);
                    setState(() {});
                  },
                  child: CustomScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          if (index >=
                              firestoreService
                                  .assessmentsMap[
                                      currentAssessmentDropdownItemSelected]
                                  .length) return null;
                          final assessmentName = firestoreService
                                  .assessmentsMap[
                              currentAssessmentDropdownItemSelected][index][0];
                          final type = firestoreService.assessmentsMap[
                              currentAssessmentDropdownItemSelected][index][1];
                          final date = firestoreService.assessmentsMap[
                              currentAssessmentDropdownItemSelected][index][2];
                          final time = firestoreService.assessmentsMap[
                              currentAssessmentDropdownItemSelected][index][3];
                          final bool regRev = firestoreService.assessmentsMap[
                              currentAssessmentDropdownItemSelected][index][4];
                          final regRevInterval = firestoreService
                                  .assessmentsMap[
                              currentAssessmentDropdownItemSelected][index][5];
                          final regRevStartDate = firestoreService
                                  .assessmentsMap[
                              currentAssessmentDropdownItemSelected][index][6];
                          final className = firestoreService.assessmentsMap[
                              currentAssessmentDropdownItemSelected][index][9];
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
                                                                    currentAssessmentDropdownItemSelected] = [];
                                                                await firestoreService
                                                                    .getAllAssessments(
                                                                        currentAssessmentDropdownItemSelected)
                                                                    .then((_) {
                                                                  setState(
                                                                      () {});
                                                                }).catchError(
                                                                        (error) {
                                                                  print(error);
                                                                });
                                                                await firestoreService
                                                                    .getAllAssessments(
                                                                        currentAssessmentDropdownItemSelected)
                                                                    .then((_) {
                                                                  setState(
                                                                      () {});
                                                                }).catchError(
                                                                        (error) {
                                                                  print(error);
                                                                });
                                                                await firestoreService
                                                                    .getAllAssessments(
                                                                        currentAssessmentDropdownItemSelected)
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
                      SliverList(
                          delegate: SliverChildListDelegate([
                        SizedBox(height: 50,),
                        firestoreService
                                .scoresMap["Test"]
                                    [currentAssessmentDropdownItemSelected]
                                .isNotEmpty
                            ? Text(
                                "Previous Test Scores",
                                style: TextStyle(
                                  fontSize: 24.0 / 850.9090909090909 * contextHeight,
                                  color: Theme.of(context).primaryColor,
                                  fontFamily: 'Abel',
                                ),
                              )
                            : SizedBox(),
                            firestoreService
                                .scoresMap["Test"][currentAssessmentDropdownItemSelected].isNotEmpty
                                ?TestScoreChart(TestScoreChart._createSampleData()):SizedBox(),
                            SizedBox(height: firestoreService.scoresMap["Quiz"][currentAssessmentDropdownItemSelected].isNotEmpty ?50:0,),
                            firestoreService.scoresMap["Quiz"][currentAssessmentDropdownItemSelected].isNotEmpty
                                ? Text(
                              "Previous Quiz Scores",
                              style: TextStyle(
                                fontSize: 24.0 / 850.9090909090909 * contextHeight,
                                color: Theme.of(context).primaryColor,
                                fontFamily: 'Abel',
                              ),
                            )
                                : SizedBox(),
                            firestoreService
                                .scoresMap["Quiz"]
                            [currentAssessmentDropdownItemSelected]
                                .isNotEmpty
                                ?QuizScoreChart(QuizScoreChart._createSampleData()):SizedBox(),
                            SizedBox(height: firestoreService.scoresMap["Other"][currentAssessmentDropdownItemSelected].isNotEmpty ?50:0,),
                            firestoreService.scoresMap["Other"][currentAssessmentDropdownItemSelected].isNotEmpty
                                ? Text(
                              "Previous Other Assessment Scores",
                              style: TextStyle(
                                fontSize: 24.0 / 850.9090909090909 * contextHeight,
                                color: Theme.of(context).primaryColor,
                                fontFamily: 'Abel',
                              ),
                            )
                                : SizedBox(),
                            firestoreService
                                .scoresMap["Other"]
                            [currentAssessmentDropdownItemSelected]
                                .isNotEmpty
                                ?OtherScoreChart(OtherScoreChart._createSampleData()):SizedBox(),
                      ])),
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
    List<dynamic> data = firestoreService.scoresMap["Quiz"][currentAssessmentDropdownItemSelected];
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
    List<dynamic> data = firestoreService.scoresMap["Other"][currentAssessmentDropdownItemSelected];
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