import "package:flutter/material.dart";
import "package:myfirstapp/globals.dart";
import "package:myfirstapp/pages/choose_tags_page.dart";
import "package:myfirstapp/queries/users_quries.dart";

class MyTagsProvider extends ChangeNotifier {
  bool pressed = false;
  int _count = 0;
  List<Chip> chosenTags = [];
  int get count => _count;
  

  List<MyTag> pressedTags = [];

  void increment() {
    _count = _count + 1;
    notifyListeners();
  }

  void decrement() {
    _count = _count - 1;
    notifyListeners();
  }

  void nullifyCount(){
    _count = 0;
  }

  void addTagToChosen(Chip chip, {bool toNotify = true}) {
    bool isExists = false;
    for (Chip tagChip in chosenTags) {
      if (tagChip.label.toString() == chip.label.toString()) {
        isExists = true;
      }
    }
    if (!isExists) {
      chosenTags.add(chip);
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
    for (Chip mytag in chosenTags) {
      if (tag.label.toString() == mytag.label.toString()) {
        chosenToRemove = mytag;
      }
    }
    chosenTags.remove(chosenToRemove);
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
    
    for (MyTag existingTag in pressedTags) {
      if (existingTag.text == tag.text) {
        return true;
      }
    }
    return false;
  }
}