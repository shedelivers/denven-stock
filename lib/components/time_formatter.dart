import 'package:intl/intl.dart';
// import 'package:timeago/timeago.dart' as timeago;

String hourlyFormatter = 'hh:mm a';
String dayFormatter = "yyyy-MM-dd";
String mainDateFormatter = "yyyy-MM-dd HH:mm:ss";
String monthDayYearlyFormatter = "MMM dd,yyyy";
String monthDayYearFormatter = "MM/dd/yyyy";
String utcTimeFormatted = "yyyy-MM-dd'T'HH:mm:ss.SSS";
String utcdateToString(String dateString,
    {String? formatter, String? defaultString}) {
  try {
    String formattedDate = DateFormat(formatter ?? mainDateFormatter)
        .format(DateTime.parse(dateString ).toLocal());
    return formattedDate;
  } catch (e) {
    return defaultString ?? "";
  }
}

String localdateToUtcString(String dateString,
    {String? formatter, String? defaultString}) {
  try {
    String formattedDate = DateFormat(formatter ?? mainDateFormatter)
        .format(DateTime.parse(dateString).toUtc());
    return formattedDate;
  } catch (e) {
    return defaultString ?? "";
  }
}

String changeDateFormater(String dateString,
    {String? formatter, String? defaultString}) {
  try {
    String formattedDate = DateFormat(formatter ?? mainDateFormatter).format(
      DateTime.parse(
        dateString,
      ),
    );
    return formattedDate;
  } catch (e) {
    return defaultString ?? "";
  }
}

DateTime changeIntoDate(String dateString, {DateTime? defaultTime}) {
  try {
    return DateTime.parse(dateString);
  } catch (e) {
    return defaultTime ?? DateTime.now();
  }
}

String changeDateIntoString(DateTime? date,
    {String? formatter, String? defaultString}) {
  try {
    String formattedDate =
        DateFormat(formatter ?? "yyyy-MM-dd hh:mm").format(date!);
    return formattedDate;
  } catch (e) {
    return defaultString ?? "";
  }
}

String changeOldDateIntoLatestDate(String dateString,
    {String? formatter, String? defaultString}) {
  try {
    DateTime oldDate = DateTime.parse(
      dateString,
    );
    DateTime newDate = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, oldDate.hour, oldDate.minute, oldDate.second);
    String formattedDate =
        DateFormat(formatter ?? mainDateFormatter).format(newDate);
    return formattedDate;
  } catch (e) {
    return defaultString ?? "";
  }
}
// String timeAgoFormat({required String date}) {
//   try {
//     return timeago.format(changeIntoDate(utcdateToString(date)).toLocal());
//   } catch (e) {
//     return "";
//   }
// }
