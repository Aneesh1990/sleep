import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:sleep_giant/data/song_data.dart';

import 'all_programs_list_response.dart';

class SleepDeckModel {
  List<Programs> programs;
  int windDownCount = 0;
  int sleepDeepCount = 0;
  int napRecoveryCount = 0;
  int wakeUpCount = 0;

  int totalDuration = 0;

  int selectedWindDown = 0;
  int selectedWakeUp = 0;
  int selectedSleepDeep = 0;
  int selectedNapRecovery = 0;
  int selectedYourSleepDeck = 0;

  String windDownAudio = "";
  String sleepDeepAudio = "";
  String napRecoveryAudio = "";
  String wakeUpAudio = "";

  Program windDownProgram;
  Program sleepDeepProgram;
  Program napRecoveryProgram;
  Program wakeUpProgram;
  DeckData yourDecks = DeckData();

  bool isWindDownSelected = false;
  bool isSleepDeepSelected = false;
  bool isNapRecoverySelected = false;
  bool isWakeUpSelected = false;
  bool isYourSleepDeckSelected = false;

//  SleepDeckSaveModel requestModel;
}

class HeaderModel {
  final List<Color> headerGradientColor;
  final String title;
  final String imageName;

  HeaderModel(this.headerGradientColor, this.title, this.imageName);
}
