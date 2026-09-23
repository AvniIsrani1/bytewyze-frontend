import 'package:flutter/material.dart';

class InternalLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const InternalLink({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: onTap, 
      child: Text(
        text,
        style: TextStyle(
          decoration: TextDecoration.underline, 
          fontWeight: FontWeight.bold,         
        ),
      ),
    );
  }
}