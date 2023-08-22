import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringExtension on String? {
  String get orEmpty {
    if (this != null) {
      return this!;
    } else {
      return '';
    }
  }

  String get getInitials => isNotNullOrEmpty
      ? this!.trim().split(RegExp(' +')).map((s) => s[0]).take(3).join()
      : '';

  bool get isNotNullOrEmpty {
    if (this != null && this!.isNotEmpty) {
      return true;
    }
    return false;
  }

  bool get isNullOrEmpty {
    if (this == null || this!.isEmpty) {
      return true;
    }
    return false;
  }

  bool get isNull {
    if (this == null) {
      return true;
    }
    return false;
  }

  String get capitalizeFirstChar {
    return '${this?[0].toUpperCase()}${this?.substring(1).toLowerCase()}';
  }

  String get capitalizeFirstOfEach {
    if (isNullOrEmpty) {
      return '';
    }
    return this!
        .replaceAll(RegExp(' +'), ' ')
        .split(' ')
        .map((str) => str.capitalizeFirstChar)
        .join(' ');
  }

  String get toTitleCase {
    return this!.toLowerCase().replaceAllMapped(
        RegExp(
          r'[A-Z]{2,}(?=[A-Z][a-z]+[0-9]*|\b)|[A-Z]?[a-z]+[0-9]*|[A-Z]|[0-9]+',
        ), (Match match) {
      return '''${match[0]![0].toUpperCase()}${match[0]?.substring(1).toLowerCase()}''';
    });
  }

  DateTime toDate(String dateFormat) {
    return DateFormat(dateFormat).parse(this!).toLocal();
  }

  String toDateFormat(String inDateFormat, String outDateFormat) {
    final parseDate = DateFormat(inDateFormat).parse(this!);
    final inputDate = DateTime.parse(parseDate.toString());
    final outputFormat = DateFormat(outDateFormat);
    return outputFormat.format(inputDate);
  }

  String or(String value) {
    if (isNotNullOrEmpty) {
      return this!;
    } else {
      return value;
    }
  }

  String orCondition(String value, {required bool condition}) {
    if (condition) {
      return this!;
    } else {
      return value;
    }
  }

  String get truncateFirstname {
    final words = this!.split(' ');
    if (words.length == 1) {
      return this!;
    }
    final sb = StringBuffer()..write('${words[0][0]}.');
    for (var i = 1; i < words.length; i++) {
      sb.write(' ${words[i]}');
    }
    return sb.toString();
  }

  String get truncateWordsUpToThreeChar {
    if (isNullOrEmpty) {
      return '';
    }
    final words = this!.split(' ');
    if (words.length == 1) {
      return this!;
    }
    final sb = StringBuffer();
    for (var i = 0; i < words.length; i++) {
      if (words[i].length <= 3) {
        if (i == 0) {
          sb.write('${words[i]} ');
        } else {
          sb.write(' ${words[i]}');
        }
      } else {
        final subString = words[i].substring(0, 4);
        if (i == 0) {
          sb.write('$subString ');
        } else {
          sb.write(' $subString');
        }
      }
    }
    return sb.toString();
  }

  bool isValidEmail() {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(this!);
  }

  Color toColor() {
    var hexColor = this!.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    if (hexColor.length == 8) {
      return Color(int.parse('0x$hexColor'));
    }
    return Colors.white;
  }
}
