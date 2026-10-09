import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String selectedLanguage = 'Русский';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          )
        ),
        child: Container(
          color: Colors.white.withValues(alpha: 0.8),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),

              // выбор языка
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Выберите язык'),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: InkWell(
                      onTap: _selectLanguage,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFF3F7E9),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Color(0xFFDEEACC))
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Color(0xFFDEEACC))
                          ),

                          suffixIcon: Icon(Icons.expand_more),
                        ),
                        child: Text(selectedLanguage),
                      ),
                    ),
                  ),

                  Spacer(),

                  // ввод почты
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Какая у Вас почта?",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFF3F7E9),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(color: Color(0xFFDEEACC))
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(color: Color(0xFFDEEACC))
                            ),

                            
                          ),
                        ),
                        SizedBox(height: 8),

                        // кнопка подтверждения
                        SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF0093D9),
                                  Color(0xFF77B82A),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // Действие при нажатии кнопки
                              },
                              icon: const Icon(
                                Icons.login,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Продолжить',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
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
                        )
                      ],
                    ),
                  ),
                  Spacer(),

                  // кнопка пропустить
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (){
                        // Действие при нажатии кнопки "Пропустить"
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        side: BorderSide(
                          color: Color(0xFF0094DA), width: 1.5),
                      ),
                      child: Text("Пропустить >>"),
                    )
                  )
                ],
              )
            )
          )
        )
      )
    );
  }
}