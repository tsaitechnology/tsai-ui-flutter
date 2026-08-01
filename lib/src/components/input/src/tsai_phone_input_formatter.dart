part of '../tsai_input.dart';

/// Formats a national phone number with a digit mask.
///
/// Each `#` in [mask] accepts one digit. Separators are inserted only between
/// entered digits. Deleting a separator also deletes the adjacent digit in the
/// direction of the edit, preventing the cursor from becoming stuck.
class TsaiPhoneInputFormatter extends TextInputFormatter {
  /// Creates a phone formatter.
  TsaiPhoneInputFormatter({this.mask = '### ### ## ##'})
    : assert(mask.contains('#')),
      maxDigits = '#'.allMatches(mask).length;

  /// Mask whose `#` characters represent digits.
  final String mask;

  /// Maximum digit count accepted by [mask].
  final int maxDigits;

  /// Returns only decimal digits from [value].
  static String digitsOf(String value) =>
      value.replaceAll(RegExp('[^0-9]'), '');

  /// Formats raw or partially formatted digits with [mask].
  String format(String value) => _formatDigits(
    digitsOf(value).substring(0, math.min(digitsOf(value).length, maxDigits)),
  );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = digitsOf(newValue.text);
    var baseDigitOffset = _digitsBefore(
      newValue.text,
      newValue.selection.baseOffset,
    );
    var extentDigitOffset = _digitsBefore(
      newValue.text,
      newValue.selection.extentOffset,
    );
    final oldDigits = digitsOf(oldValue.text);
    final removedOnlySeparator =
        newValue.text.length < oldValue.text.length &&
        digits == oldDigits &&
        oldValue.selection.isCollapsed &&
        newValue.selection.isCollapsed;
    if (removedOnlySeparator && digits.isNotEmpty) {
      final isBackspace =
          newValue.selection.extentOffset < oldValue.selection.extentOffset;
      final removalIndex = isBackspace ? baseDigitOffset - 1 : baseDigitOffset;
      if (removalIndex >= 0 && removalIndex < digits.length) {
        digits =
            digits.substring(0, removalIndex) +
            digits.substring(removalIndex + 1);
        baseDigitOffset = math.min(baseDigitOffset, digits.length);
        extentDigitOffset = math.min(extentDigitOffset, digits.length);
      }
    }
    if (digits.length > maxDigits) {
      digits = digits.substring(0, maxDigits);
    }
    baseDigitOffset = math.min(baseDigitOffset, digits.length);
    extentDigitOffset = math.min(extentDigitOffset, digits.length);
    final formatted = _formatDigits(digits);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection(
        baseOffset: _offsetForDigits(formatted, baseDigitOffset),
        extentOffset: _offsetForDigits(formatted, extentDigitOffset),
        affinity: newValue.selection.affinity,
        isDirectional: newValue.selection.isDirectional,
      ),
    );
  }

  String _formatDigits(String digits) {
    if (digits.isEmpty) {
      return '';
    }
    final result = StringBuffer();
    var digitIndex = 0;
    for (var maskIndex = 0; maskIndex < mask.length; maskIndex++) {
      final character = mask[maskIndex];
      if (character == '#') {
        if (digitIndex >= digits.length) {
          break;
        }
        result.write(digits[digitIndex++]);
        continue;
      }
      if (digitIndex > 0 && digitIndex < digits.length) {
        result.write(character);
      }
    }
    return result.toString();
  }

  static int _digitsBefore(String value, int offset) {
    if (offset <= 0) {
      return 0;
    }
    return digitsOf(value.substring(0, math.min(offset, value.length))).length;
  }

  static int _offsetForDigits(String value, int digitCount) {
    if (digitCount <= 0) {
      return 0;
    }
    var seen = 0;
    for (var index = 0; index < value.length; index++) {
      if (_isDigit(value.codeUnitAt(index))) {
        seen++;
        if (seen == digitCount) {
          return index + 1;
        }
      }
    }
    return value.length;
  }

  static bool _isDigit(int codeUnit) => codeUnit >= 48 && codeUnit <= 57;
}
