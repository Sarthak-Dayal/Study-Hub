
import 'package:flutter/material.dart';
import 'package:study_hub/pages/AddScreens/AddClass.dart';
import 'package:study_hub/pages/AddScreens/AddMaterial.dart';
import 'package:study_hub/pages/AddScreens/AddTask.dart';
import 'package:study_hub/pages/AfterLogin/schedule.dart';

class FancyFab extends StatefulWidget {
  final Function() onPressed;
  final String tooltip;
  final IconData icon;

  FancyFab({this.onPressed, this.tooltip, this.icon});

  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  initState() {
    _animationController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Color(0xFF00417D),
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget add() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: Color(0xFF00417D),
        heroTag: "btn1",
        onPressed:(){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddClassPage()));
        },
        tooltip: 'Add Class',
        child: Icon(Icons.list),
      ),
    );
  }

  Widget image() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: Color(0xFF00417D),
        heroTag: "btn2",
        onPressed:(){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddMaterialPage()));
        },
        tooltip: 'Add Material',
        child: Icon(Icons.image),
      ),
    );
  }

  Widget inbox() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: Color(0xFF00417D),
        heroTag: "btn3",
        onPressed:(){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddTaskPage()));
        },
        tooltip: 'Add Task',
        child: Icon(Icons.check),
      ),
    );
  }
  Widget assessment() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: Color(0xFF00417D),
        heroTag: "btn4",
        onPressed:(){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddMaterialPage()));
        },
        tooltip: 'Add Assessment',
        child: Icon(Icons.assessment),
      ),
    );
  }
  Widget toggle() {
    return Container(
      child:
      FloatingActionButton(
        heroTag: "btn5",
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Add Menu',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 4.0,
            0.0,
          ),
          child: assessment(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 3.0,
            0.0,
          ),
          child: add(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: image(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: inbox(),
        ),
        toggle(),
      ],
    );
  }
}