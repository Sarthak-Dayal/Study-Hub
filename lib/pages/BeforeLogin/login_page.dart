import 'package:flutter/material.dart';
import 'package:study_hub/data/data.dart';
import 'file:///C:/Users/dayal/AndroidStudioProjects/study_hub/lib/pages/BeforeLogin/reset_password.dart';
import 'file:///C:/Users/dayal/AndroidStudioProjects/study_hub/lib/pages/BeforeLogin/signup_page.dart';
import 'package:study_hub/services/auth.dart';
import 'package:validators/validators.dart' as validator;
import 'package:study_hub/pages/AfterLogin/schedule.dart';
String email;
LogInFormData data = LogInFormData();
class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  ResetPasswordFormData resetData;
  bool loading;
  String error;
  final _formKey = GlobalKey<FormState>();
  AuthService _auth = AuthService();
  @override
  void initState() {
    super.initState();
      setState(() {
    });
  }
    void unabletosignin() {
      setState(() {
        if(_auth.error=="[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted."){
          error = "No account exists under this email address. If you are a new user, click sign up below.";
        }else if(_auth.error== "[firebase_auth/wrong-password] The password is invalid or the user does not have a password."){
          error = "Invalid Password. Try again.";
        }else{
          error = _auth.error;
        }
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
    var preTextWidth = MediaQuery.of(context).size.width * (1.0 / 19.0);
    final contextHeight = MediaQuery.of(context).size.height;
    return Material(
      child: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox.fromSize(
                size: Size(0.0, contextHeight * (1.0/5.0)),
              ),

              Row(children: [
                SizedBox.fromSize(
                  size: Size(preTextWidth, 0.0),
                ),
                Text(
                  "Welcome back,",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 36.0/850.9090909090909*contextHeight,
                      color: Colors.white,
                      fontFamily: 'Abel'),
                ),
              ]),
              SizedBox.fromSize(
                size:
                Size(0.0, contextHeight * (1.0 / 90.0)),
              ),
              Row(children: [
                SizedBox.fromSize(
                  size: Size(preTextWidth, 0.0),
                ),
                Text(
                  "Sign in to continue",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 24.0/850.9090909090909*contextHeight, color: Colors.white, fontFamily: 'Abel'),
                ),
              ]),
              Container(
                margin: EdgeInsets.only(
                    top: (1.0 / 18.0) * contextHeight),
                decoration: BoxDecoration(
                  color: Color(0xFFDEF3FF),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                height: contextHeight *(0.75),
                width: MediaQuery.of(context).size.width,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox.fromSize(
                        size: Size(0.0,
                            contextHeight * (1.0 / 17.0)),
                      ),
                      Row(children: [
                        SizedBox.fromSize(
                          size: Size(preTextWidth, 0.0),
                        ),
                        Text(
                          "Email",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18.0/850.9090909090909*contextHeight,
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
                          data.email = value;
                          email = value;
                        },
                      ),
                      SizedBox.fromSize(
                        size: Size(0.0,
                            contextHeight * (1.0 / 40.0)),
                      ),
                      Row(children: [
                        SizedBox.fromSize(
                          size: Size(preTextWidth, 0.0),
                        ),
                        Text(
                          "Password",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18.0/850.9090909090909*contextHeight,
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
                          data.password = value;
                        },
                      ),
                      SizedBox.fromSize(
                        size: Size(0.0,
                            contextHeight * (1.0 / 17.0)),
                      ),
                      Row(children: [
                        SizedBox.fromSize(
                          size: Size(preTextWidth, 0.0),
                        ),
                        InkWell(
                          onTap:
                              () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ResetPasswordPage()));
                              },
                          child: Text(
                            "Forgot Password?",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18.0/850.9090909090909*contextHeight,
                              color: Theme.of(context).primaryColor,
                              fontFamily: 'Abel',
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ]),
                      SizedBox.fromSize(
                        size: Size(0.0,
                            contextHeight * (1.0 / 17.0)),
                      ),
                      Center(
                          child: SizedBox(
                            width: (182.0/207.0)*MediaQuery.of(context).size.width,
                            height: (25.0/448.0)* contextHeight,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0/850.9090909090909*contextHeight),
                              ),
                              onPressed:
                                  () async{
                                buttonPressed();
                                if(_formKey.currentState.validate()){
                                  _formKey.currentState.save();
                                  nowLoading();
                                  dynamic result =  await _auth.signin(data.email, data.password);
                                  doneLoading();
                                  if(result==null){
                                    unabletosignin();
                                  }else{
                                    firestoreService.addUser();
                                  }
                                  print(result);
                                }
                              },
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              splashColor: Colors.blue[900],
                              child: Text(
                                "SIGN IN",
                                style: TextStyle(fontSize: 18.0/850.9090909090909*contextHeight, fontFamily: 'Abel'),
                              ),
                            ),
                          )),
                      SizedBox(height:error!=null||loading==true ? 20/850.9090909090909*contextHeight:0,),
                      loading==true ? LinearProgressIndicator(
                        backgroundColor: Theme.of(context).primaryColor,
                      ) : Text(
                        error!=null ? error:"",
                        style: TextStyle(fontSize: 18.0/850.9090909090909*contextHeight, fontFamily: 'Abel', color: Colors.red),
                      ),
                      SizedBox.fromSize(
                        size: Size(0.0,
                            contextHeight * (1.0 / 30.0)),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("New user?",
                              style: TextStyle(
                                fontSize: 18.0/850.9090909090909*contextHeight,
                                color: Theme.of(context).primaryColor,
                                fontFamily: 'Abel',
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> SignupPage()));
                              },
                              child: Text(
                                "Sign up",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18.0/850.9090909090909*contextHeight,
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
    final contextHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding:EdgeInsets.fromLTRB(8.0/850.9090909090909*contextHeight, 4.0/850.9090909090909*contextHeight, 8.0, 4.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 24.0/850.9090909090909*contextHeight,
            fontFamily: 'Abel',
          ),
          contentPadding: EdgeInsets.all(15.0/850.9090909090909*contextHeight),
        ),
        obscureText: isPassword ? true : false,
        validator: Validator,
        onSaved: onSaved,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        style: TextStyle(
          fontSize: 24.0/850.9090909090909*contextHeight,
          fontFamily: 'Abel',
          color: Colors.black,
        ),
      ),
    );
  }
}
