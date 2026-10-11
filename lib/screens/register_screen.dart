import 'package:flutter/material.dart';

enum AuthState {
  enterEmail,
  login,
  register
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool obscurePassword = false;
  bool _isPressed = false;
  bool _privacyAccepted = false;
  String selectedLanguage = 'Русский';
  AuthState state = AuthState.enterEmail;
  String validMail = "example@example.com";
  String? emailError;

  String get title {
    switch (state) {
      case AuthState.enterEmail:
        return "Какая у Вас почта?";
      case AuthState.login:
        return "С возвращением. Введите свой пароль.";
      case AuthState.register:
        return "Впервые у нас? Введите пароль для вашего аккаунта.";
    }
  }

  String get btnText {
    switch (state) {
      case AuthState.enterEmail:
        return "Продолжить";
      case AuthState.login:
        return "Войти";
      case AuthState.register:
        return "Зарегистрироваться";
    }
  }

  IconData get btnIcon {
    switch (state) {
      case AuthState.login:
      case AuthState.enterEmail:
        return Icons.login;
      case AuthState.register:
        return Icons.person_add_alt;
    }
  }

  SizedBox btnBackText(String text, VoidCallback onPressed, Icon? icon){
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            overlayColor: Colors.transparent,
            side: BorderSide.none,
          ),
          onHover: null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...{
                icon,
                const SizedBox(width: 4),
              },
              Text(
                text,
                style: TextStyle(
                  color: Colors.blueAccent,
                  decoration: _isPressed
                      ? TextDecoration.underline
                      : TextDecoration.none,
                ),
              ),
            ],
          ),
        )
      )
    );
  }  

  final TextEditingController textController = TextEditingController();

  Future<void> _showPrivacyPolicy() async {
    FocusScope.of(context).unfocus();
    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 1,
          minChildSize: 0.9,
          maxChildSize: 1,
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (context, setModalState) {
                return SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: Container(
                            width: 36,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                          children: [
                            Text(
                              'Политика конфиденциальности',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Текст политики конфиденциальности будет '
                              'размещен здесь. В нем будут описаны '
                              'собираемые данные, цели и сроки обработки, '
                              'а также способы связи по вопросам '
                              'конфиденциальности.',
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Политика конфиденциальности',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                              value: _privacyAccepted,
                              onChanged: (value) {
                                setModalState(() {
                                  _privacyAccepted = value ?? false;
                                });
                              },
                              title: const Text(
                                'Я прочитал и согласен с политикой '
                                'конфиденциальности',
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              height: 40,
                              child: DecoratedBox(
                                decoration: btnStyle(),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: const Text('Продолжить'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> _selectLanguage() async {
    final language = await showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.4,
          minChildSize: 0.25,
          maxChildSize: 1,
          builder: (context, scrollController) {
            return SafeArea(
              child: ListView(
                controller: scrollController,
                padding: EdgeInsets.zero,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  ...['Русский', 'English'].map((language) {
                    final isSelected = language == selectedLanguage;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Stack(
                        children: [
                          Container(
                            color: isSelected
                                ? const Color(0xFFE8F5E9)
                                : Colors.transparent,
                            child: ListTile(
                              leading: Icon(
                                Icons.check,
                                color: isSelected
                                    ? Colors.green
                                    : Colors.transparent,
                              ),
                              title: Text(
                                language,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.green.shade800
                                      : null,
                                  fontWeight:
                                      isSelected ? FontWeight.w600 : null,
                                ),
                              ),
                              onTap: () => Navigator.pop(context, language),
                            ),
                          ),
                          if (isSelected)
                            Positioned(
                              left: 0,
                              top: 0,
                              bottom: 0,
                              width: 4,
                              child: ColoredBox(color: Colors.green.shade800),
                            ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );

    if (language != null) {
      setState(() => selectedLanguage = language);
    }
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

  Widget buildAction(){
    switch(state){
      case AuthState.enterEmail:
        obscurePassword = false;
        return SizedBox(
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
            child: const Text("Пропустить >>"),
          ),
        );
      case AuthState.login:
        return btnBackText("Вернуться назад", () {
          setState(() {
            state = AuthState.enterEmail;
            obscurePassword = false;
            textController.clear();
            emailError = null;
          });
        },
        Icon(
          Icons.arrow_back_ios,
          color: Colors.blueAccent,
          size: 16,
        ),
      );
      case AuthState.register:
        return SizedBox();
    }
  }

  String? checkErrors(){
    switch(state){
      case AuthState.enterEmail:
        final emailRegex = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');
        String email = textController.text;
        if (email.isEmpty) {
          return "Введите почту";
        }

        if (!emailRegex.hasMatch(email)){
          return "Введите корректную почту";
        }      
      case AuthState.register:
      case AuthState.login:
        String password = textController.text;
        if (password.isEmpty) {
          return "Введите пароль";
        }
    }
    return null;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ColoredBox(color: Colors.white.withValues(alpha: 0.8)),
          SafeArea(
            child: AnimatedPadding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // выбор языка
                    if (state == AuthState.enterEmail) ...{
                      const Text('Выберите язык'),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: InkWell(
                          onTap: _selectLanguage,
                          child: InputDecorator(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFF3F7E9),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 0,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(
                                  color: Color(0xFFDEEACC),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(
                                  color: Color(0xFFDEEACC),
                                ),
                              ),
                              suffixIcon: const Icon(Icons.expand_more),
                            ),
                            child: Text(selectedLanguage),
                          ),
                        ),
                      ),
                    },
                    
                    const Spacer(),
                    
                    // заголовок/текст
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              height: 1,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          // поле ввода
                          TextField(
                            controller: textController,
                            obscureText: obscurePassword,
                            decoration: InputDecoration(
                              errorText: emailError,
                              filled: true,
                              fillColor: const Color(0xFFF3F7E9),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 0,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(
                                  color: Color(0xFFDEEACC),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(
                                  color: Color(0xFFDEEACC),
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              suffixIcon: state != AuthState.enterEmail
                                  ? IconButton(
                                      icon: Icon(
                                        obscurePassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          obscurePassword = !obscurePassword;
                                        });
                                      },
                                    )
                                  : null,
                            ),
                          ),
                          
                          const SizedBox(height: 8),

                          // кнопка продолжения
                          SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: DecoratedBox(
                              decoration: btnStyle(),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  String? error = checkErrors();
                                  if (error != null){
                                    setState(() {
                                      emailError = error;
                                    });
                                    return;
                                  }
                                  switch(state){
                                    case AuthState.enterEmail:
                                      String email = textController.text;
                                      setState(() {
                                      emailError = null;
                                      textController.clear();
                                      obscurePassword = true;
                                      state = email == validMail
                                        ? AuthState.login
                                        : AuthState.register;
                                    });
                                    case AuthState.login:
                                      setState(() {
                                        emailError = null;
                                      });
                                      // ДОБАВИТЬ ЛОГИКУ
                                      // ДОБАВИТЬ ЛОГИКУ
                                      // ДОБАВИТЬ ЛОГИКУ
                                      // ДОБАВИТЬ ЛОГИКУ
                                      break;
                                    case AuthState.register:
                                      setState(() {
                                        emailError = null;
                                      });
                                      _showPrivacyPolicy();
                                      break;
                                  }
                                },
                                icon: Icon(btnIcon, color: Colors.white),
                                label: Text(
                                  btnText,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  shadowColor: Colors.transparent,
                                  minimumSize: const Size(double.infinity, 40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    if (state == AuthState.login) ...{
                      btnBackText("Забыли пароль?", () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Отправлено письмо с запросом на восстановление."),
                            content: Text("Если вы указали зарегистрированный адрес электронной почты, проверьте его,"
                                          "чтобы узнать дальнейшие шаги по сбросу пароля."),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("OK", style: TextStyle(color: Color(0xFF018577)),)
                              )
                            ],
                          ),
                        );
                      },null // иконка
                      )
                    },
                    
                    if (state == AuthState.register) ...{
                      btnBackText("Вернуться назад", () {
                        setState(() {
                          state = AuthState.enterEmail;
                          obscurePassword = false;
                          textController.clear();
                          emailError = null;
                        });
                      },
                      Icon(
                        Icons.arrow_back_ios,
                        color: Colors.blueAccent,
                        size: 16,
                        )
                      )
                    },

                    const Spacer(),

                    // кнопка пропустить
                    buildAction()
                    /*SizedBox(
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
                        child: const Text("Пропустить >>"),
                      ),
                    ),*/
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}