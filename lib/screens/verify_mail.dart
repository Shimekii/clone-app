import 'package:flutter/material.dart';
import 'dart:async';

class VerifyMailScreen extends StatefulWidget {
  final String email;

  const VerifyMailScreen({
    super.key,
    required this.email,
  });

  @override
  State<VerifyMailScreen> createState() => _VerifyMailScreen();
}

class _VerifyMailScreen extends State<VerifyMailScreen> {
  int secondsLeft = 30;
  Timer? timer;
  bool timerActive = false;

  final List<TextEditingController> controllers =
      List.generate(4, (_) => TextEditingController());

  final List<FocusNode> focusNodes =
      List.generate(4, (_) => FocusNode());

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
                  const Text(
                    "Подтверждение почты",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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
                      width: 200,
                      height: 200,
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
                          margin: const EdgeInsets.symmetric(
                            horizontal: 6,
                          ),
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
                                borderSide: BorderSide(
                                   color: Colors.black
                                  )
                                ),

                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black
                                )
                              )
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                if (index < controllers.length - 1) {
                                  focusNodes[index + 1].requestFocus();
                                } else {
                                  focusNodes[index].unfocus();
                                }
                              } else if (index > 0) {
                                focusNodes[index - 1].requestFocus();
                              }
                            },
                            
                          ),
                        );
                      }),
                    ),

                    SizedBox(height: 16),

                    // повторная отправка
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: timerActive
                            ? const LinearGradient(colors: [Colors.grey, Colors.grey])
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

                            style: TextStyle(color: Colors.white)
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
