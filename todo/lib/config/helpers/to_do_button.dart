import 'package:flutter/material.dart';

class ToDoButton extends StatelessWidget {
  const ToDoButton(
      {super.key, required this.buttonText, required this.buttonMethod});
  final String buttonText;
  final Function buttonMethod;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.0,
      width: 150,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: const LinearGradient(
              colors: [Color(0xFF444FFF), Color(0xFF850AFF)])),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent),
          onPressed: () {
            buttonMethod();
          },
          child: Text(buttonText)),
    );
  }
}
