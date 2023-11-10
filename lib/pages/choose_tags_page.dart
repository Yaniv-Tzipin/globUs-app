import "package:flutter/material.dart";
import "package:get/route_manager.dart";
import "package:myfirstapp/components/my_tags_grid.dart";
import 'package:myfirstapp/providers/my_provider.dart';
import "package:provider/provider.dart";
import 'package:myfirstapp/components/my_colors.dart' as my_colors;

class MyTags extends StatefulWidget {
  const MyTags({super.key});

  @override
  State<MyTags> createState() => _MyTagsState();
}

class _MyTagsState extends State<MyTags>{


  @override
  Widget build(BuildContext context) {
    final tagsCounter = Provider.of<MyProvider>(context);
    final tagsCount = tagsCounter.count;
    final chosenTagsList = tagsCounter.chosenTags;

    List<MyTag> hobbiesTags = [
      MyTag(tagsCounter: tagsCounter, text: 'anime'),
      MyTag(tagsCounter: tagsCounter, text: 'art'),
      MyTag(tagsCounter: tagsCounter, text: 'beach'),
      MyTag(tagsCounter: tagsCounter, text: 'brunch'),
      MyTag(tagsCounter: tagsCounter, text: 'concerts'),
      MyTag(tagsCounter: tagsCounter, text: 'cooking'),
      MyTag(tagsCounter: tagsCounter, text: 'dancing'),
      MyTag(tagsCounter: tagsCounter, text: 'diy'),
      MyTag(tagsCounter: tagsCounter, text: 'fashion'),
      MyTag(tagsCounter: tagsCounter, text: 'gaming'),
      MyTag(tagsCounter: tagsCounter, text: 'hiking'),
      MyTag(tagsCounter: tagsCounter, text: 'karaoke'),
      MyTag(tagsCounter: tagsCounter, text: 'movies'),
      MyTag(tagsCounter: tagsCounter, text: 'music'),
      MyTag(tagsCounter: tagsCounter, text: 'naps'),
      MyTag(tagsCounter: tagsCounter, text: 'popmusic'),
      MyTag(tagsCounter: tagsCounter, text: 'reading'),
      MyTag(tagsCounter: tagsCounter, text: 'tattoos'),
      MyTag(tagsCounter: tagsCounter, text: 'extreme'),
      MyTag(tagsCounter: tagsCounter, text: 'tennis'),
      MyTag(tagsCounter: tagsCounter, text: 'workingout'),
      MyTag(tagsCounter: tagsCounter, text: 'writing'),
      MyTag(tagsCounter: tagsCounter, text: 'yoga'),
      MyTag(tagsCounter: tagsCounter, text: 'clubbing'),
      MyTag(tagsCounter: tagsCounter, text: 'biking'),
      MyTag(tagsCounter: tagsCounter, text: 'soccer'),
      MyTag(tagsCounter: tagsCounter, text: 'tv'),
      MyTag(tagsCounter: tagsCounter, text: 'animals'),
      MyTag(tagsCounter: tagsCounter, text: 'cruising')
      ];
    List<MyTag> personalityTags = [
      MyTag(tagsCounter: tagsCounter, text: 'adventurous'),
      MyTag(tagsCounter: tagsCounter, text: 'catperson'),
      MyTag(tagsCounter: tagsCounter, text: 'chill'),
      MyTag(tagsCounter: tagsCounter, text: 'confident'),
      MyTag(tagsCounter: tagsCounter, text: 'curious'),
      MyTag(tagsCounter: tagsCounter, text: 'dogperson'),
      MyTag(tagsCounter: tagsCounter, text: 'candid'),
      MyTag(tagsCounter: tagsCounter, text: 'good-listener'),
      MyTag(tagsCounter: tagsCounter, text: 'funny'),
      MyTag(tagsCounter: tagsCounter, text: 'goofy'),
      MyTag(tagsCounter: tagsCounter, text: 'kind'),
      MyTag(tagsCounter: tagsCounter, text: 'loyal'),
      MyTag(tagsCounter: tagsCounter, text: 'mature'),
      MyTag(tagsCounter: tagsCounter, text: 'wild-spirit'),
      MyTag(tagsCounter: tagsCounter, text: 'outgoing'),
      MyTag(tagsCounter: tagsCounter, text: 'shy'),
      MyTag(tagsCounter: tagsCounter, text: 'reliable'),
      MyTag(tagsCounter: tagsCounter, text: 'romantic'),
      MyTag(tagsCounter: tagsCounter, text: 'honest'),
      MyTag(tagsCounter: tagsCounter, text: 'creative'),
      MyTag(tagsCounter: tagsCounter, text: 'ambitious'),
      MyTag(tagsCounter: tagsCounter, text: 'calm'),
      MyTag(tagsCounter: tagsCounter, text: 'helpful'),
      MyTag(tagsCounter: tagsCounter, text: 'organized'),
      MyTag(tagsCounter: tagsCounter, text: 'clean'),
      MyTag(tagsCounter: tagsCounter, text: 'adaptable'),
      MyTag(tagsCounter: tagsCounter, text: 'athletic'),
      MyTag(tagsCounter: tagsCounter, text: 'sociable'),
      MyTag(tagsCounter: tagsCounter, text: 'tolerant'),
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
          elevation: 0,
           toolbarHeight: 40,
            title: Text('My Tags $tagsCount/10'),
             centerTitle: true,
             backgroundColor: my_colors.toolBarColor,),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 40,
              width: double.maxFinite,
              color: my_colors.toolBarColor,
              child: const Padding(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Text(
                  'Add up to 10 tags to your profile that best describe you',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            MyTagsGrid(tagsTheme: 'My Tags',
             icon: Icon(Icons.check_rounded),
            listOfTags: chosenTagsList),
            SearchBar(
                backgroundColor: MaterialStateProperty.all(my_colors.searchBarColor),
                elevation: MaterialStateProperty.all(0),
                hintText: 'Type here..',
                leading: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    showSearch(context: context, delegate: CustomSearch());
                  },
                )),
            const SizedBox(
              height: 20,
            ),
            MyTagsGrid(
              icon: Icon(Icons.festival_rounded),
              listOfTags: hobbiesTags,
              tagsTheme: 'Hobbies',
            ),
            const SizedBox(
              height: 20,
            ),
            MyTagsGrid(
              icon: Icon(Icons.self_improvement),
              listOfTags: personalityTags,
              tagsTheme: 'Traits',
            ),
      
            MyTagsGrid(tagsTheme: 'Travel Wishlist',
             icon: Icon(Icons.travel_explore),
            listOfTags: [MyTag(tagsCounter: tagsCounter, text: 'yesh')],)
      
          ],
        ),
      ),
    );
  }
}

