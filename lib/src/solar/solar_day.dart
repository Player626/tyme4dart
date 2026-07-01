import '../culture/constellation.dart';
import '../culture/dog/dog.dart';
import '../culture/dog/dog_day.dart';
import '../culture/nine/nine.dart';
import '../culture/nine/nine_day.dart';
import '../culture/phase.dart';
import '../culture/phase_day.dart';
import '../culture/phenology/phenology.dart';
import '../culture/phenology/phenology_day.dart';
import '../culture/plumrain/plum_rain.dart';
import '../culture/plumrain/plum_rain_day.dart';
import '../culture/star/nine/nine_star.dart';
import '../culture/week.dart';
import '../enums/hide_heaven_stem_type.dart';
import '../evt/event.dart';
import '../festival/solar_festival.dart';
import '../hijri/hijri_day.dart';
import '../holiday/legal_holiday.dart';
import '../jd/julian_day.dart';
import '../lunar/lunar_day.dart';
import '../lunar/lunar_month.dart';
import '../rabbyung/rab_byung_day.dart';
import '../sixtycycle/hide_heaven_stem.dart';
import '../sixtycycle/hide_heaven_stem_day.dart';
import '../sixtycycle/sixty_cycle_day.dart';
import '../unit/day_unit.dart';
import 'solar_month.dart';
import 'solar_term.dart';
import 'solar_term_day.dart';
import 'solar_week.dart';

/// 公历日
///
/// Author: 6tail
class SolarDay extends DayUnit {
  static const List<String> names = ['1日', '2日', '3日', '4日', '5日', '6日', '7日', '8日', '9日', '10日', '11日', '12日', '13日', '14日', '15日', '16日', '17日', '18日', '19日', '20日', '21日', '22日', '23日', '24日', '25日', '26日', '27日', '28日', '29日', '30日', '31日'];

  SolarDay(int year, int month, int day): super(year, month, day) {
    validate(year, month, day);
  }

  static void validate(int year, int month, int day) {
    bool illegal = day < 1;
    if (!illegal) {
      if (year == 1582 && month == 10) {
        illegal = (day > 4 && day < 15) || day > 31;
      } else {
        illegal = day > SolarMonth.fromYm(year, month).getDayCount();
      }
    }
    if (illegal) {
      throw ArgumentError('illegal solar day: $year-$month-$day');
    }
  }

  SolarDay.fromYmd(int year, int month, int day) : this(year, month, day);

  /// 公历月
  SolarMonth getSolarMonth() => SolarMonth(year, month);

  /// 星期
  Week getWeek() => getJulianDay().getWeek();

  @override
  String getName() => names[day - 1];

  @override
  String toString() => '${getSolarMonth()}${getName()}';

  @override
  SolarDay next(int n) => getJulianDay().next(n).getSolarDay();

  /// 干支日
  SixtyCycleDay getSixtyCycleDay() => SixtyCycleDay.fromSolarDay(this);

  /// 星座
  Constellation getConstellation() {
    int m = month - 1;
    int offset = day > [19, 18, 20, 19, 20, 21, 22, 22, 22, 23, 22, 21][m] ? 1 : 0;
    return Constellation(9 + m + offset);
  }

  /// 节气
  SolarTerm getTerm() => getTermDay().getSolarTerm();

  /// 节气第几天
  SolarTermDay getTermDay() {
    int y = year;
    int i = month * 2;
    if (i == 24) {
      y += 1;
      i = 0;
    }
    SolarTerm term = SolarTerm(y, i + 1);
    SolarDay d = term.getSolarDay();
    while (isBefore(d)) {
      term = term.next(-1);
      d = term.getSolarDay();
    }
    return SolarTermDay(term, subtract(d));
  }

