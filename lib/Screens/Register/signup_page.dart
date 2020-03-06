import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:sleep_giant/Generic/generic_helper.dart';
import 'package:sleep_giant/Screens/Home/home_screen.dart';
import 'package:sleep_giant/Screens/Login/login_page.dart';
import 'package:sleep_giant/blocs/authBloc/auth_bloc.dart';
import 'package:sleep_giant/blocs/authBloc/auth_event.dart';
import 'package:sleep_giant/blocs/authBloc/auth_state.dart';
import 'package:sleep_giant/repositories/user_repository.dart';
import 'package:sleep_giant/utils/colors.dart';

class SignUpPageParent extends StatelessWidget {
  UserRepository userRepository;

  SignUpPageParent({@required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(userRepository: userRepository),
      child: SignUpPage(userRepository: userRepository),
    );
  }
}

class SignUpPage extends StatelessWidget {
  TextEditingController emailCntrl = TextEditingController();
  TextEditingController passCntrlr = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  String authResult;
  AuthBloc userRegBloc;
  UserRepository userRepository;

  SignUpPage({@required this.userRepository});

  @override
  Widget build(BuildContext context) {
    userRegBloc = BlocProvider.of<AuthBloc>(context);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Image(
          image: AssetImage('assets/theme_bg.png'),
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.transparent,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/theme_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5.0),
                child: BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is UserRegSuccessful) {
                      navigateToHomePage(context, state.user);
                    }
                  },
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
//                    if (state is UserRegInitial) {
//                      return buildInitialUi();
//                    } else
                      if (state is UserRegLoading) {
                        return buildLoadingUi();
                      } else if (state is UserRegFailure) {
                        return buildFailureUi(state.message);
                      } else if (state is UserRegSuccessful) {
                        emailCntrl.text = "";
                        passCntrlr.text = "";
                        return Container();
                      }
                      return Container();
                    },
                  ),
                ),
              ),
              _registerForm(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _registerForm(BuildContext context) {
    return Form(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: Image.asset("assets/tutorial_logo.png"),
          ),
          SizedBox(
            height: 30,
          ),
          Card(
            color: Colors.white12,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    focusNode: _nameFocus,
                    onFieldSubmitted: (term) {
                      generic.fieldFocusChange(
                          context, _nameFocus, _emailFocus);
                    },
                    style: TextStyle(color: AppColors.white),
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(color: AppColors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54),
                      ),
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54)),
                    ),
                    autovalidate: false,
                    autocorrect: false,
                    validator: (value) {
                      if (!validator.name(value) && value.isNotEmpty) {
                        return 'Please enter valid name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                      focusNode: _emailFocus,
                      onFieldSubmitted: (term) {
                        generic.fieldFocusChange(
                            context, _emailFocus, _passwordFocus);
                      },
                      style: TextStyle(color: AppColors.white),
                      controller: emailCntrl,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        labelStyle: TextStyle(color: AppColors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white54)),
                      ),
                      autovalidate: true,
                      autocorrect: false,
                      validator: (value) {
                        if (!validator.email(value) && value.isNotEmpty) {
                          return 'Please enter valid email address';
                        }
                        return null;
                      }),
                  TextFormField(
                      focusNode: _passwordFocus,
                      onFieldSubmitted: (term) {
                        generic.fieldFocusChange(
                            context, _passwordFocus, _confirmPasswordFocus);
                      },
                      style: TextStyle(color: AppColors.white),
                      controller: passCntrlr,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: AppColors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white54)),
                      ),
                      obscureText: true,
                      autovalidate: true,
                      autocorrect: false,
                      validator: (value) {
                        if (!validator.password(value) && value.isNotEmpty) {
                          return 'Password should be albhanumeric, caps and special character';
                        }
                        return null;
                      }),
                  TextFormField(
                      focusNode: _confirmPasswordFocus,
                      onFieldSubmitted: (term) {
                        _confirmPasswordFocus.unfocus();
                      },
                      style: TextStyle(color: AppColors.white),
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(color: AppColors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white54)),
                      ),
                      obscureText: true,
                      autovalidate: true,
                      autocorrect: false,
                      validator: (value) {
                        if (!validator.password(value) && value.isNotEmpty) {
                          return 'Password should be albhanumeric, caps and special character';
                        }
                        return null;
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 50,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: Colors.white12,
                      child: Text('SIGN UP',
                          style: TextStyle(color: AppColors.white)),
                      onPressed: () {
                        if (nameController.text.isEmpty ||
                            emailCntrl.text.isEmpty ||
                            passCntrlr.text.isEmpty ||
                            confirmPasswordController.text.isEmpty) {
                          generic.alertDialog(context, "Missing Fields",
                              "Please fill all the fields", () {});
                        } else if (passCntrlr.text !=
                            confirmPasswordController.text) {
                          generic.alertDialog(context, "Password doesn't match",
                              "Please enter same password", () {});
                        } else if (validator.email(emailCntrl.text) &&
                            passCntrlr.text.length >= 6 &&
                            confirmPasswordController.text.length >= 6) {
                          userRegBloc.add(SignUpButtonPressedregpage(
                              email: emailCntrl.text,
                              password: confirmPasswordController.text,
                              name: nameController.text));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInitialUi() {
    return Text("Waiting For Authentication");
  }

  Widget buildLoadingUi() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  void navigateToHomePage(BuildContext context, FirebaseUser user) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return HomePageParent(user: user, userRepository: userRepository);
    }), (Route<dynamic> route) => false);

//    generic.showToast('Firebase database error');
  }

  Widget buildFailureUi(String message) {
    return Text(
      message,
      style: TextStyle(color: Colors.red),
    );
  }

  void navigateToLoginPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LoginPageParent(userRepository: userRepository);
    }));
  }
}
