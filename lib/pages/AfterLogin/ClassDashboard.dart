import 'package:flutter/material.dart';
import 'package:study_hub/pages/AfterLogin/Assessments.dart';
import 'package:study_hub/pages/AfterLogin/Dashboard.dart';
import 'package:study_hub/pages/AfterLogin/Tasks.dart';
import 'package:study_hub/pages/AfterLogin/schedule.dart';
import 'package:intl/intl.dart';
import 'package:study_hub/pages/EditScreens/EditTask.dart';
import 'package:validators/validators.dart' as validator;
import 'package:study_hub/pages/EditScreens/EditAssessment.dart';
import 'package:study_hub/pages/AddScreens/AddMaterial.dart';
import 'package:study_hub/pages/AfterLogin/MaterialsWebView.dart';
import 'package:study_hub/pages/AfterLogin/Materials.dart';
class BuildClassDashBoardView extends StatefulWidget {
  final String className;
  BuildClassDashBoardView({this.className});
  @override
  _BuildClassDashBoardViewState createState() => _BuildClassDashBoardViewState(className: className);
}

class _BuildClassDashBoardViewState extends State<BuildClassDashBoardView> {
  @override
  void initState() {
    currentTasksDropdownItemSelected = currentDropdownItemSelected;
    currentAssessmentDropdownItemSelected = currentDropdownItemSelected;
    currentDashboardDropdownItemSelected = currentDropdownItemSelected;
    currentMaterialDropdownItemSelected = currentDropdownItemSelected;
    firestoreService.assessmentsMap[currentDropdownItemSelected] = [];
    firestoreService.tasksMap[currentDropdownItemSelected] = [];
    firestoreService.materialsMap[currentDropdownItemSelected] = [];
    super.initState();
  }
  final String className;
  _BuildClassDashBoardViewState({this.className});
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