  /// 七十二候
  PhenologyDay getPhenologyDay() {
    SolarTermDay d = getTermDay();
    int dayIndex = d.getDayIndex();
    int index = dayIndex ~/ 5;
    if (index > 2) {
      index = 2;
    }
    SolarTerm term = d.getSolarTerm();
    return PhenologyDay(Phenology(term.getYear(), term.getIndex() * 3 + index), dayIndex - index * 5);
  }

  /// 候
  Phenology getPhenology() => getPhenologyDay().getPhenology();

  /// 是否在[target]指定公历日之前
  bool isBefore(SolarDay target) => getCompareIndex() < target.getCompareIndex();

  /// 是否在[target]指定公历日之后
  bool isAfter(SolarDay target) => getCompareIndex() > target.getCompareIndex();

  /// 以[start]为起始的公历周，1234560分别代表星期一至星期天
  SolarWeek getSolarWeek(int start) {
    return SolarWeek(year, month, ((day + SolarDay(year, month, 1).getWeek().next(-start).getIndex()) / 7).ceil() - 1, start);
  }

  /// 与[target]指定公历日相减的天数
  int subtract(SolarDay target) => getJulianDay().subtract(target.getJulianDay()).toInt();

  /// 儒略日
  JulianDay getJulianDay() => JulianDay.fromYmdHms(year, month, day, 0, 0, 0);

  /// 农历日
  LunarDay getLunarDay() {
    LunarMonth m = LunarMonth(year, month);
    int days = subtract(m.getFirstJulianDay().getSolarDay());
    while (days < 0) {
      m = m.next(-1);
      days += m.getDayCount();
    }
    return LunarDay(m.getYear(), m.getMonthWithLeap(), days + 1);
  }

  /// 公历现代节日（若无则返回 null）
  SolarFestival? getFestival() => SolarFestival.fromYmd(year, month, day);

  /// 法定节假日（若无则返回 null）
  LegalHoliday? getLegalHoliday() => LegalHoliday.fromYmd(year, month, day);

  /// 藏历日
  RabByungDay getRabByungDay() => RabByungDay.fromSolarDay(this);

  @override
  bool operator ==(Object other) {
    if (other is! SolarDay) return false;
    return year == other.year && month == other.month && day == other.day;
  }

  @override
  int get hashCode => Object.hash(year, month, day);

  /// 获取月相第几天
  PhaseDay getPhaseDay() {
    LunarMonth lunarMonth = getLunarDay().getLunarMonth().next(1);
    Phase p = Phase(lunarMonth.getYear(), lunarMonth.getMonthWithLeap(), 0);
    SolarDay d = p.getSolarDay();
    while (d.isAfter(this)) {
      p = p.next(-1);
      d = p.getSolarDay();
    }
    return PhaseDay(p, subtract(d));
  }

  /// 月相
  Phase getPhase() => getPhaseDay().getPhase();

  /// 三伏天
  DogDay? getDogDay() {
    // 初伏，夏至后第3个庚日
    SolarDay d0 = Event.builder().termHeavenStem(12, 6, 20).build().getSolarDay(year)!;
    // 中伏，夏至后第4个庚日
    SolarDay d1 = Event.builder().termHeavenStem(12, 6, 30).build().getSolarDay(year)!;
    // 末伏，立秋后第1个庚日
    SolarDay d2 = Event.builder().termHeavenStem(15, 6, 0).build().getSolarDay(year)!;
    if (isBefore(d0) || isAfter(d2.next(9))) {
      return null;
    }
    if (!isBefore(d2)) {
      return DogDay(Dog.fromIndex(2), subtract(d2));
    }
    return isBefore(d1) ? DogDay(Dog.fromIndex(0), subtract(d0)) : DogDay(Dog.fromIndex(1), subtract(d1));
  }

  /// 数九天
  NineDay? getNineDay() {
    SolarDay start = SolarTerm(year + 1, 0).getSolarDay();
    if (isBefore(start)) {
      start = SolarTerm(year, 0).getSolarDay();
    }
    SolarDay end = start.next(81);
    if (isBefore(start) || !isBefore(end)) {
      return null;
    }
    int days = subtract(start);
    return NineDay(Nine(days ~/ 9), days % 9);
  }

