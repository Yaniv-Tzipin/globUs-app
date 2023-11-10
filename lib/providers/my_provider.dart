import "package:flutter/material.dart";
import "package:myfirstapp/pages/choose_tags_page.dart";


class MyProvider extends ChangeNotifier{
  int _count = 0;
  List<Chip> _chosenTags = [];
  int get count => _count;
  List<Widget> get chosenTags => _chosenTags;
  List<MyTag> pressedTags = [];

  void increment(){
    _count = _count + 1;
    notifyListeners();
  }

  void decrement(){
    _count = _count - 1;
    notifyListeners();
  }

  void addTagToChosen(Chip tag){
    _chosenTags.add(tag);
    notifyListeners();

  }

  void addTagToPressed(MyTag tag){
    pressedTags.add(tag);
    notifyListeners();
    
  }

  void removeTagFromChosen(Chip tag){
    Chip chosenToRemove = tag;
    for (Chip mytag in _chosenTags){ 
      if(tag.key == mytag.key){
       chosenToRemove = mytag;
      }
    }
     _chosenTags.remove(chosenToRemove);
     notifyListeners();
  }

  bool isPressed(MyTag tag){
    for(MyTag existingTag in pressedTags){
      if(existingTag.text == tag.text){
        return true;
      }

    }
    return false; 
  }

   void removeTagFromPressed(MyTag tag){
    MyTag chosenToRemove = tag;
    for (MyTag mytag in pressedTags){ 
      if(tag.key == mytag.key){
       chosenToRemove = mytag;
      }
    }
     pressedTags.remove(chosenToRemove); 
     notifyListeners();
  }


  
}