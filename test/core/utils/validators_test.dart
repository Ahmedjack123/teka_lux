import 'package:flutter_test/flutter_test.dart';
import 'package:teka_luxe/core/utils/validators.dart';
import 'package:teka_luxe/l10n/generated/app_localizations_en.dart';

void main() {
  final l10n = AppLocalizationsEn();

  group('Validators', () {
    group('isValidEmail', () {
      test('returns true for valid emails', () {
        expect(Validators.isValidEmail('test@example.com'), isTrue);
        expect(Validators.isValidEmail('user.name@domain.co.uk'), isTrue);
        expect(Validators.isValidEmail('user+tag@example.io'), isTrue);
      });

      test('returns false for invalid emails', () {
        expect(Validators.isValidEmail(''), isFalse);
        expect(Validators.isValidEmail('not-an-email'), isFalse);
        expect(Validators.isValidEmail('@example.com'), isFalse);
        expect(Validators.isValidEmail('user@'), isFalse);
        expect(Validators.isValidEmail('user@.com'), isFalse);
      });

      test('trims whitespace before validation', () {
        expect(Validators.isValidEmail('  test@example.com  '), isTrue);
      });
    });

    group('isValidPassword', () {
      test('returns true for passwords with 6+ chars', () {
        expect(Validators.isValidPassword('123456'), isTrue);
        expect(Validators.isValidPassword('password123'), isTrue);
      });

      test('returns false for short passwords', () {
        expect(Validators.isValidPassword(''), isFalse);
        expect(Validators.isValidPassword('12345'), isFalse);
      });
    });

    group('name', () {
      test('returns null for valid names', () {
        expect(Validators.name('John', l10n), isNull);
        expect(Validators.name('  Jane Doe  ', l10n), isNull);
      });

      test('returns error for short/empty names', () {
        expect(Validators.name('', l10n), isNotNull);
        expect(Validators.name('  a  ', l10n), isNotNull);
      });
    });

    group('email', () {
      test('returns null for valid emails', () {
        expect(Validators.email('test@example.com', l10n), isNull);
      });

      test('returns required error for empty email', () {
        expect(Validators.email('', l10n), isNotNull);
      });

      test('returns invalid error for bad email', () {
        expect(Validators.email('not-an-email', l10n), isNotNull);
      });
    });

    group('phoneNumber', () {
      test('returns null for valid Libyan numbers', () {
        expect(Validators.phoneNumber('0912345678', l10n), isNull);
        expect(Validators.phoneNumber('0923456789', l10n), isNull);
        expect(Validators.phoneNumber('0934567890', l10n), isNull);
        expect(Validators.phoneNumber('0945678901', l10n), isNull);
      });

      test('returns error for empty phone', () {
        expect(Validators.phoneNumber('', l10n), isNotNull);
      });

      test('returns error for invalid Libyan numbers', () {
        expect(Validators.phoneNumber('1234567890', l10n), isNotNull);
        expect(Validators.phoneNumber('0999999999', l10n), isNotNull);
        expect(Validators.phoneNumber('091234567', l10n), isNotNull);
      });
    });

    group('password', () {
      test('returns null for valid passwords', () {
        expect(Validators.password('123456', l10n), isNull);
      });

      test('returns required error for empty password', () {
        expect(Validators.password('', l10n), isNotNull);
      });

      test('returns min length error for short passwords', () {
        expect(Validators.password('12345', l10n), isNotNull);
      });
    });

    group('confirmPassword', () {
      test('returns null when passwords match', () {
        expect(
          Validators.confirmPassword('password123', 'password123', l10n),
          isNull,
        );
      });

      test('returns required error for empty confirm', () {
        expect(
          Validators.confirmPassword('', 'password', l10n),
          isNotNull,
        );
      });

      test('returns mismatch error when different', () {
        expect(
          Validators.confirmPassword('password1', 'password2', l10n),
          isNotNull,
        );
      });
    });
  });
}