  /// 梅雨天（芒种后的第1个丙日入梅，小暑后的第1个未日出梅）
  PlumRainDay? getPlumRainDay() {
    // 入梅，芒种后第1个丙日
    SolarDay start = Event.builder().termHeavenStem(11, 2, 0).build().getSolarDay(year)!;
    // 出梅，小暑后第1个未日
    SolarDay end = Event.builder().termEarthBranch(13, 7, 0).build().getSolarDay(year)!;
    if (isBefore(start) || isAfter(end)) {
      return null;
    }
    return this == end ? PlumRainDay(PlumRain.fromIndex(1), 0) : PlumRainDay(PlumRain.fromIndex(0), subtract(start));
  }

  /// 位于当年的索引
  int getIndexInYear() => subtract(SolarDay(year, 1, 1));

  /// 人元司令分野
  HideHeavenStemDay getHideHeavenStemDay() {
    List<int> dayCounts = [3, 5, 7, 9, 10, 30];
    SolarTerm term = getTerm();
    if (term.isQi()) {
      term = term.next(-1);
    }
    int dayIndex = subtract(term.getSolarDay());
    int startIndex = (term.getIndex() - 1) * 3;
    String data = '93705542220504xx1513904541632524533533105544806564xx7573304542018584xx95'.substring(startIndex, startIndex + 6);
    int days = 0;
    int heavenStemIndex = 0;
    int typeIndex = 0;
    while (typeIndex < 3) {
      int i = typeIndex * 2;
      String d = data.substring(i, i + 1);
      int count = 0;
      if (d != 'x') {
        heavenStemIndex = int.parse(d);
        count = dayCounts[int.parse(data.substring(i + 1, i + 2))];
        days += count;
      }
      if (dayIndex <= days) {
        dayIndex -= days - count;
        break;
      }
      typeIndex++;
    }
    return HideHeavenStemDay(HideHeavenStem.fromIndex(heavenStemIndex, HideHeavenStemType.fromCode(typeIndex)!), dayIndex);
  }

  /// 九星
  NineStar getNineStar() {
    SolarDay winterSolstice = SolarTerm.fromIndex(year, 0).getSolarDay();
    SolarDay summerSolstice = SolarTerm.fromIndex(year, 12).getSolarDay();
    SolarDay nextWinterSolstice = SolarTerm.fromIndex(year + 1, 0).getSolarDay();
    // 距冬至最近的甲子日
    SolarDay w = winterSolstice.next(winterSolstice.getLunarDay().getSixtyCycle().stepsCloseTo(0));
    // 距夏至最近的甲子日
    SolarDay s = summerSolstice.next(summerSolstice.getLunarDay().getSixtyCycle().stepsCloseTo(0));
    // 距下个冬至最近的甲子日
    SolarDay n = nextWinterSolstice.next(nextWinterSolstice.getLunarDay().getSixtyCycle().stepsCloseTo(0));
    // 43210012345678876543210012345
    //      w        s        n
    //     冬至     夏至      冬至
    if (isBefore(w)) {
      return NineStar.fromIndex(w.subtract(this) - 1);
    }
    if (isBefore(s)) {
      return NineStar.fromIndex(subtract(w));
    }
    return NineStar.fromIndex(isBefore(n) ? n.subtract(this) - 1 : subtract(n));
  }

  /// 回历日
  HijriDay getHijriDay() {
    int d = subtract(SolarDay(622, 7, 16));
    int z = (d / 10631).floor();
    d -= z * 10631;
    int y = ((d + 0.5) / 354.366).floor();
    d -= (y * 354.366 + 0.5).floor();
    int m = ((d + 0.11) / 29.51).floor();
    d -= (m * 29.5 + 0.5).floor();
    return HijriDay(z * 30 + y + 1, m + 1, d + 1);
  }
}
