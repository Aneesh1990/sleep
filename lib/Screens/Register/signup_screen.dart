//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:regexed_validator/regexed_validator.dart';
//import 'package:sleep_giant/Generic/generic_helper.dart';
//import 'package:sleep_giant/Style/colors.dart';
//import 'package:sleep_giant/blocs/regBloc/user_reg_bloc.dart';
//import 'package:sleep_giant/blocs/regBloc/user_reg_event.dart';
//import 'package:sleep_giant/blocs/regBloc/user_reg_state.dart';
//import 'package:sleep_giant/repositories/user_repository.dart';
//import 'package:sleep_giant/utils/widget.dart';
//
//import '../Home/home_screen.dart';
//import '../Login/signin_screen.dart';
//
//class SignUpPageParent extends StatelessWidget {
//  UserRepository userRepository;
//
//  SignUpPageParent({@required this.userRepository});
//
//  @override
//  Widget build(BuildContext context) {
//    return BlocProvider(
//      create: (context) => UserRegBloc(userRepository: userRepository),
//      child: SGSignUpScreen(userRepository: userRepository),
//    );
//  }
//}
//
//class SGSignUpScreen extends StatelessWidget {
//  final TextEditingController _nameController = TextEditingController();
//  final TextEditingController _emailController = TextEditingController();
//  final TextEditingController _passwordController = TextEditingController();
//  final TextEditingController _confirmPasswordController =
//      TextEditingController();
//
//  final FocusNode _nameFocus = FocusNode();
//  final FocusNode _passwordFocus = FocusNode();
//  final FocusNode _emailFocus = FocusNode();
//  final FocusNode _confirmPasswordFocus = FocusNode();
//
//  String authResult;
//  UserRegBloc userRegBloc;
//  UserRepository userRepository;
//
//  SGSignUpScreen({this.userRepository});
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        flexibleSpace: Image(
//          image: AssetImage('assets/theme_bg.png'),
//          fit: BoxFit.cover,
//        ),
//        backgroundColor: Colors.transparent,
//        leading: new IconButton(
//          icon: new Icon(Icons.arrow_back, color: Colors.white),
//          onPressed: () => Navigator.of(context).pop(),
//        ),
//        centerTitle: true,
//      ),
//      body: Container(
//        height: double.infinity,
//        decoration: new BoxDecoration(
//          image: new DecorationImage(
//            image: new AssetImage("assets/theme_bg.png"),
//            fit: BoxFit.cover,
//          ),
//        ),
//        child: SingleChildScrollView(
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            children: <Widget>[
//              Container(
//                padding: EdgeInsets.all(5.0),
//                child: BlocListener<UserRegBloc, UserRegState>(
//                  listener: (context, state) {
//                    if (state is UserRegSuccessful) {
//                      navigateToHomePage(context, state.user);
//                    }
//                  },
//                  child: BlocBuilder<UserRegBloc, UserRegState>(
//                    builder: (context, state) {
////                    if (state is UserRegInitial) {
////                      return buildInitialUi();
////                    } else
//                      if (state is UserRegLoading) {
//                        return buildWidget().buildLoadingUi();
//                      } else if (state is UserRegFailure) {
//                        return buildWidget().buildFailureUi(state.message);
//                      } else if (state is UserRegSuccessful) {
//                        _emailController.text = "";
//                        _passwordController.text = "";
//                        return Container();
//                      }
//                      return Container();
//                    },
//                  ),
//                ),
//              ),
////              Container(
////                padding: EdgeInsets.all(5.0),
////                child: TextField(
////                  controller: emailCntrl,
////                  decoration: InputDecoration(
////                    errorStyle: TextStyle(color: Colors.white),
////                    filled: true,
////                    fillColor: Colors.white,
////                    border: OutlineInputBorder(),
////                    labelText: "E-mail",
////                    hintText: "E-mail",
////                  ),
////                  keyboardType: TextInputType.emailAddress,
////                ),
////              ),
////              Container(
////                padding: EdgeInsets.all(5.0),
////                child: TextField(
////                  controller: passCntrlr,
////                  decoration: InputDecoration(
////                    errorStyle: TextStyle(color: Colors.white),
////                    filled: true,
////                    fillColor: Colors.white,
////                    border: OutlineInputBorder(),
////                    labelText: "Password",
////                    hintText: "Password",
////                  ),
////                  keyboardType: TextInputType.visiblePassword,
////                ),
////              ),
////              Row(
////                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
////                children: <Widget>[
////                  Container(
////                    child: RaisedButton(
////                      color: Colors.cyan,
////                      child: Text("Sign Up"),
////                      textColor: Colors.white,
////                      onPressed: () {
////                        userRegBloc.add(SignUpButtonPressed(
////                            email: emailCntrl.text, password: passCntrlr.text));
////                      },
////                    ),
////                  ),
////                  Container(
////                    child: RaisedButton(
////                      color: Colors.cyan,
////                      child: Text("Login Now"),
////                      textColor: Colors.white,
////                      onPressed: () {
////                        navigateToLoginPage(context);
////                      },
////                    ),
////                  ),
////                ],
////              ),
//              _registerForm(context)
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//
//  // <editor-fold desc=" Registration form UI">
//
//  Widget _registerForm(BuildContext context) {
//    return Padding(
//      padding: EdgeInsets.all(20),
//      child: Form(
//        child: ListView(
//          physics: ClampingScrollPhysics(),
//          children: <Widget>[
//            Container(
//              child: Row(
//                crossAxisAlignment: CrossAxisAlignment.center,
//                mainAxisAlignment: MainAxisAlignment.start,
//                children: <Widget>[
//                  new IconButton(
//                    icon:
//                        new Icon(Icons.arrow_back_ios, color: AppColors.white),
//                    onPressed: () => Navigator.of(context).pop(),
//                  ),
//                ],
//              ),
//            ),
//            Padding(
//              padding: EdgeInsets.all(20),
//              child: Image.asset("assets/tutorial_logo.png"),
//            ),
//            SizedBox(
//              height: 30,
//            ),
//            Card(
//              color: Colors.white12,
//              child: Padding(
//                padding: const EdgeInsets.all(15.0),
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  crossAxisAlignment: CrossAxisAlignment.stretch,
//                  children: <Widget>[
//                    TextFormField(
//                      focusNode: _nameFocus,
//                      onFieldSubmitted: (term) {
//                        generic.fieldFocusChange(
//                            context, _nameFocus, _emailFocus);
//                      },
//                      style: TextStyle(color: AppColors.white),
//                      controller: _nameController,
//                      decoration: InputDecoration(
//                        labelText: 'Name',
//                        labelStyle: TextStyle(color: AppColors.white),
//                        enabledBorder: UnderlineInputBorder(
//                          borderSide: BorderSide(color: Colors.white54),
//                        ),
//                        focusedBorder: UnderlineInputBorder(
//                          borderSide: BorderSide(color: Colors.white54),
//                        ),
//                        border: UnderlineInputBorder(
//                            borderSide: BorderSide(color: Colors.white54)),
//                      ),
//                      autovalidate: false,
//                      autocorrect: false,
//                      validator: (value) {
//                        if (!validator.name(value) && value.isNotEmpty) {
//                          return 'Please enter valid name';
//                        }
//                        return null;
//                      },
//                    ),
//                    TextFormField(
//                        focusNode: _emailFocus,
//                        onFieldSubmitted: (term) {
//                          generic.fieldFocusChange(
//                              context, _emailFocus, _passwordFocus);
//                        },
//                        style: TextStyle(color: AppColors.white),
//                        controller: _emailController,
//                        decoration: InputDecoration(
//                          labelText: 'Email Address',
//                          labelStyle: TextStyle(color: AppColors.white),
//                          enabledBorder: UnderlineInputBorder(
//                            borderSide: BorderSide(color: Colors.white54),
//                          ),
//                          focusedBorder: UnderlineInputBorder(
//                            borderSide: BorderSide(color: Colors.white54),
//                          ),
//                          border: UnderlineInputBorder(
//                              borderSide: BorderSide(color: Colors.white54)),
//                        ),
//                        autovalidate: true,
//                        autocorrect: false,
//                        validator: (value) {
//                          if (!validator.email(value) && value.isNotEmpty) {
//                            return 'Please enter valid email address';
//                          }
//                          return null;
//                        }),
//                    TextFormField(
//                        focusNode: _passwordFocus,
//                        onFieldSubmitted: (term) {
//                          generic.fieldFocusChange(
//                              context, _passwordFocus, _confirmPasswordFocus);
//                        },
//                        style: TextStyle(color: AppColors.white),
//                        controller: _passwordController,
//                        decoration: InputDecoration(
//                          labelText: 'Password',
//                          labelStyle: TextStyle(color: AppColors.white),
//                          enabledBorder: UnderlineInputBorder(
//                            borderSide: BorderSide(color: Colors.white54),
//                          ),
//                          focusedBorder: UnderlineInputBorder(
//                            borderSide: BorderSide(color: Colors.white54),
//                          ),
//                          border: UnderlineInputBorder(
//                              borderSide: BorderSide(color: Colors.white54)),
//                        ),
//                        obscureText: true,
//                        autovalidate: true,
//                        autocorrect: false,
//                        validator: (value) {
//                          if (!validator.password(value) && value.isNotEmpty) {
//                            return 'Enter valid password';
//                          }
//                          return null;
//                        }),
//                    TextFormField(
//                        focusNode: _confirmPasswordFocus,
//                        onFieldSubmitted: (term) {
//                          _confirmPasswordFocus.unfocus();
//                        },
//                        style: TextStyle(color: AppColors.white),
//                        controller: _confirmPasswordController,
//                        decoration: InputDecoration(
//                          labelText: 'Confirm Password',
//                          labelStyle: TextStyle(color: AppColors.white),
//                          enabledBorder: UnderlineInputBorder(
//                            borderSide: BorderSide(color: Colors.white54),
//                          ),
//                          focusedBorder: UnderlineInputBorder(
//                            borderSide: BorderSide(color: Colors.white54),
//                          ),
//                          border: UnderlineInputBorder(
//                              borderSide: BorderSide(color: Colors.white54)),
//                        ),
//                        obscureText: true,
//                        autovalidate: true,
//                        autocorrect: false,
//                        validator: (value) {
//                          print(value);
//                          if (!validator.password(value) && value.isNotEmpty) {
//                            return 'Enter valid password';
//                          }
//                          return null;
//                        }),
//                    SizedBox(
//                      height: 10,
//                    ),
//                    Container(
//                      height: 50,
//                      child: FlatButton(
//                        shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(30.0),
//                        ),
//                        color: Colors.white12,
//                        child: Text('SIGN UP',
//                            style: TextStyle(color: AppColors.white)),
//                        onPressed: () {
//                          if (_nameController.text.isEmpty ||
//                              _emailController.text.isEmpty ||
//                              _passwordController.text.isEmpty ||
//                              _confirmPasswordController.text.isEmpty) {
//                            generic.alertDialog(context, "Missing Fields",
//                                "Please fill all the fields", () {});
//                          } else if (_passwordController.text !=
//                              _confirmPasswordController.text) {
//                            generic.alertDialog(
//                                context,
//                                "Password doesn't match",
//                                "Please enter same password",
//                                () {});
//                          } else if (validator.email(_emailController.text) &&
//                              validator.password(_passwordController.text) &&
//                              validator
//                                  .password(_confirmPasswordController.text)) {
//                            userRegBloc.add(SignUpButtonPressed(
//                                email: _emailController.text,
//                                password: _confirmPasswordController.text,
//                                name: _nameController.text));
//                          }
//                        },
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
//  // </editor-fold>
//  void navigateToHomePage(BuildContext context, FirebaseUser user) {
//    Navigator.push(context, MaterialPageRoute(builder: (context) {
//      return HomePageParent(user: user, userRepository: userRepository);
//    }));
//  }
//
//  void navigateToLoginPage(BuildContext context) {
//    Navigator.push(context, MaterialPageRoute(builder: (context) {
//      return LoginPageParent(userRepository: userRepository);
//    }));
//  }
//
//  // <editor-fold desc=" Network - call ">
//
//  /* _onSubmit() async {
//    Dialogs.showLoadingDialog(context, generic.keys());
//    generic.unFocus(context);
//    SignUpRequest request = SignUpRequest(
//        email: _emailController.text,
//        password: _passwordController.text,
//        confirmPassword: _confirmPasswordController.text,
//        name: _nameController.text);
//    await ApiBaseHelper().userSignUp(request).then((response) {
//      Navigator.of(generic.keys().currentContext, rootNavigator: true).pop();
//      if (response.status == 1) {
//        preference.setLoginState(true);
//        preference.sharedPreferencesSet("token", response.token);
//        preference.saveModel('user', response.userData);
//        User.shared.user = response.userData;
//        User.shared.planStatus = response.userData.planId == 1 ? false : true;
//
//        Navigator.of(context).push(
//          MaterialPageRoute(builder: (_) => OnBoardingPage()),
//        );
//      } else {
//        generic.alertDialog(context, 'Alert', response.error, () {});
//      }
//    });
//  }*/
//
//// </editor-fold>
//}
