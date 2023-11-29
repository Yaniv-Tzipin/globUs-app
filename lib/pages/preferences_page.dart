
import 'package:flutter/material.dart';
import 'package:myfirstapp/components/my_button.dart';
import 'package:myfirstapp/queries/users_quries.dart';

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
              appBar: AppBar(
                title: const Text(
                  'Define features importance',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 139, 189, 139)),
                ),
              ),
              body: Column(
                children: [
                  Column(
                    children: [
                      Text(
                          'Age, importance: ${sliders['Age'].toInt().toString()}'),
                      Slider(
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
                    children: [
                      Text(
                          'Location, importance: ${sliders['Location'].toInt().toString()}'),
                      Slider(
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
                    children: [
                      Text(
                          'Origin country, importance: ${sliders['Origin country'].toInt().toString()}'),
                      Slider(
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
                    children: [
                      Text(
                          'Other Party Swipe, importance: ${sliders['Other Party Swipe'].toInt().toString()}'),
                      Slider(
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
                    children: [
                      Text(
                          'Shared tags, importance: ${sliders['Shared tags'].toInt().toString()}'),
                      Slider(
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
