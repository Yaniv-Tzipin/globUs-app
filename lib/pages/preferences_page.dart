import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:myfirstapp/components/my_button.dart';
import 'package:myfirstapp/components/my_colors.dart';
import 'package:myfirstapp/queries/users_quries.dart';
import 'package:myfirstapp/components/my_colors.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  late Map<String, dynamic> sliders;
  var _future;

  @override
  initState() {
     super.initState();
    _future = UserQueries.loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Text("error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          // saving the data
          sliders = snapshot.data;

          return Scaffold(
            backgroundColor: veryBeautifulLightGreen,
              appBar: AppBar(
                title:  const Text(
                  'Define features importance',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 116, 114, 114)),
                ),
              ),
              body: Column(
                children: [
                  Image.asset('lib/images/globUsLogo1.png',
                width: 240),
                  const SizedBox(height: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text(style: TextStyle(fontWeight: FontWeight.bold),
                            'Age:'),
                      ),
                      Slider(
                        inactiveColor: Colors.white,
                        thumbColor: selectedTagColor,
                        activeColor: selectedTagColor,
                        value: sliders['Age'].toDouble(),
                        onChanged: (value) {
                          setState(
                            () {
                              sliders['Age'] = value;
                            },
                          );
                        },
                        max: 100.0,
                        min: 0.0,
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text(style: TextStyle(fontWeight: FontWeight.bold),
                            'Location:'),
                      ),
                      Slider(
                        inactiveColor: Colors.white,
                        thumbColor: selectedTagColor,
                        activeColor: selectedTagColor,
                        value: sliders['Location'].toDouble(),
                        onChanged: (value) {
                          setState(
                            () {
                              sliders['Location'] = value;
                            },
                          );
                        },
                        max: 100.0,
                        min: 0.0,
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text(style: TextStyle(fontWeight: FontWeight.bold),
                            'Origin country:'),
                      ),
                      Slider(
                        inactiveColor: Colors.white,
                        thumbColor: selectedTagColor,
                        activeColor: selectedTagColor,
                        value: sliders['Origin country'].toDouble(),
                        onChanged: (value) {
                          setState(
                            () {
                              sliders['Origin country'] = value;
                            },
                          );
                        },
                        max: 100.0,
                        min: 0.0,
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text(style: TextStyle(fontWeight: FontWeight.bold),
                            'Other Partie\'s preference:'),
                      ),
                      Slider(
                        inactiveColor: Colors.white,
                        thumbColor: selectedTagColor,
                        activeColor: selectedTagColor,
                        value: sliders['Other Party Swipe'].toDouble(),
                        onChanged: (value) {
                          setState(
                            () {
                              sliders['Other Party Swipe'] = value;
                            },
                          );
                        },
                        max: 100.0,
                        min: 0.0,
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text(style: TextStyle(fontWeight: FontWeight.bold),
                            'Shared tags:'),
                      ),
                      Slider(
                        inactiveColor: Colors.white,
                        thumbColor: selectedTagColor,
                        activeColor: selectedTagColor,
                        value: sliders['Shared tags'].toDouble(),
                        onChanged: (value) {
                          setState(
                            () {
                              sliders['Shared tags'] = value;
                            },
                          );
                        },
                        max: 100.0,
                        min: 0.0,
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                      onTap: () {
                        savePreferences();
                        showDialog(
                            context: context,
                            builder: (_) => const AlertDialog(
                                  content:
                                      Text('Your preferences have been saved!'),
                                ));
                      },
                      text: "Save Preferences"),
                ],
              ));
        });
  }

  Future<void> savePreferences() async {
    await UserQueries.updatePreferences(sliders);
  }
}