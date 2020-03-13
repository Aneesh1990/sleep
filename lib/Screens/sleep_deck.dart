import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleep_giant/APIModels/all_programs_list_response.dart';
import 'package:sleep_giant/APIModels/sleep_deck_model.dart';
import 'package:sleep_giant/Generic/generic_helper.dart';
import 'package:sleep_giant/Screens/now_playing.dart';
import 'package:sleep_giant/Style/colors.dart';
import 'package:sleep_giant/blocs/deckBloc/sleep_deck_bloc.dart';
import 'package:sleep_giant/data/song_data.dart';
import 'package:sleep_giant/repositories/user_repository.dart';

class SleepDeckParent extends StatelessWidget {
  UserRepository userRepository;
  // ignore: close_sinks
//  SleepDeckBloc sleepDeckBloc;
  List<MusicFile> musicList;

  FirebaseUser user;

  SleepDeckParent({@required this.userRepository, this.musicList, this.user});

  @override
  Widget build(BuildContext context) {
//    sleepDeckBloc = BlocProvider.of<SleepDeckBloc>(context);
    return BlocProvider(
      create: (context) => SleepDeckBloc(userRepository: userRepository),
      child: SleepDeck(
        userRepository: userRepository,
        musicList: musicList,
        user: user,
      ),
    );
  }
}

class SleepDeck extends StatefulWidget {
  UserRepository userRepository;
  List<MusicFile> musicList;
  SleepDeckData sleepDecks;
  FirebaseUser user;
  SleepDeckBloc sleepDeckBloc;

  SleepDeck(
      {Key key,
      this.userRepository,
      this.musicList,
      this.user,
      this.sleepDeckBloc})
      : super(key: key);
  @override
  _SleepDeckState createState() => _SleepDeckState();
}

class _SleepDeckState extends State<SleepDeck> {
  Random random = new Random();
  PersistentBottomSheetController _controller;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int sleepDeepRepeat = 0;
  SleepDeckModel sleepDeckModel = SleepDeckModel();
  CrossAxisAlignment cross = CrossAxisAlignment.center;
  MainAxisAlignment main = MainAxisAlignment.center;
  final TextEditingController _emailController = TextEditingController();
  bool showFab = true;

  // <editor-fold desc=" Net work - calls  ">

  Future<void> getData() async {
    var postItemdz = await Firestore.instance
        .collection('users')
        .document(widget.user.uid)
        .get();

    setState(() {
      widget.sleepDecks = SleepDeckData.fromSnapshot(postItemdz);
    });

//    print(widget.sleepDecks.decks[0].program[0].name);
//      print(widget.sleepDecks.decks[0].name);
  }

  // </editor-fold>

  Future<void> saveData(DeckData data) async {
    DocumentSnapshot doc = await Firestore.instance
        .collection("users")
        .document(widget.user.uid)
        .get();

    SleepDeckData goals = SleepDeckData.fromSnapshot(doc);

    goals.decks.add(data);

    List<Map> list = new List();
    if (data != null && goals.decks.isNotEmpty) {
      goals.decks.forEach((grp) {
        list.add(grp.toJson());
      });
    }

    return Firestore.instance
        .collection("users")
        .document(widget.user.uid)
        .updateData({
      'sleep_deck': FieldValue.arrayUnion(list),
      'sleep_deck_added': true
    });
  }

