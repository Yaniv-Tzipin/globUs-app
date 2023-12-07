import "package:flutter/material.dart";

class MyDatePicker extends StatefulWidget {
  final dateController;
  const MyDatePicker({super.key, required this.dateController});

  @override
  State<MyDatePicker> createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<MyDatePicker> {


  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime(2006),
        firstDate: DateTime(1925),
        lastDate: DateTime(2006));

    if (picked != null) {
      setState(() {
        widget.dateController.text = picked.toString().split(" ")[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: (){},
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextField(
          controller: widget.dateController,
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
          onTap: _selectDate,
        ),
      ),
    );
  }
}
