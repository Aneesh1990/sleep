//class SleepDeckSaveModel {
//  String deckName;
//  List<DeckData> decks = [];
//
//  SleepDeckSaveModel({this.deckName, this.decks});
//
//  SleepDeckSaveModel.fromJson(Map<String, dynamic> json) {
//    deckName = json['deck_name'];
//    if (json['programs'] != null) {
//      decks = new List<DeckData>();
//      json['programs'].forEach((v) {
//        decks.add(new Program().fromJson(v));
//      });
//    }
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['deck_name'] = this.deckName;
//    if (this.decks != null) {
//      data['decks'] = this.decks.map((v) => v.toJson()).toList();
//    }
//    return data;
//  }
//}
//
//class SaveDecks {
//  String name;
//  List<int> programIds;
//
//  SaveDecks({this.name, this.programIds});
//
//  SaveDecks.fromJson(Map<String, dynamic> json) {
//    name = json['name'];
//    programIds = json['program_ids'].cast<int>();
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['name'] = this.name;
//    data['program_ids'] = this.programIds;
//    return data;
//  }
//}
