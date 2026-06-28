import '../culture/phase.dart';
import '../culture/phenology/phenology.dart';
import '../jd/julian_day.dart';
import '../lunar/lunar_day.dart';
import '../lunar/lunar_hour.dart';
import '../lunar/lunar_month.dart';
import '../sixtycycle/sixty_cycle_hour.dart';
import '../unit/second_unit.dart';
import 'solar_day.dart';
import 'solar_term.dart';

/// 公历时刻
///
/// Author: 6tail
class SolarTime extends SecondUnit {

  SolarTime(int year, int month, int day, int hour, int minute, int second): super(year, month, day, hour, minute, second) {
    validate(year, month, day, hour, minute, second);
  }

  static void validate(int year, int month, int day, int hour, int minute, int second) {
    SecondUnit.validate(hour, minute, second);
    SolarDay.validate(year, month, day);
  }

  SolarTime.fromYmdHms(int year, int month, int day, int hour, int minute, int second) : this(year, month, day, hour, minute, second);

  /// 公历日
  SolarDay getSolarDay() => SolarDay(year, month, day);

  @override
  String getName() => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}';

  @override
  String toString() => '${getSolarDay()} ${getName()}';

  /// 是否在[target]指定公历时刻之前
  bool isBefore(SolarTime target) => getCompareIndex() < target.getCompareIndex();

  /// 是否在[target]指定公历时刻之后
  bool isAfter(SolarTime target) => getCompareIndex() > target.getCompareIndex();

  /// 儒略日
  JulianDay getJulianDay() => JulianDay.fromYmdHms(year, month, day, hour, minute, second);

  /// 与[target]公历时刻相减，获得相差秒数
  int subtract(SolarTime target) => getSolarDay().subtract(target.getSolarDay()) * 86400 + getSecondsInDay() - target.getSecondsInDay();

  /// 推移[n]秒
  @override
  SolarTime next(int n) {
    if (n == 0) {
      return SolarTime(year, month, day, hour, minute, second);
    }
    int t = getSecondsInDay() + n;
    int s = indexOfSize(t, 86400);
    SolarDay d = getSolarDay().next((t / 86400).floor());
    return SolarTime(d.getYear(), d.getMonth(), d.getDay(), s ~/ 3600, s % 3600 ~/ 60, s % 60);
  }

  /// 农历时辰
  LunarHour getLunarHour() {
    LunarDay d = getSolarDay().getLunarDay();
    return LunarHour.fromYmdHms(d.getYear(), d.getMonth(), d.getDay(), hour, minute, second);
  }

  /// 候
  Phenology getPhenology() {
    Phenology p = getSolarDay().getPhenology();
    if (isBefore(p.getJulianDay().getSolarTime())) {
      p = p.next(-1);
    }
    return p;
  }

  /// 干支时辰
  SixtyCycleHour getSixtyCycleHour() => SixtyCycleHour.fromSolarTime(this);

  /// 节气
  SolarTerm getTerm() {
    SolarTerm term = getSolarDay().getTerm();
    if (isBefore(term.getJulianDay().getSolarTime())) {
      term = term.next(-1);
    }
    return term;
  }

  /// 月相
  Phase getPhase() {
    LunarMonth lunarMonth = getLunarHour().getLunarDay().getLunarMonth().next(1);
    Phase p = Phase.fromIndex(lunarMonth.getYear(), lunarMonth.getMonthWithLeap(), 0);
    while (p.getSolarTime().isAfter(this)) {
      p = p.next(-1);
    }
    return p;
  }
}
