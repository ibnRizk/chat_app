import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String textname;
  final Color colour;
  final VoidCallback onpress;

  const RoundedButton(
      {super.key,
      required this.textname,
      required this.colour,
      required this.onpress});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onpress,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            textname,
          ),
        ),
      ),
    );
  }
}
