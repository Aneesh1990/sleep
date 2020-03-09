import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleep_giant/APIModels/all_programs_list_response.dart';
import 'package:sleep_giant/Screens/Register/signup_page.dart';
import 'package:sleep_giant/Screens/Settings/settings.dart';
import 'package:sleep_giant/Screens/Side_Menu/app_info.dart';
import 'package:sleep_giant/Screens/Side_Menu/info_screen.dart';
import 'package:sleep_giant/Screens/Side_Menu/purchase_screen.dart';
import 'package:sleep_giant/Screens/notificationScreen.dart';
import 'package:sleep_giant/Style/colors.dart';
import 'package:sleep_giant/blocs/homeBloc/home_page_bloc.dart';
import 'package:sleep_giant/blocs/homeBloc/home_page_event.dart';
import 'package:sleep_giant/data/song_data.dart';
import 'package:sleep_giant/repositories/user_repository.dart';

import '../music_list.dart';

class HomePageParent extends StatelessWidget {
  FirebaseUser user;
  UserRepository userRepository;

  HomePageParent({@required this.user, @required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomePageBloc(userRepository: userRepository),
      child: HomeScreen(user: user, userRepository: userRepository),
    );
  }
}

class HomeScreen extends StatelessWidget {
  AllProgramsResponse allPrograms;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  FirebaseUser user;
  HomePageBloc homePageBloc;
  UserRepository userRepository;
  List<MusicFile> musicList;

  HomeScreen({@required this.user, @required this.userRepository});

  /*Future getPaymentStatus() async {
    return await preference.getPaymentState();
  }

  Future getUser() async {
    return await preference.readUserModel("user");
  }

  // <editor-fold desc=" Network call ">
  getAllPrograms() async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    await ApiBaseHelper().getAllPrograms().then((response) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      if (response.status == 1) {
        print(response.toJson());
        allPrograms = response;
      } else {
        generic.alertDialog(context, 'Alert', "Something went wrong", () {});
      }
    });
  }*/
  // </editor-fold>

  /*// <editor-fold desc="Get all program ">
  getAllProgramsRequestSend() async {
    await Future.delayed(const Duration(seconds: 1), () {
      getAllPrograms();
    });
  }
  // </editor-fold>*/

