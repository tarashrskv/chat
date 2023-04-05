enum AgeRange {
  underFifteen(displayValue: 'до 15 років'),
  sixteenToSeventeen(displayValue: '16-17'),
  eighteenToTwenty(displayValue: '18-20'),
  twentyOneToTwentyFive(displayValue: '21-25'),
  twentySixAndMore(displayValue: 'від 26 років');

  final String displayValue;

  const AgeRange({required this.displayValue});
}

extension AgeRangeX on AgeRange {
  bool isUnder18() {
    if (this == AgeRange.underFifteen || this == AgeRange.sixteenToSeventeen) {
      return true;
    }
    return false;
  }
}