import 'package:flutter/material.dart';

import 'dart:async';

import 'form.dart';

class VerifyMailScreen extends StatefulWidget {
  final String email;

  const VerifyMailScreen({super.key, required this.email});

  @override
  State<VerifyMailScreen> createState() => _VerifyMailScreen();
}

class _VerifyMailScreen extends State<VerifyMailScreen> {
  int secondsLeft = 30;
  Timer? timer;
  bool timerActive = false;
  bool showInvalidCode = false;

  final List<TextEditingController> controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  void startTimer() {
    setState(() {
      secondsLeft = 60;
      timerActive = true;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft > 1) {
        setState(() {
          secondsLeft--;
        });
      } else {
        timer.cancel();

        setState(() {
          secondsLeft = 0;
          timerActive = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }

    for (final node in focusNodes) {
      node.dispose();
    }
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.email;
    int validCode = 1111;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // Добавить логику
                    },
                    icon: const Icon(Icons.close, size: 24),
                  ),
                  const Expanded(
                    child: Text(
                      "Подтверждение почты",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/mail.jpg',
                      width: 150,
                      height: 150,
                    ),
                    Text(
                      'Мы отправили код подтверждения на адрес $email. '
                      'Введите код ниже или перейдите по ссылке '
                      'в электронном письме для подтверждения',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),

                    // ввод кода
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        return Container(
                          width: 50,
                          height: 60,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          child: TextField(
                            style: TextStyle(fontSize: 24),
                            cursorColor: Colors.black,
                            controller: controllers[index],
                            focusNode: focusNodes[index],
                            maxLength: 1,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              counterText: "",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),

                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            onChanged: (value) {
                              if (showInvalidCode) {
                                setState(() => showInvalidCode = false);
                              }
                              if (value.isNotEmpty) {
                                if (index < controllers.length - 1) {
                                  focusNodes[index + 1].requestFocus();
                                } else {
                                  focusNodes[index].unfocus();
                                  final enteredCode = controllers
                                      .map((controller) => controller.text)
                                      .join();
                                  if (enteredCode == validCode.toString()) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            FormScreen(email: email),
                                      ),
                                    );
                                  } else {
                                    setState(() => showInvalidCode = true);
                                  }
                                }
                              } else if (index > 0) {
                                focusNodes[index - 1].requestFocus();
                              }
                            },
                          ),
                        );
                      }),
                    ),

                    if (showInvalidCode) ...[
                      const SizedBox(height: 12),
                      Container(
                        key: const ValueKey('invalid-code-banner'),
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFED2D1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Неверный код. Проверьте и попробуйте еще раз',
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    SizedBox(height: 16),

                    // повторная отправка
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: timerActive
                              ? const LinearGradient(
                                  colors: [Colors.grey, Colors.grey],
                                )
                              : const LinearGradient(
                                  colors: [
                                    Color(0xFF0093D9),
                                    Color(0xFF77B82A),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: ElevatedButton(
                          onPressed: timerActive
                              ? null
                              : () {
                                  startTimer();
                                  // повторная отправка кода
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            timerActive
                                ? 'Отправить повторно через $secondsLeft сек.'
                                : 'Отправить код повторно',

                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 8),

                    // пропустить
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Действие при нажатии кнопки "Пропустить"
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          side: const BorderSide(
                            color: Color(0xFF0094DA),
                            width: 1.5,
                          ),
                        ),
                        child: const Text("Пропустить и продолжить потом >>"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
