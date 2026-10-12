import 'package:evgo_clone/screens/form.dart';
import 'package:evgo_clone/screens/register_screen.dart';
import 'package:evgo_clone/screens/verify_mail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('form scrolls and lays out on a narrow screen', (tester) async {
    tester.view.physicalSize = const Size(320, 480);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(home: FormScreen(email: 'test@example.com')),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(SingleChildScrollView), findsOneWidget);

    final emailField = tester.getRect(find.byKey(const ValueKey('field-email')));
    final phoneField = tester.getRect(find.byKey(const ValueKey('field-phone')));
    final countryField = tester.getRect(
      find.byKey(const ValueKey('picker-country')),
    );
    expect(emailField.left, 24);
    expect(countryField.left, emailField.left);
    expect(phoneField.right, emailField.right);

    await tester.ensureVisible(find.text('Область'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('valid verification code opens the form', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(home: VerifyMailScreen(email: 'test@example.com')),
    );
    await tester.pump();
    expect(
      tester.takeException(),
      isNull,
      reason: 'initial verification layout',
    );

    for (var index = 0; index < 4; index++) {
      await tester.enterText(find.byType(TextField).at(index), '1');
      await tester.pump();
      expect(
        tester.takeException(),
        isNull,
        reason: 'verification layout after digit ${index + 1}',
      );
    }
    await tester.pumpAndSettle();

    expect(find.text('Контактные данные'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('invalid verification code shows a dismissible error banner', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(home: VerifyMailScreen(email: 'test@example.com')),
    );
    await tester.pump();

    for (var index = 0; index < 4; index++) {
      await tester.enterText(find.byType(TextField).at(index), '2');
      await tester.pump();
    }

    final banner = find.byKey(const ValueKey('invalid-code-banner'));
    expect(banner, findsOneWidget);
    expect(
      find.text('Неверный код. Проверьте и попробуйте еще раз'),
      findsOneWidget,
    );
    expect(
      find.descendant(of: banner, matching: find.byIcon(Icons.close)),
      findsOneWidget,
    );
    expect(find.text('Контактные данные'), findsNothing);

    await tester.enterText(find.byType(TextField).first, '1');
    await tester.pump();
    expect(banner, findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('country pickers filter and update their fields', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: FormScreen(email: 'test@example.com')),
    );

    await tester.tap(find.byKey(const ValueKey('picker-code')));
    await tester.pumpAndSettle();
    final sheetHeight = tester
        .getSize(find.byType(DraggableScrollableSheet))
        .height;
    final screenHeight = tester.getSize(find.byType(Scaffold)).height;
    expect(sheetHeight, greaterThanOrEqualTo(screenHeight * 0.99));

    final searchField = find.byKey(const ValueKey('country-picker-search'));
    expect(find.text('Поиск'), findsOneWidget);
    await tester.enterText(searchField, 'Казахстан');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Казахстан'));
    await tester.pumpAndSettle();

    final codeField = tester.widget<TextFormField>(
      find.byKey(const ValueKey('picker-code')),
    );
    expect(codeField.controller!.text, '+7');
    final codeDecoration = tester.widget<InputDecorator>(
      find.descendant(
        of: find.byKey(const ValueKey('picker-code')),
        matching: find.byType(InputDecorator),
      ),
    );
    expect(codeDecoration.decoration.prefixText, '🇰🇿 ');

    await tester.ensureVisible(find.byKey(const ValueKey('picker-country')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('picker-country')));
    await tester.pumpAndSettle();
    await tester.enterText(searchField, 'Германия');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Германия'));
    await tester.pumpAndSettle();

    final countryField = tester.widget<TextFormField>(
      find.byKey(const ValueKey('picker-country')),
    );
    expect(countryField.controller!.text, 'Германия');
    final countryDecoration = tester.widget<InputDecorator>(
      find.descendant(
        of: find.byKey(const ValueKey('picker-country')),
        matching: find.byType(InputDecorator),
      ),
    );
    expect(countryDecoration.decoration.prefixText, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('save button enables only for a valid form', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: FormScreen(email: 'test@example.com')),
    );

    final saveButton = find.widgetWithText(
      ElevatedButton,
      'Сохранить изменения',
    );
    expect(tester.widget<ElevatedButton>(saveButton).onPressed, isNull);
    var decoration =
        tester
                .widget<DecoratedBox>(
                  find.byKey(const ValueKey('save-button-container')),
                )
                .decoration
            as BoxDecoration;
    expect((decoration.gradient! as LinearGradient).colors, [
      Colors.grey,
      Colors.grey,
    ]);

    await tester.enterText(find.byKey(const ValueKey('field-phone')), '123456');
    await tester.enterText(
      find.byKey(const ValueKey('field-postCode')),
      '12345',
    );
    await tester.pump();

    expect(tester.widget<ElevatedButton>(saveButton).onPressed, isNotNull);
    decoration =
        tester
                .widget<DecoratedBox>(
                  find.byKey(const ValueKey('save-button-container')),
                )
                .decoration
            as BoxDecoration;
    expect((decoration.gradient! as LinearGradient).colors, [
      const Color(0xFF0093D9),
      const Color(0xFF77B82A),
    ]);
  });

  testWidgets('keyboard overlays the form without resizing it', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(home: FormScreen(email: 'test@example.com')),
    );

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.resizeToAvoidBottomInset, isFalse);
    final scrollView = find.byType(SingleChildScrollView);
    final heightWithoutKeyboard = tester.getSize(scrollView).height;

    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pump();

    expect(tester.getSize(scrollView).height, heightWithoutKeyboard);
    expect(tester.takeException(), isNull);
  });

  testWidgets('privacy consent is required before continuing', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));

    await tester.enterText(find.byType(TextField).first, 'new@example.com');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Продолжить'));
    await tester.pump();
    await tester.enterText(find.byType(TextField).first, 'test-password');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Зарегистрироваться'));
    await tester.pumpAndSettle();

    final policyLink = tester.getRect(
      find.text('Условия использования и политика конфиденциальности'),
    );
    final consentCheckbox = tester.getRect(find.byType(CheckboxListTile));
    expect(consentCheckbox.top - policyLink.bottom, lessThan(100));

    final continueButton = find.widgetWithText(ElevatedButton, 'Продолжить');
    await tester.tap(continueButton);
    await tester.pump();

    expect(find.text('Обязательное поле'), findsOneWidget);
    expect(
      tester.widget<Text>(find.text('Обязательное поле')).style!.color,
      Colors.red,
    );
    expect(find.text('Подтверждение почты'), findsNothing);

    await tester.tap(find.byType(CheckboxListTile));
    await tester.pump();
    expect(find.text('Обязательное поле'), findsNothing);

    await tester.tap(continueButton);
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Подтверждение почты'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
