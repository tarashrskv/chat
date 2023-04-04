enum AgeOption {
  underFifteen,
  sixteenToSeventeen,
  eighteenToTwenty,
  twentyOneToTwentyFive,
  twentySixAndMore,
}

extension AgeOptionX on AgeOption {
  String displayValue() {
    if (this == AgeOption.underFifteen) {
      return 'до 15 років';
    }
    else if (this == AgeOption.sixteenToSeventeen) {
      return '16-17';
    }
    else if (this == AgeOption.eighteenToTwenty) {
      return '18-20';
    }
    else if (this == AgeOption.twentyOneToTwentyFive) {
      return '21-25';
    }
    else {
      return 'від 26 років';
    }
  }

  bool isUnder18() {
    if (this == AgeOption.underFifteen || this == AgeOption.sixteenToSeventeen) {
      return true;
    }
    return false;
  }
}