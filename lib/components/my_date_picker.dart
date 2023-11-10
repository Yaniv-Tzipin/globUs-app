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

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime(2006),
        firstDate: DateTime(1925),
        lastDate: DateTime(2006));

    if (_picked != null) {
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
          controller: _dateController,
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
                  borderRadius: BorderRadius.circular(8),
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
