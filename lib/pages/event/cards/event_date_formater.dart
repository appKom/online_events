import 'package:intl/intl.dart';

class EventDateFormatter {
  static final daysNorwegian = {
    'Monday': 'Man',
    'Tuesday': 'Tir',
    'Wednesday': 'Ons',
    'Thursday': 'Tor',
    'Friday': 'Fre',
    'Saturday': 'Lør',
    'Sunday': 'Søn',
  };

  // static final monthsNorwegian = {
  //   'January': 'Januar',
  //   'February': 'Februar',
  //   'March': 'Mars',
  //   'April': 'April',
  //   'May': 'Mai',
  //   'June': 'Juni',
  //   'July': 'Juli',
  //   'August': 'August',
  //   'September': 'September',
  //   'October': 'Oktober',
  //   'November': 'November',
  //   'December': 'Desember',
  // };

  static final monthsNorwegian = {
    'January': 'Jan',
    'February': 'Feb',
    'March': 'Mar',
    'April': 'Apr',
    'May': 'Mai',
    'June': 'Jun',
    'July': 'Jul',
    'August': 'Aug',
    'September': 'Sept',
    'October': 'Okt',
    'November': 'Nov',
    'December': 'Des',
  };

  static String formatEventDates(String startDate, String endDate) {
    DateFormat inputFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
    DateFormat outputTimeFormat = DateFormat("HH:mm");
    DateFormat outputDayFormat = DateFormat("EEEE");
    DateFormat outputMonthFormat = DateFormat("MMMM");
    DateFormat outputDayOfMonthFormat = DateFormat("d");

    DateTime startDateTime = inputFormat.parse(startDate, true);
    DateTime endDateTime = inputFormat.parse(endDate, true);

    if (startDateTime.year == endDateTime.year &&
        startDateTime.month == endDateTime.month &&
        startDateTime.day == endDateTime.day) {
      String dayName = daysNorwegian[outputDayFormat.format(startDateTime)]!;
      String monthName = monthsNorwegian[outputMonthFormat.format(startDateTime)]!;
      String dayOfMonth = outputDayOfMonthFormat.format(startDateTime);
      String formattedStartTime = outputTimeFormat.format(startDateTime);
      String formattedEndTime = outputTimeFormat.format(endDateTime);

      return "$dayName $dayOfMonth. $monthName, $formattedStartTime-$formattedEndTime";
    } else {
      String startDayOfMonth = outputDayOfMonthFormat.format(startDateTime);
      String endDayOfMonth = outputDayOfMonthFormat.format(endDateTime);
      String startMonthName = monthsNorwegian[outputMonthFormat.format(startDateTime)]!;
      String endMonthName = monthsNorwegian[outputMonthFormat.format(endDateTime)]!;
      String formattedStartTime = outputTimeFormat.format(startDateTime);
      String formattedEndTime = outputTimeFormat.format(endDateTime);

      return "$startDayOfMonth. $startMonthName $formattedStartTime - $endDayOfMonth. $endMonthName $formattedEndTime";
    }
  }
}