  int scoreInput;
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
                  .assessmentsMap[currentDropdownItemSelected]
                  .isNotEmpty||firestoreService.tasksMap[currentDropdownItemSelected].isNotEmpty||firestoreService.materialsMap[currentDropdownItemSelected].isNotEmpty)
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
                              numItems = firestoreService.tasksMap[currentDropdownItemSelected].length;
                              title = "Tasks";
                            }
                            if(index==1){
                              numItems = firestoreService.assessmentsMap[currentDropdownItemSelected].length;
                              title = "Assessments";
                            }
                            if(index==2){
                              numItems = firestoreService.materialsMap[currentDropdownItemSelected].length;
                              title = "Materials";
                            }
                            /// To convert this infinite list to a list with "n" no of items,
                            /// uncomment the following line:
                            /// if (index > n) return null;
                            return listItem(Theme.of(context).primaryColor,
                                "$numItems", title);
                          },

                          /// Set childCount to limit no.of items
                          childCount: 3,
                        ),
                      ),
                      firestoreService
                          .tasksMap[currentDropdownItemSelected]
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
                          : SliverToBoxAdapter(child: SizedBox()),
                      firestoreService
                          .tasksMap[currentDropdownItemSelected]
                          .isNotEmpty
                          ? SliverList(
                        delegate:
                        SliverChildBuilderDelegate((context, index) {
                          if (index >=
                              firestoreService
                                  .tasksMap[
                              currentDropdownItemSelected]
                                  .length) return null;
                          final tasksName = firestoreService.tasksMap[
                          currentDropdownItemSelected][index][0];
                          final dueDate = firestoreService.tasksMap[
                          currentDropdownItemSelected][index][1];
                          final type = firestoreService.tasksMap[
                          currentDropdownItemSelected][index][4];
                          final className = firestoreService.tasksMap[
                          currentDropdownItemSelected][index][5];
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
                                              currentDropdownItemSelected] = [];
                                              await firestoreService
                                                  .getTaskByClass(className)
                                                  .then((_) {
                                                setState(() {});
                                              });
                                              await firestoreService
                                                  .getTaskByClass(className)
                                                  .then((_) {
                                                setState(() {});
                                              });
                                              await firestoreService
                                                  .getTaskByClass(className)
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
                                                            currentDropdownItemSelected] = [];
                                                            await firestoreService
                                                                .getTaskByClass(className)
                                                                .then(
                                                                    (_) {
                                                                  setState(
                                                                          () {});
                                                                });
                                                            await firestoreService
                                                                .getTaskByClass(className)
                                                                .then(
                                                                    (_) {
                                                                  setState(
                                                                          () {});
                                                                });
                                                            await firestoreService
                                                                .getTaskByClass(className)
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
                          : SliverToBoxAdapter(child: SizedBox()),
                      firestoreService
                          .assessmentsMap[
                      currentDropdownItemSelected]
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
                          : SliverToBoxAdapter(child: SizedBox()),
                      firestoreService
                          .assessmentsMap[
                      currentDropdownItemSelected]
                          .isNotEmpty
                          ? SliverList(
                        delegate:
                        SliverChildBuilderDelegate((context, index) {
                          if (index >=
                              firestoreService
                                  .assessmentsMap[
                              currentDropdownItemSelected]
                                  .length) return null;
                          final assessmentName = firestoreService
                              .assessmentsMap[
                          currentDropdownItemSelected]
                          [index][0];
                          final type = firestoreService.assessmentsMap[
                          currentDropdownItemSelected]
                          [index][1];
                          final date = firestoreService.assessmentsMap[
                          currentDropdownItemSelected]
                          [index][2];
                          final time = firestoreService.assessmentsMap[
                          currentDropdownItemSelected]
                          [index][3];
                          final bool regRev = firestoreService
                              .assessmentsMap[
                          currentDropdownItemSelected]
                          [index][4];
                          final regRevInterval = firestoreService
                              .assessmentsMap[
                          currentDropdownItemSelected]
                          [index][5];
                          final regRevStartDate = firestoreService
                              .assessmentsMap[
                          currentDropdownItemSelected]
                          [index][6];
                          final className = firestoreService
                              .assessmentsMap[
                          currentDropdownItemSelected]
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
                                              firestoreService.assessmentsMap[currentDropdownItemSelected] = [];
                                              await firestoreService
                                                  .getAssessmentByClass(
                                                  currentDropdownItemSelected, className)
                                                  .then((_) {
                                                setState(() {});
                                              });
                                              await firestoreService
                                                  .getAssessmentByClass(
                                                  currentDropdownItemSelected, className)
                                                  .then((_) {
                                                setState(() {});
                                              });
                                              await firestoreService
                                                  .getAssessmentByClass(
                                                  currentDropdownItemSelected, className)
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
                                                                    currentDropdownItemSelected] = [];
                                                                    await firestoreService
                                                                        .getAssessmentByClass(
                                                                        currentDropdownItemSelected, className)
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
                                                                        .getAssessmentByClass(
                                                                        currentDropdownItemSelected, className)
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
                                                                        .getAssessmentByClass(
                                                                        currentDropdownItemSelected, className)
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
                          : SliverToBoxAdapter(child: SizedBox()),
                      firestoreService
                          .materialsMap[
                      currentDropdownItemSelected]
                          .isNotEmpty
                          ?SliverToBoxAdapter(
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
                      ):SliverToBoxAdapter(child: SizedBox()),
                      firestoreService
                          .materialsMap[
                      currentDropdownItemSelected]
                          .isNotEmpty
                          ? SliverList(delegate:
                      SliverChildBuilderDelegate((context, index) {
                        if (index >=
                            firestoreService
                                .materialsMap[
                            currentDropdownItemSelected]
                                .length) return null;
                        final MaterialName =
                        firestoreService.materialsMap[
                        currentDropdownItemSelected]
                        [index][0];
                        final dateAdded = firestoreService.materialsMap[
                        currentDropdownItemSelected]
                        [index][1];
                        final downloadLink =
                        firestoreService.materialsMap[
                        currentDropdownItemSelected]
                        [index][2];
                        final type = firestoreService.materialsMap[
                        currentDropdownItemSelected]
                        [index][3];
                        final className = firestoreService.materialsMap[
                        currentDropdownItemSelected]
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
                                            currentDropdownItemSelected] = [];
                                            await storageService.deleteFile(
                                                MaterialName,
                                                className,
                                                currentDropdownItemSelected,
                                                downloadLink, type);
                                            firestoreService.materialsMap[currentDropdownItemSelected] = [];
                                            await firestoreService.getMaterialsByClass(className);
                                            await firestoreService.getMaterialsByClass(className);
                                            await firestoreService.getMaterialsByClass(className);
                                            await firestoreService.getMaterialsByClass(className);
                                            await firestoreService.getMaterialsByClass(className);
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
                            SizedBox(height: 10,),
                          ],
                        );
                      }))
                          : SliverToBoxAdapter(child: SizedBox()),
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