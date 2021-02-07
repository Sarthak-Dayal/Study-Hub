import 'package:flutter/material.dart';
import 'package:study_hub/data/data.dart';
import 'package:validators/validators.dart' as validator;
import 'package:study_hub/services/auth.dart';

class ResetPasswordPage extends StatefulWidget {
  ResetPasswordPage({Key key}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  bool reset;
  String error;
  final _formKey = GlobalKey<FormState>();
  final ResetPasswordFormData resetData = ResetPasswordFormData();
  AuthService _auth = AuthService();
  bool loading;
  void unableToReset() {
    setState(() {
      if (_auth.error ==
          "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.") {
        error = "No account exists under that email address.";
      } else {
        error =
            "Could not send the email. Check your internet connection and try again.";
      }
    });
  }
  void ableToReset(){
    setState(() {
      reset = true;
    });
  }
  void buttonPressed() {
    setState(() {
      if (error != null) error = null;
      reset = false;
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
    // ignore: non_constant_identifier_names
    final ContextWidth = MediaQuery.of(context).size.width;
    final preTextWidth = ContextWidth * (1.0 / 19.0);
    // ignore: non_constant_identifier_names
    final Contextheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Builder(
        builder:(BuildContext context) {
          return Material(
            child: SingleChildScrollView(
              child: Container(
                color: Theme
                    .of(context)
                    .primaryColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox.fromSize(
                      size: Size(0.0, Contextheight * (1.0 / 10.0)),
                    ),
                    reset==true ? Container(
                      color: Colors.amber,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.email, color: Colors.black,),
                          Text(
                            "  An email was sent to "+ resetData.email+".",
                            style: TextStyle(
                              fontSize: 14.5,
                              fontFamily: 'Abel',
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: ContextWidth*1.0/1000.0,),
                            FlatButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: Text("Sign In",
                              style: TextStyle(
                                color: Colors.blue,
                                fontFamily: 'Abel',
                                fontSize: 18,
                              ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ):SizedBox(height: 0,),
                    SizedBox.fromSize(
                      size: Size(0.0, Contextheight * (1.0 / 10.0)),
                    ),
                    Row(children: [
                      SizedBox.fromSize(
                        size: Size(preTextWidth, 0.0),
                      ),
                      Text(
                        "Reset Password,",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 36.0/850.9090909090909*Contextheight,
                            color: Colors.white,
                            fontFamily: 'Abel'),
                      ),
                    ]),
                    SizedBox.fromSize(
                      size: Size(0.0, Contextheight * (1.0 / 90.0)),
                    ),
                    Row(children: [
                      SizedBox.fromSize(
                        size: Size(preTextWidth, 0.0),
                      ),
                      Text(
                        "Enter email to continue",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 24.0/850.9090909090909*Contextheight,
                            color: Colors.white,
                            fontFamily: 'Abel'),
                      ),
                    ]),
                    Container(
                      margin: EdgeInsets.only(
                          top: (1.0 / 18.0) * Contextheight),
                      decoration: BoxDecoration(
                        color: Color(0xFFDEF3FF),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      height: Contextheight * (3.21 / 5.0),
                      width: ContextWidth,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox.fromSize(
                              size: Size(0.0, Contextheight * (1.0 / 17.0)),
                            ),
                            Row(children: [
                              SizedBox.fromSize(
                                size: Size(preTextWidth, 0.0),
                              ),
                              Text(
                                "Email",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18.0/850.9090909090909*Contextheight,
                                  color: Theme
                                      .of(context)
                                      .primaryColor,
                                  fontFamily: 'Abel',
                                ),
                              ),
                            ]),
                            BuildTextFormField(
                              hintText: "example@gmail.com",
                              isEmail: true,
                              Validator: (String value) {
                                if (!validator.isEmail(value)) {
                                  return "Please Enter a valid Email";
                                }
                                _formKey.currentState.save();
                                return null;
                              },
                              onSaved: (String value) {
                                resetData.email = value;
                              },
                            ),
                            SizedBox.fromSize(
                              size: Size(0.0, Contextheight * (1.0 / 17.0)),
                            ),
                            Center(
                                child: SizedBox(
                                  width: (182.0 / 207.0) * ContextWidth,
                                  height: (25.0 / 448.0) * Contextheight,
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0/850.9090909090909*Contextheight),
                                    ),
                                    onPressed: () async {
                                      buttonPressed();
                                      if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                        nowLoading();
                                        dynamic result =
                                        await _auth.resetPassword(
                                            resetData.email);
                                        doneLoading();
                                        if (result == "Did not work") {
                                          unableToReset();
                                        } else {
                                          ableToReset();
                                        }
                                      }
                                    },
                                    color: Theme
                                        .of(context)
                                        .primaryColor,
                                    textColor: Colors.white,
                                    splashColor: Colors.blue[900],
                                    child: Text(
                                      "SEND LINK",
                                      style:
                                      TextStyle(
                                          fontSize: 18.0/850.9090909090909*Contextheight, fontFamily: 'Abel'),
                                    ),
                                  ),
                                )),
                            SizedBox(
                              height: error != null || loading == true ? 20 : 0,
                            ),
                            loading == true
                                ? LinearProgressIndicator(
                              backgroundColor: Theme
                                  .of(context)
                                  .primaryColor,
                            )
                                : Text(
                              error != null ? error : "",
                              style: TextStyle(
                                  fontSize: 18.0/850.9090909090909*Contextheight,
                                  fontFamily: 'Abel',
                                  color: Colors.red),
                            ),
                            SizedBox.fromSize(
                              size: Size(0.0, Contextheight * (1.0 / 30.0)),
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Remember Password?",
                                    style: TextStyle(
                                      fontSize: 18.0/850.9090909090909*Contextheight,
                                      color: Theme
                                          .of(context)
                                          .primaryColor,
                                      fontFamily: 'Abel',
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Sign in",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18.0/850.9090909090909*Contextheight,
                                        color: Theme
                                            .of(context)
                                            .primaryColor,
                                        fontFamily: 'Abel',
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
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
  BuildTextFormField({
    this.hintText,
    // ignore: non_constant_identifier_names
    this.Validator,
    this.onSaved,
    this.isPassword = false,
    this.isEmail = false,
  });
  @override
  Widget build(BuildContext context) {
    final Contextheight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.fromLTRB(8.0/850.9090909090909*Contextheight, 4.0/850.9090909090909*Contextheight, 8.0/850.9090909090909*Contextheight, 4.0/850.9090909090909*Contextheight),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 24.0/850.9090909090909*Contextheight,
            fontFamily: 'Abel',
          ),
          contentPadding: EdgeInsets.all(15.0/850.9090909090909*Contextheight),
        ),
        obscureText: isPassword ? true : false,
        validator: Validator,
        onSaved: onSaved,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        style: TextStyle(
          fontSize: 24.0/850.9090909090909*Contextheight,
          fontFamily: 'Abel',
          color: Colors.black,
        ),
      ),
    );
  }
}