  Future<void> getData() async {
    var postItemdz =
        await Firestore.instance.collection('music').getDocuments();

    musicList = postItemdz.documents.map((snapshot) {
      return MusicFile.fromSnapshot(snapshot);
    }).toList();

    print(musicList);
//    print(musicList[0].program[0].name);
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    homePageBloc = BlocProvider.of<HomePageBloc>(context);

    getData();

//    var goalsList = homePageBloc.getSleepDeck(user.uid);
//    print(goalsList);

    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.3),
        child: new AppBar(
          flexibleSpace: AspectRatio(
            aspectRatio: 1,
            child: Image(
              image: AssetImage('assets/home_bg.png'),
              fit: BoxFit.fill,
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
      body: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [Color(0xFF080808), Color(0xFF190060)],
                begin: const FractionalOffset(0.0, 0.5),
                end: const FractionalOffset(0.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: GridView(
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(
                      left: 50.0, right: 50.0, top: 10, bottom: 10),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      childAspectRatio: 1.0),
                  children: <Widget>[
                    buildMenuItem(context, [Colors.greenAccent, Colors.green],
                        () {
//                      homePageBloc.add(WindDownEvent(context, ['', '']));
                      navigateToMusicList(context, "Wind Down", 1);
                    },
                        new Icon(
                          Icons.trending_down,
                          color: Colors.white,
                        ),
                        'Wind Down'),
                    buildMenuItem(context, [Colors.blue, Colors.blueAccent],
                        () {
//                      homePageBloc.add(SleepDeepEvent(context, ['', '']));
                      navigateToMusicList(context, 'Sleep Deep', 3);
                    },
                        new Icon(
                          Icons.airline_seat_individual_suite,
                          color: Colors.white,
                        ),
                        'Sleep Deep'),
                    buildMenuItem(context, [Colors.cyan, Colors.cyanAccent],
                        () {
                      navigateToMusicList(context, 'Nap Recovery', 2);
                    },
                        new Icon(
                          Icons.airline_seat_flat_angled,
                          color: Colors.white,
                        ),
                        'Nap Recovery'),
                    buildMenuItem(context, [Colors.yellow, Colors.yellowAccent],
                        () {
                      navigateToMusicList(context, 'Wake Up', 0);
                    },
                        new Icon(
                          Icons.add_alarm,
                          color: Colors.white,
                        ),
                        'Wake Up')
                  ],
                ),
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Color.fromRGBO(194, 45, 255, 1),
                child: Text('Go to Sleep Deck',
                    style: TextStyle(color: AppColors.white)),
                onPressed: () {
                  homePageBloc.add(NavigateSleepDeck(context, musicList, user));
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FloatingActionButton(
                    child: Image.asset('assets/torch.png'),
                    backgroundColor: Colors.transparent,
                  ),
                ],
              ),
            ],
          )),
      endDrawer: buildDrawer(context),
    ));
  }

  // <editor-fold desc=" Drawer building">
  buildDrawer(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("assets/theme_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              CircleAvatar(
                radius: 30.0,
                backgroundImage:
                    NetworkImage('https://via.placeholder.com/150'),
                backgroundColor: Colors.transparent,
              ),
              Expanded(
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: <Widget>[
//                    ListTile(
//                      title: Image.network(
//                        'https://upload.wikimedia.org/wikipedia/en/b/b1/Portrait_placeholder.png',
//                        width: 100,
//                        height: 100,
//                      ),
//                      onTap: () {
//                        // Update the state of the app
//                        // ...
//                        // Then close the drawer
//                        Navigator.pop(context);
//                      },
//                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      title: FutureBuilder(
                          future: getUser(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.requireData.email ?? "sample",
                                style: TextStyle(color: AppColors.white),
                              );
                            } else {
                              return Text('');
                            }
                          }),
                      onTap: () {
                        // Update the state of the app
                        // ...
                        // Then close the drawer
                        Navigator.pop(context);
                      },
                    ),
                    FutureBuilder(
                        future: getPaymentStatus(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              color: Colors.white12,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Become Premium Member',
                                    style: TextStyle(color: AppColors.white),
                                  ),
                                  FlatButton(
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(18.0),
                                        side:
                                            BorderSide(color: AppColors.white)),
                                    color: Colors.transparent,
                                    textColor: AppColors.white,
                                    padding: EdgeInsets.all(8.0),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                          return PurchaseScreen();
                                        }),
                                      );
                                    },
                                    child: Text(
                                      "Upgrade",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }),
                    ListTile(
                      title: Text('Home',
                          style: TextStyle(color: AppColors.white)),
                      onTap: () {
                        // Update the state of the app
                        // ...
                        // Then close the drawer
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text('Take a tour',
                          style: TextStyle(color: AppColors.white)),
                      onTap: () {
                        // Update the state of the app
                        // ...
                        // Then close the drawer
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return OnBoardingPage();
                          }),
                        );
                      },
                    ),
                    ListTile(
                      title: Text('Sleepfit Coaching Course',
                          style: TextStyle(color: AppColors.white)),
                      onTap: () {
                        // Update the state of the app
                        // ...
                        // Then close the drawer
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text('App info',
                          style: TextStyle(color: AppColors.white)),
                      onTap: () {
                        // Update the state of the app
                        // ...
                        // Then close the drawer
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return AppInfo();
                          }),
                        );
                      },
                    ),
                    ListTile(
                      title: Text('Notifications',
                          style: TextStyle(color: AppColors.white)),
                      onTap: () {
                        // Update the state of the app
                        // ...
                        // Then close the drawer
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return NotificationScreen();
                          }),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Divider(
                    color: AppColors.white,
                    thickness: 1,
                  ),
                  ListTile(
                    title: Text('Settings',
                        style: TextStyle(color: AppColors.white)),
                    onTap: () {
                      // Update the state of the app
                      // ...
                      // Then close the drawer
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return Settings();
                        }),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Logout',
                        style: TextStyle(color: AppColors.white)),
                    onTap: () {
                      // Update the state of the app
                      // ...
                      // Then close the drawer
                      Navigator.pop(context);
                      userRepository.firebaseAuth.signOut();

//                      preference.setLoginState(false);
//                      preference.sharedPreferencesSet("token", "");
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/root', (Route<dynamic> route) => false);
                    },
                  ),
                ],
              )
            ],
          )),
    );
  }

  // <editor-fold desc=" Build MenuItem">
  InkWell buildMenuItem(BuildContext context, List<Color> colors,
      Function navigate, Icon icon, String name) {
    return InkWell(
      child: Container(
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          gradient: new LinearGradient(
              colors: colors,
              begin: const FractionalOffset(0.0, 0.5),
              end: const FractionalOffset(0.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        width: MediaQuery.of(context).size.width / 3,
        height: MediaQuery.of(context).size.width / 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: icon,
              tooltip: 'Favorite',
              onPressed: () {
                navigate();
              },
            ),
            Text(
              name,
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
      onTap: navigate,
    );
  }

  getPaymentStatus() {}
  getUser() {}
// </editor-fold>
// </editor-fold>

  void navigateToSignUpPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return SignUpPageParent(userRepository: userRepository);
    }));
  }

  void navigateToWindDown(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return SignUpPageParent(userRepository: userRepository);
    }));
  }

  void navigateToSleepDeep(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return SignUpPageParent(userRepository: userRepository);
    }));
  }

  void navigateToNapRecovery(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return SignUpPageParent(userRepository: userRepository);
    }));
  }

  void navigateToMusicList(BuildContext context, String heading, int index) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return MusicListParent(
        userRepository: userRepository,
        snapshot: musicList[index],
        programTypeHeader: heading,
      );
    }));
  }

  void navigateToWakeUp(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return SignUpPageParent(userRepository: userRepository);
    }));
  }
}

enum Music { windDown, wakeUp, napRecovery, sleepDeep }