  Future<void> deleteData(DeckData data) async {
    DocumentSnapshot doc = await Firestore.instance
        .collection("users")
        .document(widget.user.uid)
        .get();

    SleepDeckData goals = SleepDeckData.fromSnapshot(doc);

    List<Map> list = new List();
    if (goals.decks.isNotEmpty) {
      goals.decks.forEach((grp) {
        grp.id != data.id ? null : list.add(grp.toJson());
      });
    }
    if (list.isNotEmpty) {
      return Firestore.instance
          .collection("users")
          .document(widget.user.uid)
          .updateData({
        'sleep_deck': FieldValue.arrayRemove(list),
      });
    } else {
      return Firestore.instance
          .collection("users")
          .document(widget.user.uid)
          .updateData({'sleep_deck': [], 'sleep_deck_added': false});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.primary_color,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 80,
                child: Image.asset("assets/header.png"),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: new IconButton(
                  icon: new Icon(Icons.arrow_back_ios, color: AppColors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: cross,
                mainAxisAlignment: main,
                children: <Widget>[
                  Text(
                    'Sleep Time',
                    style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    sleepDeckModel.isYourSleepDeckSelected
                        ? getTotalDuration(sleepDeckModel.yourDecks.program) +
                            ' hours'
                        : getFormattedTime(sleepDeckModel.totalDuration) +
                            ' hours',
                    style: TextStyle(
                        color: AppColors.white, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: main,
                crossAxisAlignment: cross,
                children: <Widget>[
                  Text(
                    'Wake Up Target',
                    style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    generic.getWakeUpTargetTime(
                        sleepDeckModel.isYourSleepDeckSelected
                            ? getTotalDurationTopHeader(
                                sleepDeckModel.yourDecks.program)
                            : sleepDeckModel.totalDuration),
                    style: TextStyle(
                        color: AppColors.white, fontStyle: FontStyle.italic),
                  ),
                ],
              )
            ],
          ),
          Divider(),
          Text(
            'your sleep sequence',
            style: TextStyle(color: AppColors.white),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: sleepDeckModel.isYourSleepDeckSelected
                  ? getSleepSequenceTopSaved(sleepDeckModel.yourDecks)
                  : getSleepSequence(sleepDeckModel),
            ),
          ),
          Divider(),
          Expanded(
            child: widget.musicList.isNotEmpty
                ? ListView(
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.all(0.0),
                    children: <Widget>[
                      Container(
                        child: windDown(),
                        color: AppColors.primary_color,
                      ),
                      Container(
                        child: sleepDeep(),
                        color: AppColors.primary_color,
                      ),
                      Container(
                        child: napRecovery(),
                        color: AppColors.primary_color,
                      ),
                      Container(
                        child: wakeUp(),
                        color: AppColors.primary_color,
                      ),
                      Container(
                        child: sleepDeck(),
                        color: AppColors.primary_color,
                      ),
                    ],
                  )
                : Container(),
          ),
          buildSaveDeck(context)
        ],
      ),
    ));
  }

  Container buildSaveDeck(BuildContext context) {
    return Container(
      height: 80,
      color: Colors.indigo,
      child: Stack(
        children: <Widget>[
          Center(
            child: RaisedButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.transparent)),
              onPressed: () async {
                print("audio clicked");

                if (sleepDeckModel.isWindDownSelected ||
                    sleepDeckModel.isSleepDeepSelected ||
                    sleepDeckModel.isNapRecoverySelected ||
                    sleepDeckModel.isWakeUpSelected ||
                    sleepDeckModel.isYourSleepDeckSelected) {
                } else {
                  generic.alertDialog(context, "Alert",
                      "Please choose atleast 1 program", () {});
                  return;
                }

                if (sleepDeckModel.isYourSleepDeckSelected) {
                  SongData songs = SongData(
                    songs: sleepDeckModel.yourDecks.program,
                  );

                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new NowPlaying(
                              true,
                              songs,
                              songs.songs[0],
                              MusicFile(_emailController.text,
                                  sleepDeckModel.yourDecks.program),
                              0)));

                  return;
                }

                List<String> audios = [];
                List<Program> decks = [];
                CoverImage coverImage;
                String programTypeId;
                String sound;
                int themeId;
                int duration;
                if (sleepDeckModel.isWindDownSelected) {
                  audios.add(sleepDeckModel.windDownProgram.songPath);
                  decks.add(Program(
                    id: 1,
                    name: sleepDeckModel.windDownProgram.name,
                    avatar: sleepDeckModel.windDownProgram.avatar,
                    songPath: sleepDeckModel.windDownProgram.songPath,
                    duration: sleepDeckModel.windDownProgram.duration,
                    songToken: sleepDeckModel.windDownProgram.songToken,
                    avatarToken: sleepDeckModel.windDownProgram.avatarToken,
                  ));
                }
                if (sleepDeckModel.isSleepDeepSelected) {
                  for (var i = 0; i < sleepDeckModel.sleepDeepCount; i++) {
                    audios.add(sleepDeckModel.sleepDeepProgram.songPath);
                    decks.add(Program(
                      id: 2,
                      name: sleepDeckModel.sleepDeepProgram.name,
                      avatar: sleepDeckModel.sleepDeepProgram.avatar,
                      songPath: sleepDeckModel.sleepDeepProgram.songPath,
                      duration: sleepDeckModel.sleepDeepProgram.duration,
                      songToken: sleepDeckModel.sleepDeepProgram.songToken,
                      avatarToken: sleepDeckModel.sleepDeepProgram.avatarToken,
                    ));
                  }
                }
                if (sleepDeckModel.isNapRecoverySelected) {
                  audios.add(sleepDeckModel.napRecoveryProgram.songPath);
                  decks.add(Program(
                    id: 3,
                    name: sleepDeckModel.napRecoveryProgram.name,
                    avatar: sleepDeckModel.napRecoveryProgram.avatar,
                    songPath: sleepDeckModel.napRecoveryProgram.songPath,
                    duration: sleepDeckModel.napRecoveryProgram.duration,
                    songToken: sleepDeckModel.napRecoveryProgram.songToken,
                    avatarToken: sleepDeckModel.napRecoveryProgram.avatarToken,
                  ));
                }

                if (sleepDeckModel.isWakeUpSelected) {
                  audios.add(sleepDeckModel.wakeUpProgram.songPath);
                  decks.add(Program(
                    id: 4,
                    name: sleepDeckModel.wakeUpProgram.name,
                    avatar: sleepDeckModel.wakeUpProgram.avatar,
                    songPath: sleepDeckModel.wakeUpProgram.songPath,
                    duration: sleepDeckModel.wakeUpProgram.duration,
                    songToken: sleepDeckModel.wakeUpProgram.songToken,
                    avatarToken: sleepDeckModel.wakeUpProgram.avatarToken,
                  ));
                }

                showDeckSaveSheet(decks);
              },
              color: AppColors.your_sleep_deck_color_button,
              textColor: AppColors.white,
              child:
                  Text("Load your Sleep Deck", style: TextStyle(fontSize: 14)),
            ),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              child: InkWell(
                child: Image.asset("assets/torch.png"),
                onTap: () {},
              ))
        ],
      ),
    );
  }

  // <editor-fold desc=" Creating Expansion tiles">
  ConfigurableExpansionTile sleepDeck() {
    return ConfigurableExpansionTile(
      headerExpanded: tileHeader(HeaderModel([
        AppColors.your_sleep_deck,
        AppColors.your_sleep_deck_dark,
      ], "Your Sleep Decks", "assets/upArrow.png")),
      header: tileHeader(
        HeaderModel([
          AppColors.your_sleep_deck,
          AppColors.your_sleep_deck_dark,
        ], "Your Sleep Decks", "assets/downArrow.png"),
      ),
      children: widget.sleepDecks != null
          ? getSleepSequenceSaved(widget.sleepDecks)
          : [],
    );
  }

  ConfigurableExpansionTile wakeUp() {
    return ConfigurableExpansionTile(
      headerExpanded: tileHeader(
        HeaderModel([
          AppColors.wake_up_color,
          AppColors.wake_up_color_dark,
        ], "Wake Up", "assets/upArrow.png"),
      ),
      //animatedWidgetFollowingHeader: Image.asset('assets/upArrow.png'),
      header: tileHeader(HeaderModel([
        AppColors.wake_up_color,
        AppColors.wake_up_color_dark,
      ], "Wake Up", "assets/downArrow.png")),

      children: getWakeUpWidgets(widget.musicList[0].program),
    );
  }

  ConfigurableExpansionTile napRecovery() {
    return ConfigurableExpansionTile(
      headerExpanded: tileHeader(
        HeaderModel([
          AppColors.nap_recovery_colors,
          AppColors.nap_recovery_color,
        ], "Nap Recovery", "assets/upArrow.png"),
      ),
      //animatedWidgetFollowingHeader: Image.asset('assets/upArrow.png'),
      header: tileHeader(HeaderModel([
        AppColors.nap_recovery_colors,
        AppColors.nap_recovery_color,
      ], "Nap Recovery", "assets/downArrow.png")),

      children: getNapRecoveryWidgets(widget.musicList[2].program),
    );
  }

  ConfigurableExpansionTile sleepDeep() {
    return ConfigurableExpansionTile(
      headerExpanded: tileHeader(
        HeaderModel([
          AppColors.sleep_deep_color_dark,
          AppColors.sleep_deep_color,
        ], "Sleep Deep", "assets/upArrow.png"),
      ),
      //animatedWidgetFollowingHeader: Image.asset('assets/upArrow.png'),
      header: tileHeader(HeaderModel([
        AppColors.sleep_deep_color_dark,
        AppColors.sleep_deep_color,
      ], "Sleep Deep", "assets/downArrow.png")),
      children: getSleepDeepWidgets(widget.musicList[3].program),
    );
  }

  ConfigurableExpansionTile windDown() {
    return ConfigurableExpansionTile(
      headerExpanded: tileHeader(
        HeaderModel([
          Colors.green,
          AppColors.wind_down_color_dark,
        ], "Wind Down", "assets/upArrow.png"),
      ),
      //animatedWidgetFollowingHeader: Image.asset('assets/upArrow.png'),
      header: tileHeader(HeaderModel([
        Colors.green,
        AppColors.wind_down_color_dark,
      ], "Wind Down", "assets/downArrow.png")),
      children: getWindDownWidgets(widget.musicList[1].program),
    );
  }
  // </editor-fold>

  // <editor-fold desc=" Create wind down list and selection handler ">
  List<Widget> getWindDownWidgets(List<Program> programs) {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < programs.length; i++) {
      list.add(Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Container(
          height: AppSize.itemSize,
          color: AppColors.wind_down_color,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              InkWell(
                child: new Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: new BoxDecoration(
                        border:
                            sleepDeckModel.selectedWindDown != programs[i].id
                                ? Border.all(color: Colors.transparent)
                                : Border.all(color: Colors.green, width: 3),
                        shape: BoxShape.rectangle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage(generic.getImageName(
                                programs[i].avatar,
                                programs[i].avatarToken))))),
                onTap: () {
                  _showDetailScreen(programs[i], 'Wind Down', [
                    Colors.green,
                    AppColors.wind_down_color_dark,
                  ]);
                },
              ),
              IconButton(
                icon: Icon(
                  sleepDeckModel.selectedWindDown != programs[i].id
                      ? Icons.check_box_outline_blank
                      : Icons.check_box,
                  color: AppColors.white,
                ),
                onPressed: () {
                  setState(() {
                    windDownEventHandle(programs, i);
                  });
                },
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      programs[i].name,
                      style: TextStyle(color: AppColors.white),
                    ),
                    Text(
                      "Duration: " + getFormattedTime(programs[i].duration),
                      style: TextStyle(color: AppColors.white),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ));
    }
    return list;
  }

  void windDownEventHandle(List<Program> programs, int i) {
    if (sleepDeckModel.selectedWindDown == programs[i].id) {
      sleepDeckModel.totalDuration =
          sleepDeckModel.totalDuration - programs[i].duration;
      sleepDeckModel.selectedWindDown = 0;
      sleepDeckModel.isWindDownSelected = false;
      sleepDeckModel.windDownCount = 0;
      sleepDeckModel.windDownAudio = "";
//      sleepDeckModel.windDownProgram = Program();
    } else {
      sleepDeckModel.isYourSleepDeckSelected = false;
      sleepDeckModel.selectedYourSleepDeck = 0;
      sleepDeckModel.totalDuration = sleepDeckModel.isWindDownSelected
          ? programs[i].duration
          : sleepDeckModel.totalDuration + programs[i].duration;
      sleepDeckModel.selectedWindDown = programs[i].id;
      sleepDeckModel.isWindDownSelected = true;
      sleepDeckModel.windDownCount = 1;
      sleepDeckModel.windDownAudio = programs[i].songPath;
      sleepDeckModel.windDownProgram = programs[i];
    }
  }
  // </editor-fold>

  // <editor-fold desc=" Create Sleep Deep list and selection handler ">
  List<Widget> getSleepDeepWidgets(List<Program> programs) {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < programs.length; i++) {
      list.add(Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Container(
          height: AppSize.itemSize,
          color: AppColors.sleep_deep_color,
          child: Stack(
            children: <Widget>[
              Center(
                  child: Image.asset(
                'assets/sleep_deep_bg.png',
                scale: 1.1,
              )),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      _showDetailScreen(programs[i], 'Sleep Deep', [
                        AppColors.sleep_deep_color_dark,
                        AppColors.sleep_deep_color,
                      ]);
                    },
                    child: new Container(
                        width: 75.0,
                        height: 75.0,
                        decoration: new BoxDecoration(
                            border: sleepDeckModel.selectedSleepDeep !=
                                    programs[i].id
                                ? Border.all(color: Colors.transparent)
                                : Border.all(color: Colors.green, width: 3),
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(generic.getImageName(
                                    programs[i].avatar,
                                    programs[i].avatarToken))))),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 120,
                        child: Text(
                          programs[i].name,
                          style: TextStyle(color: AppColors.white),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        crossAxisAlignment: cross,
                        mainAxisAlignment: main,
                        children: <Widget>[
                          Image.asset('assets/Polygon_left.png'),
                          InkWell(
                            child: Image.asset('assets/minus.png'),
                            onTap: () {
                              print('-');
                              setState(() {
                                sleepDeckModel.sleepDeepCount =
                                    sleepDeckModel.sleepDeepCount - 1 <= 0
                                        ? 0
                                        : sleepDeckModel.sleepDeepCount - 1;
                                print(sleepDeckModel.sleepDeepCount);
                                if (sleepDeckModel.sleepDeepCount == 0) {
                                  if (sleepDeckModel.isSleepDeepSelected) {
                                    sleepDeckModel.totalDuration =
                                        sleepDeckModel.totalDuration -
                                            programs[i].duration;
                                  }
                                  sleepDeckModel.selectedSleepDeep = 0;
                                  sleepDeckModel.isSleepDeepSelected = false;
                                  sleepDeckModel.sleepDeepAudio = "";
                                  // sleepDeckModel.sleepDeepProgram = Program();
                                } else {
                                  if (sleepDeckModel.isSleepDeepSelected) {
                                    sleepDeckModel.totalDuration =
                                        sleepDeckModel.totalDuration -
                                            programs[i].duration;
                                  }
                                }
                              });
                            },
                          ),
                          InkWell(
                            child: Image.asset('assets/plus.png'),
                            onTap: () {
                              setState(() {
                                sleepDeepEventHandle(programs, i);
                              });
                            },
                          ),
                          Image.asset('assets/Polygon_right.png'),
                        ],
                      )
                    ],
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      new Container(
                          width: 75.0,
                          height: 75.0,
                          decoration: new BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new NetworkImage(generic.getImageName(
                                      programs[i].avatar,
                                      programs[i].avatarToken))))),
                      Align(
                        child: Text(
                          sleepDeckModel.selectedSleepDeep != programs[i].id
                              ? "0"
                              : sleepDeckModel.sleepDeepCount.toString(),
                          style:
                              TextStyle(color: AppColors.white, fontSize: 30),
                        ),
                        alignment: Alignment.center,
                      )
                    ],
                  )
                ],
              ),
              sleepDeckModel.selectedSleepDeep != programs[i].id &&
                      sleepDeckModel.selectedSleepDeep != 0
                  ? Container(
                      color: Colors.white30,
                    )
                  : Container()
            ],
          ),
        ),
      ));
    }
    return list;
  }

  void sleepDeepEventHandle(List<Program> programs, int i) {
    sleepDeckModel.isYourSleepDeckSelected = false;
    sleepDeckModel.selectedYourSleepDeck = 0;
    print(sleepDeckModel.windDownCount +
        sleepDeckModel.napRecoveryCount +
        sleepDeckModel.wakeUpCount +
        sleepDeckModel.sleepDeepCount);
    if ((sleepDeckModel.windDownCount +
            sleepDeckModel.napRecoveryCount +
            sleepDeckModel.wakeUpCount +
            sleepDeckModel.sleepDeepCount) ==
        9) return;

    sleepDeckModel.totalDuration =
        sleepDeckModel.totalDuration + programs[i].duration;
    sleepDeckModel.selectedSleepDeep = programs[i].id;
    sleepDeckModel.isSleepDeepSelected = true;
    sleepDeckModel.sleepDeepProgram = programs[i];
    sleepDeckModel.sleepDeepAudio = programs[i].songPath;
    if ((sleepDeckModel.windDownCount +
            sleepDeckModel.napRecoveryCount +
            sleepDeckModel.wakeUpCount +
            sleepDeckModel.sleepDeepCount) <
        9) {
      sleepDeckModel.sleepDeepCount = (sleepDeckModel.windDownCount +
                  sleepDeckModel.napRecoveryCount +
                  sleepDeckModel.wakeUpCount +
                  sleepDeckModel.sleepDeepCount) ==
              9
          ? sleepDeckModel.sleepDeepCount
          : sleepDeckModel.sleepDeepCount + 1;
    }
    print('sleepCount');
    print(sleepDeckModel.sleepDeepCount);
  }

  // </editor-fold>

  // <editor-fold desc=" Create Nap Recovery list and selection handler ">
  List<Widget> getNapRecoveryWidgets(List<Program> programs) {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < programs.length; i++) {
      list.add(Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Container(
          height: AppSize.itemSize,
          color: AppColors.nap_recovery_color,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  _showDetailScreen(programs[i], 'Nap Recovery', [
                    AppColors.nap_recovery_colors,
                    AppColors.nap_recovery_color,
                  ]);
                },
                child: new Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: new BoxDecoration(
                        border:
                            sleepDeckModel.selectedNapRecovery != programs[i].id
                                ? Border.all(color: Colors.transparent)
                                : Border.all(color: Colors.green, width: 3),
                        shape: BoxShape.rectangle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage(generic.getImageName(
                                programs[i].avatar,
                                programs[i].avatarToken))))),
              ),
              IconButton(
                icon: Icon(
                  sleepDeckModel.selectedNapRecovery != programs[i].id
                      ? Icons.check_box_outline_blank
                      : Icons.check_box,
                  color: AppColors.white,
                ),
                onPressed: () {
                  setState(() {
                    napRecoveryEventHandle(programs, i);
                  });
                },
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      programs[i].name,
                      style: TextStyle(color: AppColors.white),
                    ),
                    Text(
                      "Duration: " + getFormattedTime(programs[i].duration),
                      style: TextStyle(color: AppColors.white),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ));
    }
    return list;
  }

  void napRecoveryEventHandle(List<Program> programs, int i) {
    if (sleepDeckModel.selectedNapRecovery == programs[i].id) {
      sleepDeckModel.totalDuration =
          sleepDeckModel.totalDuration - programs[i].duration;
      sleepDeckModel.selectedNapRecovery = 0;
      sleepDeckModel.isNapRecoverySelected = false;
      sleepDeckModel.napRecoveryCount = 0;
      sleepDeckModel.napRecoveryAudio = "";
//      sleepDeckModel.napRecoveryProgram = Programs();
    } else {
      sleepDeckModel.isYourSleepDeckSelected = false;
      sleepDeckModel.selectedYourSleepDeck = 0;
      sleepDeckModel.totalDuration = sleepDeckModel.isNapRecoverySelected
          ? programs[i].duration
          : sleepDeckModel.totalDuration + programs[i].duration;
      sleepDeckModel.selectedNapRecovery = programs[i].id;
      sleepDeckModel.isNapRecoverySelected = true;
      sleepDeckModel.napRecoveryCount = 1;
      sleepDeckModel.napRecoveryAudio = programs[i].songPath;
      sleepDeckModel.napRecoveryProgram = programs[i];
    }
  }

  // </editor-fold>

  // <editor-fold desc=" Create Wake Up list and selection handler ">

  List<Widget> getWakeUpWidgets(List<Program> programs) {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < programs.length; i++) {
      list.add(Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Container(
          height: AppSize.itemSize,
          color: AppColors.nap_recovery_color,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              InkWell(
                  onTap: () {
                    _showDetailScreen(programs[i], 'Wake Up', [
                      AppColors.wake_up_color_dark,
                      AppColors.wake_up_color,
                    ]);
                  },
                  child: new Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: new BoxDecoration(
                          border:
                              sleepDeckModel.selectedWakeUp != programs[i].id
                                  ? Border.all(color: Colors.transparent)
                                  : Border.all(color: Colors.green, width: 3),
                          shape: BoxShape.rectangle,
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage(generic.getImageName(
                                  programs[i].avatar,
                                  programs[i].avatarToken)))))),
              IconButton(
                icon: Icon(
                  sleepDeckModel.selectedWakeUp != programs[i].id
                      ? Icons.check_box_outline_blank
                      : Icons.check_box,
                  color: AppColors.white,
                ),
                onPressed: () {
                  setState(() {
                    wakeUpEventHandle(programs, i);
                  });
                },
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      programs[i].name,
                      style: TextStyle(color: AppColors.white),
                    ),
                    Text(
                      "Duration: " + getFormattedTime(programs[i].duration),
                      style: TextStyle(color: AppColors.white),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ));
    }
    return list;
  }

  void wakeUpEventHandle(List<Program> programs, int i) {
    if (sleepDeckModel.selectedWakeUp == programs[i].id) {
      sleepDeckModel.totalDuration =
          sleepDeckModel.totalDuration - programs[i].duration;
      sleepDeckModel.selectedWakeUp = 0;
      sleepDeckModel.isWakeUpSelected = false;
      sleepDeckModel.wakeUpCount = 0;
      sleepDeckModel.wakeUpAudio = "";
//      sleepDeckModel.wakeUpProgram = Programs();
    } else {
      sleepDeckModel.isYourSleepDeckSelected = false;
      sleepDeckModel.selectedYourSleepDeck = 0;
      sleepDeckModel.totalDuration = sleepDeckModel.isWakeUpSelected
          ? sleepDeckModel.totalDuration
          : sleepDeckModel.totalDuration + programs[i].duration;
      sleepDeckModel.selectedWakeUp = programs[i].id;
      sleepDeckModel.isWakeUpSelected = true;
      sleepDeckModel.wakeUpCount = 1;
      sleepDeckModel.wakeUpAudio = programs[i].songPath;
      sleepDeckModel.wakeUpProgram = programs[i];
    }
  }

  // </editor-fold>

  // <editor-fold desc=" Create SleepDeck list and selection handler ">
  List<Widget> getSleepDeckWidgets(List<Decks> programs) {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < programs.length; i++) {
      list.add(Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Container(
          height: AppSize.itemSize,
          color: AppColors.nap_recovery_color,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              new Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: new BoxDecoration(
                      border: sleepDeckModel.selectedWakeUp != programs[i].id
                          ? Border.all(color: Colors.transparent)
                          : Border.all(color: Colors.green, width: 3),
                      shape: BoxShape.rectangle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(
                              programs[i].coverImage.thumbnail)))),
              IconButton(
                icon: Icon(
                  sleepDeckModel.selectedWakeUp != programs[i].id
                      ? Icons.check_box_outline_blank
                      : Icons.check_box,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    if (sleepDeckModel.selectedWakeUp == programs[i].id) {
                      sleepDeckModel.totalDuration =
                          sleepDeckModel.totalDuration - programs[i].duration;
                      sleepDeckModel.selectedWakeUp = 0;
                      sleepDeckModel.isWakeUpSelected = false;
                      sleepDeckModel.wakeUpCount = 0;
                      sleepDeckModel.wakeUpAudio = "";
                    } else {
                      sleepDeckModel.isYourSleepDeckSelected = false;
                      sleepDeckModel.selectedYourSleepDeck = 0;
                      sleepDeckModel.totalDuration = sleepDeckModel
                              .isWakeUpSelected
                          ? sleepDeckModel.totalDuration
                          : sleepDeckModel.totalDuration + programs[i].duration;
                      sleepDeckModel.selectedWakeUp = programs[i].id;
                      sleepDeckModel.isWakeUpSelected = true;
                      sleepDeckModel.wakeUpCount = 1;
//                      sleepDeckModel.wakeUpAudio = programs[i].sound;
                    }
                  });
                },
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      programs[i].name,
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "Duration: " + getFormattedTime(programs[i].duration),
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ));
    }
    return list;
  }
