import 'dart:math';

import 'package:base_project/core/core.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class ReplaceFormatter extends TextInputFormatter {
  ReplaceFormatter({this.decimalRange});

  final int? decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String oldText = oldValue.text;
    String newText = newValue.text;
    // if (newValue.text.formatNumber() >= 1000  ) {
    //   newText = newValue.text;
    // } else {
    // if (newValue.text.contains(other))
    if (newText.contains('.') &&
        newText.substring(newValue.text.indexOf('.') + 1).length >
            (decimalRange ?? 10)) {
      newText = oldText;
    } else if (oldText.length > newValue.text.length) {
      newText = newValue.text.replaceSemicolon(fromDecimal: ',', toDecimal: '');
    } else if ('.'.allMatches(newValue.text).isEmpty) {
      newText = newValue.text.replaceSemicolon(
        fromDecimal: ',',
        toDecimal: '.',
      );
    } else if (newValue.text.substring(
          newValue.text.length - 1,
          newValue.text.length,
        ) ==
        ',') {
      newText = newValue.text.replaceRange(
        newValue.text.length - 1,
        newValue.text.length,
        '',
      );
    }
    //  }

    // New nguoi dung nhap cham .
    if (newText.endsWith('.')) {
      // Neu old da co . thi set lai bang old
      final int last = newText.lastIndexOf('.');
      final int first = oldText.indexOf('.');
      if (oldText.contains('.') && last != first) {
        newText = oldText;
      }
    }

    return TextEditingValue(
      text: newText,
      selection: newValue.selection.copyWith(
        baseOffset: newText.length,
        extentOffset: newText.length,
      ),
    );
  }
}

class ThousandsFormatterCustomer extends NumberInputFormatter {
  ThousandsFormatterCustomer({this.formatter, this.allowFraction = false})
    : _decimalSeparator = (formatter ?? _formatter).symbols.DECIMAL_SEP,
      _decimalRegex = RegExp(
        allowFraction
            ? '[0-9]+([${(formatter ?? _formatter).symbols.DECIMAL_SEP}])?'
            : r'\d+',
      ),
      _decimalFormatter = FilteringTextInputFormatter.allow(
        RegExp(
          allowFraction
              ? '[0-9]+([${(formatter ?? _formatter).symbols.DECIMAL_SEP}])?'
              : r'\d+',
        ),
      );
  static final NumberFormat _formatter = NumberFormat.decimalPattern();

  final FilteringTextInputFormatter _decimalFormatter;
  final String _decimalSeparator;
  final RegExp _decimalRegex;

  final NumberFormat? formatter;
  final bool allowFraction;

  @override
  String _formatPattern(String? digits) {
    if (digits == null || digits.isEmpty) {
      return '';
    }
    num number;
    if (allowFraction) {
      String decimalDigits = digits;
      if (_decimalSeparator != '.') {
        decimalDigits = digits.replaceFirst(RegExp(_decimalSeparator), '.');
      }
      number = double.tryParse(decimalDigits) ?? 0.0;
    } else {
      number = int.tryParse(digits) ?? 0;
    }
    final String result = (formatter ?? _formatter).format(number);
    if (allowFraction && digits.endsWith(_decimalSeparator)) {
      return '$result$_decimalSeparator';
    }
    return result;
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text;
    newText = newValue.text
        .replaceSemicolon(fromDecimal: '.', toDecimal: '')
        .replaceSemicolon(fromDecimal: ',', toDecimal: '');
    if (newValue.text.formatNumber() <= 0) {
      newText = '';
    }
    newText = newText.formatNumber().formatVolume();
    return TextEditingValue(
      text: newText,
      selection: newValue.selection.copyWith(
        baseOffset: newText.length,
        extentOffset: newText.length,
      ),
    );
  }

  @override
  TextEditingValue _formatValue(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return _decimalFormatter.formatEditUpdate(oldValue, newValue);
  }

  @override
  bool _isUserInput(String s) {
    return s == _decimalSeparator || _decimalRegex.firstMatch(s) != null;
  }
}

///
/// An abstract class extends from [TextInputFormatter] and does numeric filter.
/// It has an abstract method `_format()` that lets its children override it to
/// format input displayed on [TextField]
///
abstract class NumberInputFormatter extends TextInputFormatter {
  TextEditingValue? _lastNewValue;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    /// nothing changes, nothing to do
    if (newValue.text == _lastNewValue?.text) {
      return newValue;
    }
    _lastNewValue = newValue;

    /// remove all invalid characters
    newValue = _formatValue(oldValue, newValue);

    /// current selection
    int selectionIndex = newValue.selection.end;

    /// format original string, this step would add some separator
    /// characters to original string
    final String newText = _formatPattern(newValue.text);

    /// count number of inserted character in new string
    int insertCount = 0;

    /// count number of original input character in new string
    int inputCount = 0;
    for (int i = 0; i < newText.length && inputCount < selectionIndex; i++) {
      final String character = newText[i];
      if (_isUserInput(character)) {
        inputCount++;
      } else {
        insertCount++;
      }
    }

    /// adjust selection according to number of inserted characters staying before
    /// selection
    selectionIndex += insertCount;
    selectionIndex = min(selectionIndex, newText.length);

    /// if selection is right after an inserted character, it should be moved
    /// backward, this adjustment prevents an issue that user cannot delete
    /// characters when cursor stands right after inserted characters
    if (selectionIndex - 1 >= 0 &&
        selectionIndex - 1 < newText.length &&
        !_isUserInput(newText[selectionIndex - 1])) {
      selectionIndex--;
    }

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: selectionIndex),
      composing: TextRange.empty,
    );
  }

  /// check character from user input or being inserted by pattern formatter
  bool _isUserInput(String s);

  /// format user input with pattern formatter
  String _formatPattern(String digits);

  /// validate user input
  TextEditingValue _formatValue(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  );
}

