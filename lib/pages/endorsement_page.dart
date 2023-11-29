import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfirstapp/components/my_button.dart';
import 'package:myfirstapp/components/text_field_with_title.dart';
import 'package:myfirstapp/pages/main_chat_page.dart';
import 'package:myfirstapp/queries/users_quries.dart';

class EndorsementPage extends StatefulWidget {
  final String endorsedUserEmail;
  final String endorsedUserUsername;
  const EndorsementPage(
      {super.key,
      required this.endorsedUserEmail,
      required this.endorsedUserUsername});

  @override
  _EndorsementPageState createState() => _EndorsementPageState();
}

class _EndorsementPageState extends State<EndorsementPage> {
  final usernameController = TextEditingController();
  final endorsementController = TextEditingController();

  void updateEndorsements(String endorsedEmail) async {
    UserQueries.addEndoresement(endorsedEmail, endorsementController.text);
  }
  //todo: once Save is pressed, reload profile page automatically

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        foregroundColor: Colors.grey[800],
        leading: BackButton(color: Colors.grey[800]),
        toolbarHeight: 40,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(children: [
        UserImageIcon(userMail: widget.endorsedUserEmail, size: 100),
        const SizedBox(
          height: 30,
        ),
        TextFieldWithTitleWidget(
          label: ' Endorse ${widget.endorsedUserUsername} here',
          text:
              'Tell everyone how great traveller ${widget.endorsedUserUsername} is',
          maxLines: 5,
          controller: endorsementController,
        ),
        const SizedBox(height: 30),
        MyButton(
            onTap: () {
              updateEndorsements(widget.endorsedUserEmail);
              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                        content: Text(
                            'Your endoresement has been sent to ${widget.endorsedUserUsername}!'),
                      ));
            },
            text: 'Save'),
      ]),
    );
  }
}
