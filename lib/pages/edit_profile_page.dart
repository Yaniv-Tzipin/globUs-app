import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:myfirstapp/components/my_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:myfirstapp/components/my_colors.dart';
import 'package:myfirstapp/components/my_tags_grid.dart';
import 'package:myfirstapp/components/profile_widget.dart';
import 'package:myfirstapp/components/text_field_with_title.dart';
import 'package:myfirstapp/globals.dart';
import 'package:myfirstapp/pages/choose_profile_image_page.dart';
import 'package:myfirstapp/pages/choose_tags_page.dart';
import 'package:myfirstapp/pages/home_page.dart';
import 'package:myfirstapp/providers/my_tags_provider.dart';
import 'package:myfirstapp/services/helpers.dart';
import 'package:myfirstapp/queries/users_quries.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  List<String> stringTags = [];
  EditProfilePage({
    super.key,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final usernameController = TextEditingController();
  final bioController = TextEditingController();
  final birthDateController = TextEditingController();

  void updateDB() async {
    Map<String, TextEditingController> controllers = {"bio": bioController};
    for (MapEntry<String, TextEditingController> entry in controllers.entries) {
      TextEditingController controller = entry.value;
      if (controller.text.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.email)
            .update({entry.key: controller.text});
      }
    }
    //todo: once Save is pressed, reload profile page automatically
  }

  void updateBirthDate() async {
    if (birthDateController.text.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.email)
          .update(
              {"birth_date": parseStringToTimestamp(birthDateController.text)});
    }
  }

  void updateTagsInDB(List<String> tagsString) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email)
        .update({'tags': tagsString});
  }

  void appBarOnPressed() {
    updateTagsInDB(widget.stringTags);
    updateDB();
    Get.to(HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.email)
            .snapshots(),
        builder: ((context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              foregroundColor: Colors.grey[800],
              leading: BackButton(
                  color: Colors.grey[800], onPressed: appBarOnPressed),
              toolbarHeight: 40,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                physics: const BouncingScrollPhysics(),
                children: [
                  buildProfileWidget(),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFieldWithTitleWidget(
                    label: 'About Me',
                    text: currentUser.bio,
                    maxLines: 5,
                    controller: bioController,
                  ),
                  const SizedBox(height: 30),
                  buildMyTags(),
                  const SizedBox(
                    height: 20,
                  ),
                  buildDatePicker(birthDateController),
                ]),
          );
        }));
  }

  Widget buildProfileWidget() {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.email)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            String imagePath = data["profile_image"];
            return ProfileWidget(
                imagePath: imagePath, onClicked: goToChooseImage, isEdit: true);
          } else {
            return const Text('loading..');
          }
        });
  }

  void goToChooseImage() async {
    await Get.to(const ImageProfile());
  }

  Widget buildDatePicker(TextEditingController birthDateController) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.email)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text(
                "Document does not exist for email: ${currentUser.email}");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            String birthDate =
                DateFormat.yMMMd().format(data["birth_date"].toDate());

            return Column(
              children: [
                Row(
                  children: [
                    const Text(
                      "Birth date",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      birthDate,
                      style: TextStyle(fontSize: 20),
                    ),
                    IconButton(onPressed: _selectDate, icon: Icon(Icons.edit))
                  ],
                ),
                // MyDatePicker(dateController: birthDateController)
              ],
            );
          }
          return Container();
        });
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime(2006),
        firstDate: DateTime(1925),
        lastDate: DateTime(2006));

    if (picked != null) {
      setState(() {
        birthDateController.text = picked.toString().split(" ")[0];
      });
      updateBirthDate();
    }
  }

  Widget buildMyTags() {
    List<InputChip> myTags = currentUser.tags
        .map((x) => InputChip(
              label: Text(x),
              selected: true,
              selectedColor: selectedTagColor,
              labelStyle: const TextStyle(color: Colors.black),
              elevation: 0,
            ))
        .toList();

    return Column(
      children: [
        Row(
          children: [
            const Text(
              "My Tags",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            IconButton(onPressed: goToChooseTags, icon: Icon(Icons.edit))
          ],
        ),
        AbsorbPointer(
            child: MyTagsGrid(
                icon: const Icon(Icons.check_rounded), listOfTags: myTags)),
      ],
    );
  }

  void goToChooseTags() async {
    var tagsCounter = Provider.of<MyTagsProvider>(context, listen: false);
    tagsCounter.nullifyCount();
    tagsCounter.chosenTags = [];
    tagsCounter.pressedTags = [];
    for (String tag in currentUser.tags) {
      tagsCounter.addTagToChosen(Chip(
        label: Text(tag),
      ));
      tagsCounter.addTagToPressed(MyTag(tagsCounter: tagsCounter, text: tag));
      UserQueries.usersTagsToString.add(tag);
      tagsCounter.increment();
    }
    await Get.to(const MyTags());
    for (Chip tagChip in tagsCounter.chosenTags) {
      Text txt = tagChip.label as Text;
      if (!widget.stringTags.contains(txt.data.toString())) {
        widget.stringTags.add(txt.data.toString());
      }
      print(txt.data.toString());
    }
    // updateTagsInDB(stringTags);
  }
}