// </editor-fold>

  // <editor-fold desc=" Progress bar widget for saved / sleep deck ">
  List<Widget> getSleepSequenceSaved(SleepDeckData programs) {
    int deckTotalDuration = 0;

    List<Widget> list = new List<Widget>();
    for (var deck in programs.decks) {
      for (var i = 0; i < deck.program.length; i++) {
        deckTotalDuration = deckTotalDuration + deck.program[i].duration;
      }

      List<Widget> listProgress = new List<Widget>();
      List<Color> colorArray = new List<Color>();

      var windDownCount = deck.program.where((program) {
        return program.id == 1;
      });
      var sleepDeepCount = deck.program.where((program) {
        return program.id == 2;
      });
      var wakeUpCount = deck.program.where((program) {
        return program.id == 3;
      });
      var napCount = deck.program.where((program) {
        return program.id == 4;
      });
      if (windDownCount.length > 0) {
        colorArray.add(AppColors.wind_down_color);
      }
      if (sleepDeepCount.length > 0) {
        for (var i = 0; i < sleepDeepCount.length; i++) {
          colorArray.add(AppColors.sleep_deep_color);
        }
      }
      if (napCount.length > 0) {
        colorArray.add(AppColors.nap_recovery_color);
      }
      if (wakeUpCount.length > 0) {
        colorArray.add(AppColors.wake_up_color);
      }

      int rest = 9 - colorArray.length;
      for (var i = 0; i < rest; i++) {
        colorArray.add(Colors.transparent);
      }
      for (var i = 0; i < 9; i++) {
        listProgress.add(Container(
          decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/Rectangle.png"),
                fit: BoxFit.fitHeight,
              ),
              color: colorArray[i]),
          width: 30,
          height: 40,
        ));
      }

      listProgress.add(SizedBox(
        width: 10,
      ));

      /////////
      listProgress.add(IconButton(
        icon: Icon(
          sleepDeckModel.selectedYourSleepDeck != deck.id
              ? Icons.check_box_outline_blank
              : Icons.check_box,
          color: Colors.white,
        ),
        onPressed: () {
          print('show fab = $showFab');
          showFab
              ? setState(() {
                  sleepDeckState(deck, deckTotalDuration);
                })
              : _controller.setState(() {
                  sleepDeckState(deck, deckTotalDuration);
                });
        },
      ));
      /////////

      list.add(Padding(
        padding: const EdgeInsets.only(right: 10.0, left: 10.0),
        child: Container(
          height: AppSize.itemSize + 45,
          color: AppColors.your_sleep_deck,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Sleep Deck : ',
                      style: TextStyle(color: Colors.white),
                    ),
                    Expanded(
                      child: Container(
                        child: Text(deck.name,
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            textAlign: TextAlign.center),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          sleepDeckState(deck, deckTotalDuration);
                        });
                        _showDetailScreenSleepDeck(deck.name, [
                          AppColors.your_sleep_deck,
                          AppColors.your_sleep_deck_dark,
                        ]);
                      },
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        askPermissionForDeleteDeck(
                            scaffoldKey.currentContext, deck);
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  'Sleep Time :' + getTotalDuration(deck.program),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: listProgress,
              )
            ],
          ),
        ),
      ));
    }

    return list;
  }
  // </editor-fold>

  // <editor-fold desc=" sleep deck state change handle">
  void sleepDeckState(DeckData deck, int deckTotalDuration) {
    if (sleepDeckModel.selectedYourSleepDeck == deck.id) {
      sleepDeckModel.totalDuration = 0;
      sleepDeckModel.selectedYourSleepDeck = 0;
      sleepDeckModel.isYourSleepDeckSelected = false;
      sleepDeckModel.yourDecks = DeckData();
    } else {
      sleepDeckModel.isWindDownSelected = false;
      sleepDeckModel.selectedWindDown = 0;
      sleepDeckModel.isSleepDeepSelected = false;
      sleepDeckModel.selectedSleepDeep = 0;
      sleepDeckModel.isNapRecoverySelected = false;
      sleepDeckModel.selectedNapRecovery = 0;
      sleepDeckModel.isWakeUpSelected = false;
      sleepDeckModel.selectedNapRecovery = 0;
      sleepDeckModel.totalDuration = deckTotalDuration;
      sleepDeckModel.selectedYourSleepDeck = deck.id;
      sleepDeckModel.isYourSleepDeckSelected = true;
      sleepDeckModel.yourDecks = deck;
    }
  }
  // </editor-fold">

  // <editor-fold desc=" Progress bar widget if it is sleep deck already saved ">
  List<Widget> getSleepSequenceTopSaved(DeckData programs) {
    List<Widget> list = new List<Widget>();
    List<Color> colorArray = new List<Color>();

    var windDownCount = programs.program.where((program) {
      return program.id == 1;
    });
    var sleepDeepCount = programs.program.where((program) {
      return program.id == 2;
    });
    var wakeUpCount = programs.program.where((program) {
      return program.id == 3;
    });
    var napCount = programs.program.where((program) {
      return program.id == 4;
    });
    if (windDownCount.length > 0) {
      colorArray.add(AppColors.wind_down_color);
    }
    if (sleepDeepCount.length > 0) {
      for (var i = 0; i < sleepDeepCount.length; i++) {
        colorArray.add(AppColors.sleep_deep_color);
      }
    }
    if (napCount.length > 0) {
      colorArray.add(AppColors.nap_recovery_color);
    }
    if (wakeUpCount.length > 0) {
      colorArray.add(AppColors.wake_up_color);
    }

    int rest = 9 - colorArray.length;
    for (var i = 0; i < rest; i++) {
      colorArray.add(Colors.transparent);
    }
    for (var i = 0; i < 9; i++) {
      list.add(Container(
        decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("assets/Rectangle.png"),
              fit: BoxFit.fitHeight,
            ),
            color: colorArray[i]),
        width: 30,
        height: 40,
      ));
    }

    return list;
  }
  // </editor-fold>

  // <editor-fold desc=" Progress bar widget">
  List<Widget> getSleepSequence(SleepDeckModel sleepDeckModel) {
    List<Color> colorArray = new List<Color>();
    if (sleepDeckModel.isWindDownSelected) {
      colorArray.add(AppColors.wind_down_color);
    }
    if (sleepDeckModel.isSleepDeepSelected) {
      for (var i = 0; i < sleepDeckModel.sleepDeepCount; i++) {
        colorArray.add(AppColors.sleep_deep_color);
      }
    }
    if (sleepDeckModel.isNapRecoverySelected) {
      colorArray.add(AppColors.nap_recovery_color);
    }
    if (sleepDeckModel.isWakeUpSelected) {
      colorArray.add(AppColors.wake_up_color);
    }

    int rest = 9 - colorArray.length;

    for (var i = 0; i < rest; i++) {
      colorArray.add(Colors.transparent);
    }

    List<Widget> list = new List<Widget>();
    for (var i = 0; i < 9; i++) {
      list.add(Column(
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("assets/Rectangle.png"),
                  fit: BoxFit.fitHeight,
                ),
                color: colorArray[i]),
            width: 30,
            height: 40,
          ),
        ],
      ));
    }
    return list;
  }
  // </editor-fold>

  // <editor-fold desc=" get formatted time in string  ">
  String getFormattedTime(int totalSeconds) {
    print(totalSeconds);
    print("totalSeconds");

    if (totalSeconds < 0 || totalSeconds == null) {
      return "00:00:00";
    }

    int remainingHours = (totalSeconds / 3600).floor();
    int remainingMinutes = (totalSeconds / 60).floor() - remainingHours * 60;
    int remainingSeconds =
        totalSeconds - remainingMinutes * 60 - remainingHours * 3600;

    return remainingHours.toString().padLeft(2, '0') +
        ":" +
        remainingMinutes.toString().padLeft(2, '0') +
        ":" +
        remainingSeconds.toString().padLeft(2, '0');
  }
  // </editor-fold>

  // <editor-fold desc=" Return Gradient header and title of the list of wind down, nap recovery , wake up, sleep deep and sleep deck">
  Widget tileHeader(HeaderModel headerModel) {
    return Flexible(
      child: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: headerModel.headerGradientColor,
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          height: AppSize.headerSize,
          child: Row(
            crossAxisAlignment: cross,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  headerModel.title,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              Image.asset(headerModel.imageName),
              SizedBox(
                width: 40,
              ),
            ],
          )),
    );
  }
  // </editor-fold>

  // <editor-fold desc=" get sleep deck configure total duration in specified format in string ">
  String getTotalDuration(List<Program> programs) {
//    return "";
    int total = 0;
    for (var program in programs) {
      total = total + program.duration;
    }
    final now = Duration(seconds: total);
    // print("${_printDuration(now)}");

    return generic.getDurationFormattedString(now);
  }
  // </editor-fold>

  // <editor-fold desc=" get sleep deck configure total duration in INT format ">

  int getTotalDurationTopHeader(List<Program> deck) {
    int total = 0;
    for (var program in deck) {
      print('program id =  ' + program.name);
      total = total + program.duration;
    }
    return total;
  }

  // </editor-fold">

  // <editor-fold desc=" Show detail screen for wind down, nap recovery and wake up">
  _showDetailScreen(Program programs, String name, List<Color> colors) {
    scaffoldKey.currentState.showBottomSheet((context) => Padding(
          padding: EdgeInsets.all(20),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.all(Radius.circular(20.0)),
              gradient: new LinearGradient(
                  colors: colors,
                  begin: const FractionalOffset(0.1, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Image.network(generic.getImageName(
                          programs.avatar, programs.avatarToken)),
                    ),
                    Text(
                      name,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    Text(
                      'Duration : ' +
                          getFormattedTime(programs.duration) +
                          ' minutes',
                      style: TextStyle(color: Colors.white),
                    ),
                    Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          programs.name,
                          style: TextStyle(color: Colors.white),
                        )),
                    RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.transparent)),
                      onPressed: () {
                        setState(() {
                          if (name == 'Wind Down') {
                            windDownEventHandle([programs], 0);
                          } else if (name == 'Sleep Deep') {
                            sleepDeepEventHandle([programs], 0);
                          } else if (name == 'Nap Recovery') {
                            napRecoveryEventHandle([programs], 0);
                          } else if (name == 'Wake Up') {
                            wakeUpEventHandle([programs], 0);
                          }
                        });
                        Navigator.pop(context);
                      },
                      color: Colors.white,
                      textColor: Colors.black,
                      child: Text("Add to sleep Deck",
                          style: TextStyle(fontSize: 14)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
  // </editor-fold">

  // <editor-fold desc=" Show detail screen of the sleep deck">

  void _showDetailScreenSleepDeck(String name, List<Color> colors) async {
    _controller = await scaffoldKey.currentState.showBottomSheet((context) =>
        Padding(
          padding: EdgeInsets.all(20),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.all(Radius.circular(20.0)),
              gradient: new LinearGradient(
                  colors: colors,
                  begin: const FractionalOffset(0.1, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: cross,
                          mainAxisAlignment: main,
                          children: <Widget>[
                            Text(
                              'Sleep Time',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              sleepDeckModel.isYourSleepDeckSelected
                                  ? getTotalDuration(
                                          sleepDeckModel.yourDecks.program) +
                                      ' hours'
                                  : getFormattedTime(
                                          sleepDeckModel.totalDuration) +
                                      ' hours',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(),
                    Text(
                      'your sleep sequence',
                      style: TextStyle(color: Colors.white),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: sleepDeckModel.isYourSleepDeckSelected
                            ? getSleepSequenceTopSaved(sleepDeckModel.yourDecks)
                            : getSleepSequence(sleepDeckModel),
                      ),
                    ),
                    Divider(),
                    Expanded(
                      child: widget.musicList.isNotEmpty
                          ? ListView(
                              physics: ClampingScrollPhysics(),
                              padding: EdgeInsets.all(0.0),
                              children: <Widget>[
                                Container(
                                  child: windDown(),
                                  color: AppColors.primary_color,
                                ),
                                Container(
                                  child: sleepDeep(),
                                  color: AppColors.primary_color,
                                ),
                                Container(
                                  child: napRecovery(),
                                  color: AppColors.primary_color,
                                ),
                                Container(
                                  child: wakeUp(),
                                  color: AppColors.primary_color,
                                ),
//                                Container(
//                                  child: sleepDeck(),
//                                  color: AppColors.primary_color,
//                                ),
                              ],
                            )
                          : Container(),
                    ),
                    Container(
                      height: 80,
                      color: Colors.indigo,
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: RaisedButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.transparent)),
                              onPressed: () {
                                setState(() {});
                                Navigator.pop(context);
                              },
                              color: Colors.white,
                              textColor: Colors.black,
                              child: Text("Add to sleep Deck",
                                  style: TextStyle(fontSize: 14)),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
    changeBottomSheetState(false);

    _controller.closed.then((value) {
      changeBottomSheetState(true);
    });
  }
  // </editor-fold">

  // <editor-fold desc=" Show a sheet for saving the created deck with a name or launcnh without saving">
  void showDeckSaveSheet(List<Program> decks) {
    scaffoldKey.currentState.showBottomSheet((context) => Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [Color(0xFFCD35F5), Color(0xFF2F1D73)],
                begin: const FractionalOffset(0.1, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 56,
                        ),
                        Text(
                          'Do you want to save this Sleep Deck?',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Name : ',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            SizedBox(
                              height: 40,
                              width: 200,
                              child: Container(
                                color: Colors.white,
                                child: TextFormField(
                                  style: TextStyle(color: Colors.black),
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    labelText: '',
                                    labelStyle: TextStyle(color: Colors.black),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white54),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white54),
                                    ),
                                    border: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white54)),
                                  ),
                                  autovalidate: false,
                                  autocorrect: false,
                                ),
                              ),
                            ), //downloadFile
                            //                                TextFormField(),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.indeterminate_check_box),
                              color: Colors.white,
                              onPressed: () {},
                            ),
                            Text(
                              'Do not disturb - check phone settings',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RaisedButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.transparent)),
                              onPressed: () {
                                if (_emailController.text.isEmpty) {
                                  generic.alertDialog(
                                      context,
                                      "Alert",
                                      "Please enter a name for proceeding",
                                      () {});
                                  return;
                                }
                                Navigator.pop(context);
//                                _onSubmit();

                                saveData(DeckData(
                                  id: random.nextInt(100),
                                  name: _emailController.text,
                                  program: decks,
                                )).then((finish) {
                                  getData();
                                });
                              },
                              color: AppColors.your_sleep_deck_color_button,
                              textColor: Colors.white,
                              child:
                                  Text("Save", style: TextStyle(fontSize: 14)),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            RaisedButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.transparent)),
                              onPressed: () {
                                Navigator.pop(context);

                                SongData songs = SongData(
                                  songs: decks,
                                );

                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => new NowPlaying(
                                            true,
                                            songs,
                                            songs.songs[0],
                                            MusicFile(
                                                _emailController.text, decks),
                                            0)));
                              },
                              color: AppColors.your_sleep_deck_color_button,
                              textColor: Colors.white,
                              child: Text("Launch without saving",
                                  style: TextStyle(fontSize: 14)),
                            ),
                          ],
                        )
                      ]),
                ],
              )),
        ));
  }
  // </editor-fold>

  // <editor-fold desc="Ask permission for delete a specified Deck in showModalBottomSheet ">
  void askPermissionForDeleteDeck(context, DeckData id) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: Colors.white,
            child: new Wrap(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Are you sure do you want to delete the deck ?',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
                new ListTile(
                    leading: new Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                    title: new Text('yes'),
                    onTap: () {
                      deleteData(id).then((value) {
                        getData();
                      });
                      Navigator.pop(context);
                    }),
                new ListTile(
                  leading: new Icon(
                    Icons.close,
                    color: Colors.redAccent,
                  ),
                  title: new Text('no'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }
  // </editor-fold>

  // <editor-fold desc="Change the status of the bottom sheet because the bottom sheet won't update when setstate call">
  void changeBottomSheetState(bool value) {
    setState(() {
      showFab = value;
    });
  }
// </editor-fold>

}

  // <editor-fold desc=" Dialogs For application indicator showing while app connecting to the network ">
class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.black54,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Please Wait....",
                          style: TextStyle(color: Colors.blueAccent),
                        )
                      ]),
                    )
                  ]));
        });
  }
}
// </editor-fold>
