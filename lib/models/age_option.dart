enum AgeOption {
  underFifteen(displayValue: 'до 15 років'),
  sixteenToSeventeen(displayValue: '16-17'),
  eighteenToTwenty(displayValue: '18-20'),
  twentyOneToTwentyFive(displayValue: '21-25'),
  twentySixAndMore(displayValue: 'від 26 років');

  final String displayValue;

  const AgeOption({required this.displayValue});
}

extension AgeOptionX on AgeOption {
  bool isUnder18() {
    if (this == AgeOption.underFifteen || this == AgeOption.sixteenToSeventeen) {
      return true;
    }
    return false;
  }
}