//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:regexed_validator/regexed_validator.dart';
//import 'package:sleep_giant/Generic/generic_helper.dart';
//import 'package:sleep_giant/Screens/Login/forgot_password.dart';
//import 'package:sleep_giant/Style/colors.dart';
//import 'package:sleep_giant/blocs/loginBloc/login_bloc.dart';
//import 'package:sleep_giant/blocs/loginBloc/login_event.dart';
//import 'package:sleep_giant/blocs/loginBloc/login_state.dart';
//import 'package:sleep_giant/repositories/user_repository.dart';
//
//import '../Home/home_screen.dart';
//import '../Register/signup_screen.dart';
//
//class LoginPageParent extends StatelessWidget {
//  UserRepository userRepository;
//
//  LoginPageParent({@required this.userRepository});
//
//  @override
//  Widget build(BuildContext context) {
//    return BlocProvider(
//      create: (context) => LoginBloc(userRepository: userRepository),
//      child: SGSignInScreenState(userRepository: userRepository),
//    );
//  }
//}
//
//class SGSignInScreenState extends StatelessWidget {
//  final TextEditingController _emailController = TextEditingController();
//  final TextEditingController _passwordController = TextEditingController();
//  final FocusNode _emailFocus = FocusNode();
//  final FocusNode _passwordFocus = FocusNode();
//
//  LoginBloc loginBloc;
//  UserRepository userRepository;
//
//  SGSignInScreenState({this.userRepository});
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: Container(
//          decoration: new BoxDecoration(
//            image: new DecorationImage(
//              image: new AssetImage("assets/theme_bg.png"),
//              fit: BoxFit.cover,
//            ),
//          ),
//          child: ListView(
////              mainAxisAlignment: MainAxisAlignment.center,
////             crossAxisAlignment: CrossAxisAlignment.center,
//            // physics: ClampingScrollPhysics(),
//            children: <Widget>[
//              Container(
//                padding: EdgeInsets.all(5.0),
//                child: BlocListener<LoginBloc, LoginState>(
//                  listener: (context, state) {
//                    if (state is LoginSuccessState) {
//                      navigateToHomeScreen(context, state.user);
//                    } else if (state is NavigateState) {
//                      navigateToSignUpScreen(context);
//                    }
//                  },
//                  child: BlocBuilder<LoginBloc, LoginState>(
//                    builder: (context, state) {
//                      if (state is LoginInitialState) {
//                        return Container();
//                      } else if (state is LoginLoadingState) {
//                        return buildLoadingUi();
//                      } else if (state is LoginFailState) {
//                        generic.showToast(state.message);
////                              return buildFailureUi(state.message);
//                      } else if (state is LoginSuccessState) {
//                        _emailController.text = "";
//                        _passwordController.text = "";
//                        return Container();
//                      }
//                      return Container();
//                    },
//                  ),
//                ),
//              ),
//              Padding(
//                padding: const EdgeInsets.all(10.0),
//                child: Image.asset("assets/tutorial_logo.png"),
//              ),
//              Container(
//                  color: Colors.white12,
//                  child: Padding(
//                    padding: const EdgeInsets.all(10.0),
//                    child: Column(
//                      children: <Widget>[
//                        SizedBox(
//                          height: 10,
//                        ),
//                        Text(
//                          'SIGN IN',
//                          style: TextStyle(
//                              fontSize: 20,
//                              fontWeight: FontWeight.bold,
//                              color: AppColors.white),
//                        ),
//                        Padding(
//                          padding: const EdgeInsets.all(10.0),
//                          child: TextFormField(
//                            focusNode: _emailFocus,
//                            onFieldSubmitted: (term) {
//                              generic.fieldFocusChange(
//                                  context, _emailFocus, _passwordFocus);
//                            },
//                            style: TextStyle(color: AppColors.white),
//                            controller: _emailController,
//                            decoration: InputDecoration(
//                              labelText: 'Email Address',
//                              labelStyle: TextStyle(color: AppColors.white),
//                              enabledBorder: UnderlineInputBorder(
//                                borderSide: BorderSide(color: Colors.white54),
//                              ),
//                              focusedBorder: UnderlineInputBorder(
//                                borderSide: BorderSide(color: Colors.white54),
//                              ),
//                              border: UnderlineInputBorder(
//                                  borderSide:
//                                      BorderSide(color: Colors.white54)),
//                            ),
//                            autovalidate: true,
//                            autocorrect: false,
//                            validator: (value) {
//                              if (!validator.email(value) && value.isNotEmpty) {
//                                return 'Please enter valid email address';
//                              }
//                              return null;
//                            },
//                          ),
//                        ),
//                        Padding(
//                          padding: const EdgeInsets.all(10.0),
//                          child: TextFormField(
//                              focusNode: _passwordFocus,
//                              onFieldSubmitted: (value) {
//                                _passwordFocus.unfocus();
//                              },
//                              style: TextStyle(color: AppColors.white),
//                              controller: _passwordController,
//                              decoration: InputDecoration(
//                                errorStyle: TextStyle(
//                                  color: Colors.red,
//                                  wordSpacing: 5.0,
//                                ),
//                                labelText: 'Password',
//                                labelStyle: TextStyle(color: AppColors.white),
//                                enabledBorder: UnderlineInputBorder(
//                                  borderSide: BorderSide(color: Colors.white54),
//                                ),
//                                focusedBorder: UnderlineInputBorder(
//                                  borderSide: BorderSide(color: Colors.white54),
//                                ),
//                                border: UnderlineInputBorder(
//                                    borderSide:
//                                        BorderSide(color: Colors.white54)),
//                              ),
//                              obscureText: true,
//                              autovalidate: true,
//                              autocorrect: false,
//                              validator: (value) {
//                                if (!validator.password(value) &&
//                                    value.isNotEmpty) {
//                                  return 'Enter valid password';
//                                }
//                                return null;
//                              }),
//                        ),
//                        Divider(
//                          height: 15,
//                        ),
//                        InkWell(
//                          onTap: () {
//                            Navigator.of(context).push(
//                              MaterialPageRoute(
//                                  builder: (_) => ForgotPassword()),
//                            );
//                          },
//                          child: Text(
//                            'Forgot Password?',
//                            style: TextStyle(color: AppColors.white),
//                          ),
//                        ),
//                        Divider(
//                          height: 15,
//                        ),
//                        Column(
//                          crossAxisAlignment: CrossAxisAlignment.stretch,
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            Container(
//                              height: 40,
//                              child: FlatButton(
//                                shape: RoundedRectangleBorder(
//                                  borderRadius: BorderRadius.circular(30.0),
//                                ),
//                                color: Colors.white12,
//                                child: Text('SIGN IN',
//                                    style: TextStyle(color: Colors.white)),
//                                onPressed: () {
//                                  if (_emailController.text.isEmpty) {
//                                    generic.alertDialog(
//                                        context,
//                                        'Missing Field',
//                                        "Please enter a email address",
//                                        () {});
//                                  } else if (_passwordController.text.isEmpty) {
//                                    generic.alertDialog(
//                                        context,
//                                        'Missing Field',
//                                        "Please enter a password",
//                                        () {});
//                                  } else if (validator
//                                          .email(_emailController.text) &&
//                                      validator
//                                          .password(_passwordController.text)) {
//                                    loginBloc.add(
//                                      LoginButtonPressed(
//                                        email: _emailController.text,
//                                        password: _passwordController.text,
//                                      ),
//                                    );
//
////                                      generic.check().then((intenet) {
////                                        if (intenet != null && intenet) {
////                                          // Internet Present Case
////                                          _onSubmit();
////                                        }else{
////                                          generic.alertDialog(context, "Appeared offline","You don't have Active intenet connection");
////                                          // No-Internet Case
////                                        }
////
////                                      });
//
//                                  }
//                                },
//                              ),
//                            ),
//                            Divider(
//                              height: 15,
//                            ),
//                            Text(
//                              "Don't have an account?",
//                              textAlign: TextAlign.center,
//                              style: TextStyle(color: Colors.white54),
//                            ),
//                            SizedBox(
//                              height: 10,
//                            ),
//                            Container(
//                              height: 40,
//                              child: FlatButton(
//                                shape: RoundedRectangleBorder(
//                                  borderRadius: BorderRadius.circular(30.0),
//                                ),
//                                color: Colors.white12,
//                                child: Text('SIGN UP',
//                                    style: TextStyle(color: Colors.white)),
//                                onPressed: () {
//                                  loginBloc.add(SignUpButtonPressed());
//                                },
//                              ),
//                            ),
//                            Divider(
//                              height: 15,
//                            ),
//                            Text(
//                              "© 2019 by Sleep Giant",
//                              textAlign: TextAlign.center,
//                              style: TextStyle(color: Colors.white54),
//                            ),
//                          ],
//                        ),
//                      ],
//                    ),
//                  )),
//            ],
//          )),
//    );
//  }
//
//  // <editor-fold desc=" Network - call ">
//
//// </editor-fold>
//
//  Widget buildLoadingUi() {
//    return Center(
//      child: CircularProgressIndicator(),
//    );
//  }
//
//  Widget buildFailureUi(String message) {
//    return Column(
//      mainAxisAlignment: MainAxisAlignment.center,
//      children: <Widget>[
//        Container(
//          padding: EdgeInsets.all(5.0),
//          child: Text(
//            "Fail $message",
//            style: TextStyle(color: Colors.red),
//          ),
//        ),
////        buildInitialUi(),
//      ],
//    );
//  }
//
//  void navigateToHomeScreen(BuildContext context, FirebaseUser user) {
//    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//      return HomePageParent(user: user, userRepository: userRepository);
//    }));
//  }
//
//  void navigateToSignUpScreen(BuildContext context) {
//    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//      return SignUpPageParent(userRepository: userRepository);
//    }));
//  }
//}
