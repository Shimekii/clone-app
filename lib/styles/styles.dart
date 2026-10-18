import 'package:flutter/material.dart';

// Обводка поля ввода
OutlineInputBorder getInputBorder(Color color){
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    borderSide: BorderSide(color: color)
  );
}

// стиль для кнопки
BoxDecoration btnStyle(bool isActive){
    return BoxDecoration(
      gradient: isActive ? 
          const LinearGradient(
            colors: [Color(0xFF0093D9), Color(0xFF77B82A)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        )
        : const LinearGradient(
            colors: [Colors.grey, Colors.grey],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      borderRadius: BorderRadius.circular(25.0),
    );
  }

// зеленая кнопка в приложении
DecoratedBox greenButton({required String text, required IconData? icon, required VoidCallback? onPressed, bool isActive = true}){
  return DecoratedBox(
    decoration: btnStyle(isActive),
    child: ElevatedButton.icon(
      onPressed: onPressed,
      label: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      icon: icon != null ? Icon(icon, color: Colors.white) : null,
      
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        shadowColor: Colors.transparent,
        minimumSize: const Size(
          double.infinity,
          40,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            25.0,
          ),
        ),
      ),
    ),
  );
}

// Вспомогательная функция для секунд
String renderLabel(int seconds){
  int hour = seconds ~/ 3600;
  int minutes = (seconds % 3600) ~/ 60;
  int sec = seconds % 60;
  if (hour != 0){
    return "Запущено $hour ч. $minutes мин. $sec сек. назад";
  }
  else if (minutes != 0){
    return "Запущено $minutes мин. $sec сек. назад";
  }
  else {
    return "Запущено $sec сек. назад";
  }
}