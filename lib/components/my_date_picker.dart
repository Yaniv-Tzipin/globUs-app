import "package:flutter/material.dart";
import "package:myfirstapp/components/my_button.dart";
import "package:myfirstapp/components/my_textfield.dart";

class MyDatePicker extends StatefulWidget {
  const MyDatePicker({super.key});

  @override
  State<MyDatePicker> createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<MyDatePicker> {
  
  TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate() async{
    DateTime? _picked =
      await showDatePicker(
      context: context,
      initialDate: DateTime(2006),
      firstDate: DateTime(1925),
      lastDate: DateTime(2006)
      );

      if(_picked != null){
        setState(() {
          _dateController.text = _picked.toString().split(" ")[0];
        });
      }
    }

  @override
  Widget build(BuildContext context) {

    return MaterialButton(
      onPressed: _selectDate,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextField(
          controller:  _dateController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Birth date',
            labelStyle: const TextStyle(color: Colors.white,
            fontWeight: FontWeight.bold),
            filled: true,
            prefixIcon: const Icon(Icons.calendar_today),
            prefixIconColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            )
          ),
          readOnly: true,
        ),
    
      ),
    );
  }
}