import 'package:flutter/material.dart';

class TextFieldWithTitleWidget extends StatefulWidget {
  final int maxLines;
  final String label;
  final String text;
  final TextEditingController controller;
  // final ValueChanged<String> onChanged;

  const TextFieldWithTitleWidget({
    Key? key,
    this.maxLines = 1,
    required this.label,
    required this.text,
    required this.controller,
    // required this.onChanged,
  }) : super(key: key);

  @override
  _TextFieldWithTitleWidgetState createState() =>
      _TextFieldWithTitleWidgetState(controller : controller, hintText: text);
}

class _TextFieldWithTitleWidgetState extends State<TextFieldWithTitleWidget> {
  final TextEditingController controller;
  final String hintText;

  _TextFieldWithTitleWidgetState({Key? key,
  required this.controller,
  required this.hintText,
  }) : super();

  @override
  void dispose() {
    this.controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[400]),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            maxLines: widget.maxLines,
          ),
        ],
      );
}
