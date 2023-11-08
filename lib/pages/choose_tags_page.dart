import "package:flutter/material.dart";
import "package:myfirstapp/components/my_tags_grid.dart";

class MyTags extends StatefulWidget {
  const MyTags({super.key});

  @override
  State<MyTags> createState() => _MyTagsState();
}

class _MyTagsState extends State<MyTags> {
  var title = new Text("0/10");
  List<myTag> chosenTags = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0, toolbarHeight: 40, title: title, centerTitle: true),
      body: Column(
        children: [
          Container(
            height: 40,
            width: double.maxFinite,
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Text(
                'Add up to 10 tags to your profile that best describe you',
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SearchBar(
              elevation: MaterialStateProperty.all(0),
              hintText: 'Type here..',
              leading: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              )),
          const SizedBox(
            height: 20,
          ),
          MyTagsGrid(
            icon: Icon(Icons.abc),
            listOfTags: [myTag(tagLabel: "test")],
            tagsTheme: 'test',
          ),
          const SizedBox(
            height: 20,
          ),
          MyTagsGrid(
            icon: Icon(Icons.access_alarms),
            listOfTags: [
              myTag(tagLabel: "yaniv"),
              myTag(tagLabel: "noa"),
              myTag(tagLabel: "nadav")
            ],
            tagsTheme: 'developers',
          )
        ],
      ),
    );
  }
}

class myTag extends StatefulWidget {
  final String tagLabel;
  const myTag({super.key, required this.tagLabel});

  @override
  State<myTag> createState() => _myTagState();
}

class _myTagState extends State<myTag> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InputChip(
        selectedColor: Color.fromARGB(255, 136, 198, 135),
        label: Text(widget.tagLabel),
        selected: isSelected,
        onSelected: (bool newBool) {
          setState(() {
            isSelected = !isSelected;
          });
        },
      ),
    );
  }
}
