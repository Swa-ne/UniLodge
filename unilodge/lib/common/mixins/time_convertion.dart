mixin TimeConvertion {
  String formatChatTimestamp(String timestamp) {
    DateTime now = DateTime.now();
    DateTime date = DateTime.parse(timestamp).toLocal();

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return formatTime(date);
    } else if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day - 1) {
      return "Yesterday";
    } else {
      return formatWeekday(date.weekday);
    }
  }

  String formatTime(DateTime date) {
    int hour = date.hour;
    int minute = date.minute;
    String period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    if (hour == 0) hour = 12;

    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  String formatWeekday(int weekday) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[weekday - 1];
  }
}
