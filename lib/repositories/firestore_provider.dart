import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sleep_giant/data/song_data.dart';

class FirestoreProvider {
  Firestore _firestore = Firestore.instance;

  Future<int> authenticateUser(String email, String password) async {
    final QuerySnapshot result = await _firestore
        .collection("users")
        .where("email", isEqualTo: email)
        .getDocuments();
    final List<DocumentSnapshot> docs = result.documents;
    if (docs.length == 0) {
      return 0;
    } else {
      return 1;
    }
  }

  Future<void> registerUserDetails(
      String userId, String name, String email) async {
    return _firestore.collection("users").document(userId).setData({
      'name': name,
      'email': email,
      'sleep_deck': [],
      'sleep_deck_added': false
    });
  }

  Future<void> uploadDeck(
      String title, String documentId, SleepDeckData programs) async {
    DocumentSnapshot doc =
        await _firestore.collection("users").document(documentId).get();

//    SleepDeckData data = SleepDeckData.fromSnapshot(doc);

    SleepDeckData goals = doc.data["sleep_deck"] != null
        ? doc.data["sleep_deck"].cast<String, String>()
        : null;

    goals.decks = programs.decks;

//    if (goals != null) {
//      goals[title] = goal;
//    } else {
//      goals = Map();
//      goals[title] = goal;
//    }
    return _firestore
        .collection("users")
        .document(documentId)
        .setData({'sleep_deck': goals, 'sleep_deck_added': true}, merge: true);
  }

  Stream<DocumentSnapshot> myGoalList(String documentId) {
    return _firestore.collection("users").document(documentId).snapshots();
  }

  Stream<QuerySnapshot> othersGoalList() {
    return _firestore
        .collection("users")
        .where('goalAdded', isEqualTo: true)
        .snapshots();
  }

  Future<QuerySnapshot> getData() async {
    return await _firestore.collection("music").getDocuments();
  }

  void removeDeck(String title, String documentId) async {
    DocumentSnapshot doc =
        await _firestore.collection("users").document(documentId).get();
    Map<String, String> goals = doc.data["sleep_deck"].cast<String, String>();
    goals.remove(title);
    if (goals.isNotEmpty) {
      _firestore
          .collection("users")
          .document(documentId)
          .updateData({"goals": goals});
    } else {
      _firestore
          .collection("users")
          .document(documentId)
          .updateData({'goals': FieldValue.delete(), 'goalAdded': false});
    }
  }
}
