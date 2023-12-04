import "package:flutter/material.dart";
import "package:myfirstapp/globals.dart";
import "package:myfirstapp/pages/choose_tags_page.dart";
import "package:myfirstapp/queries/users_quries.dart";

class MyTagsProvider extends ChangeNotifier {
  int _count = 0;
  final List<Chip> _chosenTags = [];
  int get count => _count;
  List<Chip> get chosenTags => _chosenTags;

  List<MyTag> pressedTags = [];

  void increment() {
    _count = _count + 1;
    notifyListeners();
  }

  void decrement() {
    _count = _count - 1;
    notifyListeners();
  }

  void addTagToChosen(Chip chip, {bool toNotify = true}) {
    bool isExists = false;
    for (Chip tagChip in _chosenTags) {
      if (tagChip.label.toString() == chip.label.toString()) {
        isExists = true;
      }
    }
    if (!isExists) {
      _chosenTags.add(chip);
    }
    if (toNotify) {
      notifyListeners();
    }
  }

  //todo function that adds multiple tags

  void addTagToPressed(MyTag tag) {
    pressedTags.add(tag);
    UserQueries.usersTagsToString.add(tag.text);
    notifyListeners();
  }

  void removeTagFromChosen(Chip tag) {
    Chip chosenToRemove = tag;
    for (Chip mytag in _chosenTags) {
      if (tag.label.toString() == mytag.label.toString()) {
        chosenToRemove = mytag;
      }
    }
    _chosenTags.remove(chosenToRemove);
    notifyListeners();
  }

  void removeTagFromPressed(MyTag tag) {
    MyTag chosenToRemove = tag;
    for (MyTag mytag in pressedTags) {
      if (tag.text == mytag.text) {
        chosenToRemove = mytag;
      }
    }
    pressedTags.remove(chosenToRemove);
    UserQueries.usersTagsToString.remove(chosenToRemove.text);
    notifyListeners();
  }

  bool isPressed(MyTag tag) {
    if (currentUser.tags.contains(tag.text)) {
      // if exists in DB
      //make sure to add DB tags to _chosen list
      bool isInChosenList = false;
      print("chosen tags: " + chosenTags.toString());
      for (Chip tagChip in _chosenTags) {
        print("chosen tags: " + chosenTags.toString());
        if (tagChip.label.toString() == tag.text) {
          isInChosenList = true;
        }
      }
      if (!isInChosenList) {
        pressedTags.add(tag);
      }

      return true;
    }
    for (MyTag existingTag in pressedTags) {
      if (existingTag.text == tag.text) {
        return true;
      }
    }
    return false;
  }
}