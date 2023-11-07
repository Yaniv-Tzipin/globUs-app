import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:myfirstapp/components/my_button.dart";
import "package:myfirstapp/components/my_textfield.dart";

class MyDatePicker extends StatefulWidget {
  final dateController;
  MyDatePicker({super.key, required this.dateController});

  @override
  State<MyDatePicker> createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<MyDatePicker> {
  


  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime(2006),
        firstDate: DateTime(1925),
        lastDate: DateTime(2006));

    if (_picked != null) {
      setState(() {
        widget.dateController.text = _picked.toString().split(" ")[0];
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
          controller: widget.dateController,
          style: TextStyle(color: Color.fromARGB(255, 176, 175, 171)),
          decoration: InputDecoration(
              hintText: 'Birth date',
              hintStyle: const TextStyle(
                  color: Color.fromARGB(255, 176, 175, 171)),
              filled: true,
              fillColor: Color.fromARGB(255, 245, 249, 244),
              prefixIcon: const Icon(Icons.calendar_today),
              prefixIconColor: Color.fromARGB(255, 176, 175, 171),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              )),
          readOnly: true,
        ),
      ),
    );
  }
}