class ReplaceDecimalFormatter extends TextInputFormatter {
  ReplaceDecimalFormatter({
    this.decimalRange = 0,
    this.negative = false,
    // this.min,
    // this.max,
  });

  final RegExp _exp = RegExp(r'^[0-9,.-]+$');

  // count phần thập phân (default: không nhập số âm)
  final int decimalRange;

  // cho phép nhập số âm (default: false)
  final bool negative;
  //
  // // giá trị nhỏ nhất
  // final num? min;
  //
  // // giá trị lớn nhất
  // final num? max;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // check khi xoá all
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // check RegExp
    if (!_exp.hasMatch(newValue.text)) {
      return oldValue;
    }

    final int newIndex = newValue.selection.extentOffset;
    String newText = newValue.text;

    if (decimalRange == 0 && newText.contains('.')) {
      return oldValue;
    }

    // chặn nhập 2 dấu '.'
    if (newText.split('.').length > 2) {
      return oldValue;
    }

    // người dùng nhập dấu . ở cuối
    if (newText.endsWith('.')) {
      if (newIndex == newText.length) {
        return newValue;
      } else {
        return newValue.copyWith(text: newText.replaceAll('.', ''));
      }
    }

    int removeIndex = 0;
    String textStart = '';

    // có dấu - trong chuổi
    if (newText.contains('-')) {
      // cho phép nhập số âm hay không (input truyền vào)
      if (!negative) {
        return oldValue;
      }

      // nhập dấu âm đầu tiên
      if (newText == '-') {
        return newValue;
      }

      // chỉ có 1 dấu - (cho dấu âm lên đầu)
      if (newText.split('-').length <= 2) {
        textStart = '-';
      } else {
        // có 2 dấu -
        removeIndex = 2;
      }
      newText = newText.replaceAll('-', '');
    }

    final List<String> listText = newText.split('.');

    // chặn nhập quá số thập phân quy định (mặc định là 10)
    if (listText.length == 2 && listText.last.length > decimalRange) {
      return oldValue;
    }

    // fomart text
    num? integer;
    String? decimalText;

    // case chỉ có phần nguyên
    if (listText.length == 1) {
      integer = num.tryParse(listText[0].replaceAll(',', ''));
    } else {
      // case đủ 2 phần số nguyên + số thập phân
      integer = num.tryParse(listText[0].replaceAll(',', '')) ?? 0;
      decimalText = listText[1];
    }
    final String integerText = integer?.formatVolume() ?? '';
    String textOutPut = '';

    if (listText.length == 1) {
      textOutPut = integerText;
    } else {
      textOutPut = '$integerText.$decimalText';
    }

    // tính vị trí con trỏ nếu thêm dấu , hoặc xoá số 0 ở đầu
    // VD: 0001| => 1|
    // VD: 12345|6 => 123,45|6
    num countIndex = textOutPut.length - newText.length;

    // set vị trí con trỏ mới
    // countIndex : vị trí thay đổi khi format số
    // removeIndex: vị trí thay đổi khi thay đổi số âm <=> dương
    countIndex = newValue.selection.baseOffset + countIndex - removeIndex;

    // text mới
    final String newValueText = '$textStart$textOutPut';
    //
    // // đối chiếu min
    // if (min != null && min! > newValueText.formatNumber()) {
    //   return oldValue;
    // }
    // // đối chiếu max
    // if (max != null && max! < newValueText.formatNumber()) {
    //   return oldValue;
    // }

    return newValue.copyWith(
      text: newValueText,
      selection: newValue.selection.copyWith(
        baseOffset: countIndex.toInt(),
        extentOffset: countIndex.toInt(),
      ),
    );
  }
}

class TimeTextInputFormatter extends TextInputFormatter {
  TimeTextInputFormatter() {
    _exp = RegExp(r'^[0-9:]+$');
  }

  late final RegExp _exp;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (_exp.hasMatch(newValue.text)) {
      final int newIndex = newValue.selection.extentOffset;
      final int oldIndex = oldValue.selection.extentOffset;
      final String newText = newValue.text;

      final String formattedString = newText
          .replaceAll(':', '')
          .padRight(6, '0');
      final String numberText = formattedString.substring(0, 6);

      num s = numberText.substring(4, 6).formatNumber();
      num m = numberText.substring(2, 4).formatNumber();
      num h = numberText.substring(0, 2).formatNumber();
      int index = newIndex;

      if (h >= 24) {
        h = 23;
        index = 2;
      }
      if (m >= 60) {
        m = 59;
        index = 5;
      }
      if (s >= 60) {
        s = 59;
        index = 8;
      }

      final String value =
          '${h.lessBeThanTen}:${m.lessBeThanTen}:${s.lessBeThanTen}';

      if (newIndex > 8) {
        index = oldIndex;
      } else if (newIndex > oldIndex) {
        if (value.substring(newIndex).startsWith(':')) {
          index++;
        }
      } else if (newIndex == 6 || newIndex == 3) {
        if (value.substring(0, newIndex).endsWith(':')) {
          index--;
        }
      }

      return TextEditingValue(
        text: value,
        selection: newValue.selection.copyWith(
          baseOffset: index,
          extentOffset: index,
        ),
        composing: TextRange.empty,
      );
    }

    String newTexx = '';
    if (newValue.text == '') {
      newTexx = '00:00:00';
    } else {
      newTexx = (oldValue.text.isEmpty) ? '00:00:00' : oldValue.text;
    }
    return oldValue.copyWith(text: newTexx);
  }
}
