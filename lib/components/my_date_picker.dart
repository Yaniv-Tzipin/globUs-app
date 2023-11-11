import "package:flutter/material.dart";

class MyDatePicker extends StatefulWidget {
  const MyDatePicker({super.key});

  @override
  State<MyDatePicker> createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<MyDatePicker> {
  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime(2006),
        firstDate: DateTime(1925),
        lastDate: DateTime(2006));

    if (picked != null) {
      setState(() {
        _dateController.text = picked.toString().split(" ")[0];
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
          style: const TextStyle(color: Color.fromARGB(255, 176, 175, 171)),
          decoration: InputDecoration(
              hintText: 'Birth date',
              hintStyle: const TextStyle(
                  color: Color.fromARGB(255, 176, 175, 171)),
              filled: true,
              fillColor: const Color.fromARGB(255, 245, 249, 244),
              prefixIcon: const Icon(Icons.calendar_today),
              prefixIconColor: const Color.fromARGB(255, 176, 175, 171),
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
