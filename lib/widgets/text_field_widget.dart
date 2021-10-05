import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  final bool validate;
  final int maxLines;
  final String label;
  final String text;
  final ValueChanged<String> onChanged;

  const TextFieldWidget({
    Key? key,
    this.validate = true,
    this.maxLines = 1,
    required this.label,
    required this.text,
    required this.onChanged,
  }) : super(key: key);

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}



class _TextFieldWidgetState extends State<TextFieldWidget> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 35),
    child: TextField(
          onChanged: widget.onChanged,
          controller: controller,
          decoration: InputDecoration(
            errorText: widget.validate ? null : 'Incorrect email',
            contentPadding: const EdgeInsets.only(bottom: 3),
            labelText: widget.label,
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          maxLines: widget.maxLines,
        ),
  );
}

