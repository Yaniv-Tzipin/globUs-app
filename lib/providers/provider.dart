import "package:flutter/material.dart";
import "package:myfirstapp/pages/choose_tags_page.dart";

class MyProvider extends ChangeNotifier{
  int _count = 0;
  List<MyTag> _chosenTags = [];
  int get count => _count;
  List<Widget> get chosenTags => _chosenTags;

  void increment(){
    _count = _count + 1;
    notifyListeners();
  }

  void decrement(){
    _count = _count - 1;
    notifyListeners();
  }

  void addTagToChosen(MyTag tag){
    _chosenTags.add(tag);
  }

  void removeTagFromChosen(MyTag tag){
    MyTag chosenToRemove = tag;
    for (MyTag mytag in _chosenTags){
      if(tag.key == mytag.key){
       chosenToRemove = mytag;
      }

    }
     _chosenTags.remove(chosenToRemove);
  }
}