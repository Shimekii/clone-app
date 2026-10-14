import 'package:flutter/material.dart';

// Обводка поля ввода
OutlineInputBorder getInputBorder(Color color){
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    borderSide: BorderSide(color: color)
  );
}


BoxDecoration btnStyle(){
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          Color(0xFF0093D9),
          Color(0xFF77B82A),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      borderRadius: BorderRadius.circular(25.0),
    );
  }