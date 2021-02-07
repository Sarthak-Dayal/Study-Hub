import 'package:flutter/material.dart';
import 'package:study_hub/data/data.dart';
import 'package:validators/validators.dart' as validator;
import 'package:study_hub/services/auth.dart';
class SignupPage extends StatefulWidget {
  SignupPage({Key key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String error;
  final _formKey = GlobalKey<FormState>();
  SignUpFormData signUpData = SignUpFormData();
  AuthService _auth = AuthService();
  bool loading;
  void unabletosignup() {
    setState(() {
      error = _auth.error=="[firebase_auth/email-already-in-use] The email address is already in use by another account." ? "An account already exists under this email address.":"Error signing up. Check your internet and try again";
      print(error);
    });

  }
  void buttonPressed(){
    setState(() {
      if (error != null) error = null;
    });
  }
void nowLoading(){
    setState(() {
      loading = true;
    });
}
void doneLoading(){
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
    return Material(
      child: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox.fromSize(
                size: Size(0.0, Contextheight * (1.0 / 8.0)),
              ),
              Row(children: [
                SizedBox.fromSize(
                  size: Size(preTextWidth, 0.0),
                ),
                Text(
                  "Get on board,",
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
                size:
                Size(0.0, Contextheight * (1.0 / 90.0)),
              ),
              Row(children: [
                SizedBox.fromSize(
                  size: Size(preTextWidth, 0.0),
                ),
                Text(
                  "Sign up to continue",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 24.0/850.9090909090909*Contextheight, color: Colors.white, fontFamily: 'Abel'),
                ),
              ]),
              Container(
                margin: EdgeInsets.only(
                    top: (1.0 / 18.0) * Contextheight),
                decoration: BoxDecoration(
                  color: Color(0xFFDEF3FF),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                height: Contextheight *(4.0/5.0),
                width: ContextWidth,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox.fromSize(
                        size: Size(0.0,
                            Contextheight * (1.0 / 17.0)),
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
                            color: Theme.of(context).primaryColor,
                            fontFamily: 'Abel',
                          ),
                        ),
                      ]),
                      BuildTextFormField(
                        hintText: "example@gmail.com",
                        isEmail: true,
                        Validator:(String value){
                          if(!validator.isEmail(value)){
                            return "Please Enter a valid Email";
                          }
                          _formKey.currentState.save();
                          return null;
                        },
                        onSaved: (String value){
                          signUpData.email = value;
                        },
                      ),
                      SizedBox.fromSize(
                        size: Size(0.0,
                            Contextheight * (1.0 / 40.0)),
                      ),
                      Row(children: [
                        SizedBox.fromSize(
                          size: Size(preTextWidth, 0.0),
                        ),
                        Text(
                          "Password",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18.0/850.9090909090909*Contextheight,
                            color: Theme.of(context).primaryColor,
                            fontFamily: 'Abel',
                          ),
                        ),
                      ]),
                      BuildTextFormField(
                        hintText: "Enter Password",
                        isPassword: true,
                        Validator:(String value){
                          if(value.length<8){
                            return "Password must be at least 8 characters.";
                          }
                          _formKey.currentState.save();
                          return null;
                        },
                        onSaved: (String value){
                          signUpData.password = value;
                        },
                      ),
                      SizedBox.fromSize(
                        size: Size(0.0,
                            Contextheight * (1.0 / 40.0)),
                      ),
                      Row(children: [
                        SizedBox.fromSize(
                          size: Size(preTextWidth, 0.0),
                        ),
                        Text(
                          "Confirm Password",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18.0/850.9090909090909*Contextheight,
                            color: Theme.of(context).primaryColor,
                            fontFamily: 'Abel',
                          ),
                        ),
                      ]),
                      BuildTextFormField(
                        hintText: "Confirm Password",
                        isPassword: true,
                        Validator:(String value){
                          if(signUpData.password==null || signUpData.password!=value){
                            return "Passwords are to short or do not match";
                          }
                          _formKey.currentState.save();
                          return null;
                        },
                        onSaved: (String value){
                          signUpData.confirmPassword = value;
                        },
                      ),
                      SizedBox.fromSize(
                        size: Size(0.0,
                            Contextheight * (1.0 / 17.0)),
                      ),
                      Center(
                          child: SizedBox(
                            width: (182.0/207.0)* ContextWidth,
                            height: (25.0/448.0)* Contextheight,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0/850.9090909090909*Contextheight),
                              ),
                              onPressed:
                                  () async {
                                buttonPressed();
                                if(_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  nowLoading();
                                  dynamic result = await _auth.register(signUpData.email,signUpData.password);
                                  doneLoading();
                                  if(result==null){
                                    unabletosignup();
                                  }
                                  print(result);

                                }
                              },
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              splashColor: Colors.blue[900],
                              child: Text(
                                "SIGN UP",
                                style: TextStyle(fontSize: 18.0/850.9090909090909*Contextheight, fontFamily: 'Abel'),
                              ),
                            ),
                          )),
                      SizedBox(height:error!=null||loading==true ? 20/850.9090909090909*Contextheight:0,),
                      loading==true ? LinearProgressIndicator(
                        backgroundColor: Theme.of(context).primaryColor,
                      ) : Text(
                        error!=null ? error:"",
                        style: TextStyle(fontSize: 18.0/850.9090909090909*Contextheight, fontFamily: 'Abel', color: Colors.red),
                      ),
                      SizedBox.fromSize(
                        size: Size(0.0,
                            Contextheight * (1.0 / 30.0)),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Existing user?",
                              style: TextStyle(
                                fontSize: 18.0/850.9090909090909*Contextheight,
                                color: Theme.of(context).primaryColor,
                                fontFamily: 'Abel',
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Sign in",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18.0/850.9090909090909*Contextheight,
                                  color: Theme.of(context).primaryColor,
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
      padding:EdgeInsets.fromLTRB(8.0/850.9090909090909*Contextheight, 4.0/850.9090909090909*Contextheight, 8.0/850.9090909090909*Contextheight, 4.0/850.9090909090909*Contextheight),
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
