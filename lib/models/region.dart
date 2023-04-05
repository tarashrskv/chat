enum Region {
  any(displayValue: 'Будь-яка область'),
  cherkasy(displayValue: 'Черкаська область'),
  chernihiv(displayValue: 'Чернігівська область'),
  chernivtsi(displayValue: 'Чернівецька область'),
  crimea(displayValue: 'Кримська область'),
  dnipro(displayValue: 'Дніпровська область'),
  donetsk(displayValue: 'Донецька область'),
  ivanoFrankivsk(displayValue: 'Івано-Франківська область'),
  kharkiv(displayValue: 'Харківська область'),
  kherson(displayValue: 'Херсонська область'),
  khmelnytskyi(displayValue: 'Хмельницька область'),
  kropyvnytskyi(displayValue: 'Кропивницька область'),
  kyiv(displayValue: 'Київська область'),
  luhansk(displayValue: 'Луганська область'),
  lviv(displayValue: 'Львівська область'),
  mykolaiv(displayValue: 'Миколаївська область'),
  odesa(displayValue: 'Одеська область'),
  poltava(displayValue: 'Полтавська область'),
  rivne(displayValue: 'Рівненська область'),
  sumy(displayValue: 'Сумська область'),
  ternopil(displayValue: 'Тернопільська область'),
  vinnytsia(displayValue: 'Вінницька область'),
  volyn(displayValue: 'Волинська область'),
  zakarpattia(displayValue: 'Закарпатська область'),
  zaporizhzhia(displayValue: 'Запорізька область'),
  zhytomyr(displayValue: 'Житомирська область');

  const Region({required this.displayValue});

  final String displayValue;
}

Set<Region> getFrequentRegions() {
  return {
    Region.any,
    Region.lviv,
    Region.ivanoFrankivsk,
    Region.kyiv,
    Region.ternopil,
    Region.volyn,
    Region.rivne,
    Region.vinnytsia,
  };
}

Set<Region> getOtherRegions() {
  return {
    Region.dnipro,
    Region.zhytomyr,
    Region.zakarpattia,
    Region.zaporizhzhia,
    Region.kropyvnytskyi,
    Region.luhansk,
    Region.mykolaiv,
    Region.odesa,
    Region.poltava,
    Region.sumy,
    Region.kharkiv,
    Region.kherson,
    Region.khmelnytskyi,
    Region.cherkasy,
    Region.chernivtsi,
    Region.chernihiv
  };
}