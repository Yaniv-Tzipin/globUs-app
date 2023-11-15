import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:myfirstapp/components/my_colors.dart';

class MyCountryPicker extends StatefulWidget {
  final TextEditingController pickedCountry;
  const MyCountryPicker({super.key, required this.pickedCountry});

  @override
  State<MyCountryPicker> createState() => _MyCountryPickerState();
}

class _MyCountryPickerState extends State<MyCountryPicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(3),
          color: const Color.fromARGB(255, 245, 249, 244),),
          width: 340,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.map,
              color:  Color.fromARGB(255, 176, 175, 171)),
              SizedBox(width: 20,),
              Text('Choose your origin country:',
              style: TextStyle(color: Color.fromARGB(255, 176, 175, 171),),),
            ],
          ),
        ),
        Container(
          width: 340,
          height: 30,
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 245, 249, 244),
              borderRadius: BorderRadius.circular(2)),
          child: CountryListPick(
              appBar: AppBar(
                title: const Text('Choose your origin country'),
                backgroundColor: toolBarColor
              ),
              theme: CountryTheme(
                alphabetSelectedBackgroundColor: toolBarColor,
                  labelColor: toolBarColor,
                  isShowFlag: true,
                  isShowCode: false,
                  isShowTitle: false,
                  isDownIcon: false,
                  showEnglishName: true),
              useUiOverlay: true,
              onChanged: (CountryCode? code) {
                widget.pickedCountry.text = code?.name ?? "";
              }),
        ),
      ],
    );
  }
}
