extension DateHelpers on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return now.day == this.day &&
        now.month == this.month &&
        now.year == this.year;
  }

  bool get isYesterdayOrOlder {
    return !this.isToday && this.isBefore(DateTime.now());
  }

  bool isBeforeAndDifferentDay(DateTime date) {
    return this.isBefore(date) &&
        (this.day != date.day ||
            this.month != date.month ||
            this.year != date.year);
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return yesterday.day == this.day &&
        yesterday.month == this.month &&
        yesterday.year == this.year;
  }
}

extension DurationHelpers on Duration {
  String get verboseDuration {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(this.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(this.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
