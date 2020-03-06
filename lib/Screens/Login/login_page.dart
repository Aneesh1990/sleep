import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:sleep_giant/Generic/generic_helper.dart';
import 'package:sleep_giant/Screens/Home/home_screen.dart';
import 'package:sleep_giant/Screens/Register/signup_page.dart';
import 'package:sleep_giant/blocs/authBloc/auth_bloc.dart';
import 'package:sleep_giant/blocs/authBloc/auth_event.dart';
import 'package:sleep_giant/blocs/authBloc/auth_state.dart';
import 'package:sleep_giant/repositories/user_repository.dart';
import 'package:sleep_giant/utils/colors.dart';

class LoginPageParent extends StatelessWidget {
  UserRepository userRepository;

  LoginPageParent({@required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(userRepository: userRepository),
      child: LoginPAge(userRepository: userRepository),
    );
  }
}

class LoginPAge extends StatelessWidget {
  TextEditingController emailCntrlr = TextEditingController();
  TextEditingController passCntrlr = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  AuthBloc loginBloc;
  UserRepository userRepository;

  LoginPAge({@required this.userRepository});

  @override
  Widget build(BuildContext context) {
    loginBloc = BlocProvider.of<AuthBloc>(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
            child: Container(
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("assets/theme_bg.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ListView(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5.0),
                      child: BlocListener<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state is LoginSuccessState) {
                            navigateToHomeScreen(context, state.user);
                          } else if (state is NavigateState) {
                            navigateToSignUpScreen(context);
                          }
                        },
                        child: BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            if (state is LoginInitialState) {
                              return Container();
                            } else if (state is LoginLoadingState) {
                              return buildLoadingUi();
                            } else if (state is LoginFailState) {
                              generic.showToast(state.message);
//                              return buildFailureUi(state.message);
                            } else if (state is LoginSuccessState) {
                              emailCntrlr.text = "";
                              passCntrlr.text = "";
                              return Container();
                            }
                            return Container();
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset("assets/tutorial_logo.png"),
                    ),
                    Container(
                        color: Colors.white12,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: buildFormUI(context),
                          ),
                        )),
                  ],
                ))),
      ),
    );
  }

  List<Widget> buildFormUI(BuildContext context) {
    return <Widget>[
      SizedBox(
        height: 10,
      ),
      Text(
        'SIGN IN',
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.white),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextFormField(
          focusNode: _emailFocus,
          onFieldSubmitted: (term) {
//                                generic.fieldFocusChange(context, _emailFocus, _passwordFocus);
          },
          style: TextStyle(color: AppColors.white),
          controller: emailCntrlr,
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
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextFormField(
            focusNode: _passwordFocus,
            onFieldSubmitted: (value) {
              _passwordFocus.unfocus();
            },
            style: TextStyle(color: AppColors.white),
            controller: passCntrlr,
            decoration: InputDecoration(
              errorStyle: TextStyle(
                color: Colors.red,
                wordSpacing: 5.0,
              ),
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
      ),
      Divider(
        height: 15,
      ),
      InkWell(
        onTap: () {},
        child: Text(
          'Forgot Password?',
          style: TextStyle(color: AppColors.white),
        ),
      ),
      Divider(
        height: 15,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 40,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.white12,
              child: Text('SIGN IN', style: TextStyle(color: Colors.white)),
              onPressed: () {
                loginBloc.add(
                  LoginButtonPressed(
                    email: emailCntrlr.text,
                    password: passCntrlr.text,
                  ),
                );
              },
            ),
          ),
          Divider(
            height: 15,
          ),
          Text(
            "Don't have an account?",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.white12,
              child: Text('SIGN UP', style: TextStyle(color: Colors.white)),
              onPressed: () {
                navigateToSignUpScreen(context);
              },
            ),
          ),
          Divider(
            height: 15,
          ),
          Text(
            "© 2019 by Sleep Giant",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    ];
  }

  Widget buildLoadingUi() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildFailureUi(String message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(5.0),
          child: Text(
            "Fail $message",
            style: TextStyle(color: Colors.red),
          ),
        ),
//        buildInitialUi(),
      ],
    );
  }

  void navigateToHomeScreen(BuildContext context, FirebaseUser user) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
      return HomePageParent(user: user, userRepository: userRepository);
    }), (Route<dynamic> route) => false);

    //generic.showToast('Firebase database error');
  }

  void navigateToSignUpScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return SignUpPageParent(userRepository: userRepository);
    }));
  }
}
