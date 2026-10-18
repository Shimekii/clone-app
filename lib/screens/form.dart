import 'package:evgo_clone/screens/map_screen.dart';
import 'package:evgo_clone/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _CountryOption {
  const _CountryOption({
    required this.name,
    required this.dialingCode,
    required this.flag,
  });

  final String name;
  final String dialingCode;
  final String flag;
}

const _countryOptions = [
  _CountryOption(name: 'Россия', dialingCode: '+7', flag: '🇷🇺'),
  _CountryOption(name: 'Казахстан', dialingCode: '+7', flag: '🇰🇿'),
  _CountryOption(name: 'Беларусь', dialingCode: '+375', flag: '🇧🇾'),
  _CountryOption(name: 'Украина', dialingCode: '+380', flag: '🇺🇦'),
  _CountryOption(name: 'Грузия', dialingCode: '+995', flag: '🇬🇪'),
  _CountryOption(name: 'Турция', dialingCode: '+90', flag: '🇹🇷'),
  _CountryOption(name: 'Германия', dialingCode: '+49', flag: '🇩🇪'),
  _CountryOption(name: 'Франция', dialingCode: '+33', flag: '🇫🇷'),
  _CountryOption(name: 'Италия', dialingCode: '+39', flag: '🇮🇹'),
  _CountryOption(name: 'Испания', dialingCode: '+34', flag: '🇪🇸'),
  _CountryOption(name: 'Великобритания', dialingCode: '+44', flag: '🇬🇧'),
  _CountryOption(name: 'США', dialingCode: '+1', flag: '🇺🇸'),
];

class FormScreen extends StatefulWidget {
  final String email;
  const FormScreen({super.key, required this.email});

  @override
  State<FormScreen> createState() => _FormScreen();
}

