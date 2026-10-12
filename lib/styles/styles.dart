import 'package:flutter/material.dart';

// Обводка поля ввода
OutlineInputBorder getInputBorder(Color color){
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    borderSide: BorderSide(color: color)
  );
}