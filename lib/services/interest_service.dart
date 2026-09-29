class InterestService {
  static double interestTillDate({
    required double principal,
    required double rate,
    required String rateType,
    required DateTime startDate,
    DateTime? endDate,
  }) {
    final end = endDate ?? DateTime.now();
    final days = end.difference(startDate).inDays.clamp(0, 100000);

    double time;
    if (rateType == 'Monthly') {
      time = days / 30;
    } else {
      time = days / 365;
    }

    return principal * rate * time / 100;
  }

  static double totalWithInterest({
    required double principal,
    required double rate,
    required String rateType,
    required DateTime startDate,
    DateTime? endDate,
  }) {
    return principal +
        interestTillDate(
          principal: principal,
          rate: rate,
          rateType: rateType,
          startDate: startDate,
          endDate: endDate,
        );
  }
}