class CustomSearch extends SearchDelegate{

  List<searchedTag> allData = [searchedTag(text: 'hi'),
  searchedTag(text: 'bi'),searchedTag(text: 'mi'),searchedTag(text: 'gi'),searchedTag(text: 'ci'),];
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: (){
        query = '';
      }, 
      icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: (){
      close(context, null);
    }, icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<searchedTag> matchquery =[];
    for(searchedTag tag in allData){
      if(tag.text.toLowerCase().contains(query.toLowerCase())){
        matchquery.add(tag);
      }
    }
    return ListView.builder(
      itemCount: matchquery.length,
      itemBuilder: ((context, index) {
        searchedTag result = matchquery[index];
        return ListTile(
          textColor: Colors.amber,
          title: Text(result.text),
        );
      })
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<searchedTag> matchquery =[];
    for(searchedTag tag in allData){
      if(tag.text.toLowerCase().contains(query.toLowerCase())){
        matchquery.add(tag);
      }
    }
    return GridView.builder(
      itemCount: matchquery.length,
      itemBuilder: ((context, index) {
        searchedTag result = matchquery[index];
        return ListTile(
          title: result,
        );
      }), 
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
      childAspectRatio: 1,
      )
    );
  
  }
}

class MyTag extends StatefulWidget {
  final String text;
   const MyTag({
    super.key,
    required this.tagsCounter, 
    required this.text,
  });

  final MyProvider tagsCounter;
  
  @override
  State<MyTag> createState() => _MyTagState();
}

class _MyTagState extends State<MyTag> {
  bool isSelected = false;
  bool ableToAddTag(){
      return widget.tagsCounter.count != 10;
    }

  @override
  Widget build(BuildContext context) {

    isSelected = widget.tagsCounter.isPressed(widget); 
    
    return InputChip(label: Text(widget.text),
    onSelected: (bool newBool){
  
      if(!widget.tagsCounter.isPressed(widget)){
      if(ableToAddTag()){
      isSelected = !isSelected;
      widget.tagsCounter.increment();
      widget.tagsCounter.addTagToPressed(widget);
      widget.tagsCounter.addTagToChosen(Chip(label: Text(widget.text),));
      }
      }
      else{
      isSelected = !isSelected;
      widget.tagsCounter.decrement();
      widget.tagsCounter.removeTagFromChosen(
        Chip(label: Text(widget.text),)
      );
      widget.tagsCounter.removeTagFromPressed(
        widget
      );
      }

    },
    selected: isSelected,
    selectedColor: my_colors.selectedTagColor,)
    ;
  }

}

class searchedTag extends StatefulWidget {
  final String text;
   const searchedTag({super.key, required this.text,
  });
  
  @override
  State<searchedTag> createState() => _searchedTagState();
}

class _searchedTagState extends State<searchedTag> {
  static bool isSelected = false;
  
  @override
  Widget build(BuildContext context) {
    return InputChip(label: Text(widget.text),
    onSelected: (bool newBool){
      setState(() {
        isSelected = !isSelected;
      }); 
    },
    selected: isSelected,
    selectedColor: my_colors.selectedTagColor
    );
  }
}



