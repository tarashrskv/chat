enum Gender {
  male,
  female
}

extension GenderX on Gender {

  String display() {
    if (this == Gender.male) {
      return 'Хлопець';
    }
    else {
      return 'Дівчина';
    }
  }

  String toApi() {
    if (this == Gender.male) {
      return 'MALE';
    }
    else {
      return 'FEMAlE';
    }
  }

}