class _FormScreen extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  _CountryOption _selectedCode = _countryOptions.first;
  _CountryOption _selectedCountry = _countryOptions.first;
  bool isValid = false;
  final Map<String, TextEditingController> controllers = {
    "email": TextEditingController(),
    "name": TextEditingController(),
    "surname": TextEditingController(),
    "code": TextEditingController(),
    "phone": TextEditingController(),
    "address": TextEditingController(),
    "postCode": TextEditingController(),
    "city": TextEditingController(),
    "country": TextEditingController(),
    "region": TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    controllers['code']!.text = _selectedCode.dialingCode;
    controllers['country']!.text = _selectedCountry.name;
  }

  InputDecoration _fieldDecoration({
    String? hintText,
    String? prefixText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      isDense: true,
      filled: true,
      fillColor: const Color(0xFFF3F7E9),
      hintText: hintText,
      prefixText: prefixText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      suffixIconConstraints: suffixIcon == null
          ? null
          : const BoxConstraints(minWidth: 32, minHeight: 40),
      enabledBorder: getInputBorder(const Color(0xFFDEEACC)),
      focusedBorder: getInputBorder(const Color(0xFFDEEACC)),
      errorBorder: getInputBorder(Colors.red),
      focusedErrorBorder: getInputBorder(Colors.red),
    );
  }

  Widget buildField({
    required String keyName,
    required String label,
    bool required = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        TextFormField(
          key: ValueKey('field-$keyName'),
          controller: controllers[keyName],
          decoration: _fieldDecoration(),
          validator: (value) {
            if (required && (value == null || value.trim().isEmpty)) {
              return "Обязательное поле";
            }
            return null;
          },

          onChanged: (_) {
            setState(() {
              isValid = _formKey.currentState?.validate() ?? false;
            });
          },
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget buildPickerField({
    required String keyName,
    required String label,
    required bool isDialingCode,
  }) {
    final selected = isDialingCode ? _selectedCode : _selectedCountry;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        TextFormField(
          key: ValueKey('picker-$keyName'),
          controller: controllers[keyName],
          readOnly: true,
          onTap: () async {
            final option = await _showCountryPicker(
              selected: selected,
              showDialingCodes: isDialingCode,
            );
            if (option == null || !mounted) return;

            setState(() {
              if (isDialingCode) {
                _selectedCode = option;
                controllers[keyName]!.text = option.dialingCode;
              } else {
                _selectedCountry = option;
                controllers[keyName]!.text = option.name;
              }
              isValid = _formKey.currentState?.validate() ?? false;
            });
          },
          decoration: _fieldDecoration(
            prefixText: isDialingCode ? '${selected.flag} ' : null,
            suffixIcon: const Icon(Icons.arrow_drop_down),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Обязательное поле';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Future<_CountryOption?> _showCountryPicker({
    required _CountryOption selected,
    required bool showDialingCodes,
  }) async {
    return showModalBottomSheet<_CountryOption>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        var searchQuery = '';
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final query = searchQuery.trim().toLowerCase();
            final options = _countryOptions.where((option) {
              return option.name.toLowerCase().contains(query) ||
                  option.dialingCode.contains(query);
            }).toList();

            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 1,
              minChildSize: 1,
              maxChildSize: 1,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: TextField(
                        key: const ValueKey('country-picker-search'),
                        decoration: _fieldDecoration(
                          hintText: 'Поиск',
                          prefixIcon: const Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          setSheetState(() => searchQuery = value);
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final option = options[index];
                          final isSelected = option == selected;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Stack(
                              children: [
                                Material(
                                  color: isSelected
                                      ? const Color(0xFFE8F5E9)
                                      : Colors.transparent,
                                  child: ListTile(
                                    leading: showDialingCodes
                                        ? Text(
                                            option.flag,
                                            style: const TextStyle(
                                              fontSize: 22,
                                            ),
                                          )
                                        : Icon(
                                            Icons.check,
                                            color: isSelected
                                                ? Colors.green
                                                : Colors.transparent,
                                          ),
                                    title: Text(
                                      option.name,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.green.shade800
                                            : null,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : null,
                                      ),
                                    ),
                                    trailing: showDialingCodes
                                        ? Text(
                                            option.dialingCode,
                                            style: TextStyle(fontSize: 16),
                                          )
                                        : null,
                                    onTap: () => Navigator.pop(context, option),
                                  ),
                                ),
                                if (isSelected)
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    bottom: 0,
                                    width: 4,
                                    child: ColoredBox(
                                      color: Colors.green.shade800,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    for (final controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controllers['email']!.text = widget.email;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // Добавить логику
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MapScreen())
                      );
                    },
                    icon: const Icon(Icons.close, size: 24),
                  ),
                  const Expanded(
                    child: Text(
                      "Контактные данные",
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

              SizedBox(height: 16),

              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        buildField(keyName: "email", label: "E-Mail*"),
                        buildField(keyName: "name", label: "Имя", required: false),
                        buildField(keyName: "surname", label: "Фамилия", required: false),
                        Row(
                          children: [
                            SizedBox(
                              width: 120,
                              child: buildPickerField(
                                keyName: "code",
                                label: "Код",
                                isDialingCode: true,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: buildField(
                                keyName: "phone",
                                label: "Телефон*",
                              ),
                            ),
                          ],
                        ),
                        buildField(keyName: "address", label: "Адрес", required: false),
                        buildField(keyName: "postCode", label: "Почтовый индекс", required: false),
                        buildField(keyName: "city", label: "Город", required: false),
                        buildPickerField(
                          keyName: "country",
                          label: "Страна",
                          isDialingCode: false,
                        ),
                        buildField(keyName: "region", label: "Область", required: false),
                      ],
                    ),
                  ),
                ),
              ),

              // const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 40,
                child: greenButton(
                  text: "Сохранить изменения",
                  icon: Icons.save_outlined,
                  onPressed: isValid
                      ? () async {
                        // Логика на сохранение данных
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool("formComplete", true);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MapScreen())
                        );
                      }
                      : null,
                  isActive: isValid
                )
              ),

              SizedBox(height: 8),

              // пропустить
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // Действие при нажатии кнопки "Пропустить"
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MapScreen())
                    );
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
      ),
    );
  }
}
