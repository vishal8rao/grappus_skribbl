import 'package:intl/intl.dart';

/// Extension to make displaying [DateTime] objects simpler.
extension DateTimeEx on DateTime {
  /// Converts [DateTime] into a MMMM dd, yyyy [String].
  String get mDY {
    return DateFormat('MMMM d, yyyy').format(this);
  }
}

extension DateTimeExtension on DateTime? {
  String convertDateFormatToString(String dateFormat) {
    if (this == null) {
      return 'n/a';
    }

    return DateFormat(dateFormat).format(this!.toLocal());
  }

  String toDateFormatWithTimeOffset() {
    var timeOffsetVal = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(this!);
    final offset = this!.timeZoneOffset;
    final hours = offset.inHours > 0 ? offset.inHours : 1;

    if (!offset.isNegative) {
      timeOffsetVal =
          "$timeOffsetVal+${offset.inHours.toString().padLeft(2, '0')}:"
          "${(offset.inMinutes % (hours * 60)).toString().padLeft(2, '0')}";
    } else {
      timeOffsetVal =
          "$timeOffsetVal-${(-offset.inHours).toString().padLeft(2, '0')}:"
          "${(offset.inMinutes % (hours * 60)).toString().padLeft(2, '0')}";
    }
    return timeOffsetVal;
  }

  bool isToday() {
    final now = DateTime.now();
    return now.day == this?.day &&
        now.month == this?.month &&
        now.year == this?.year;
  }
}
