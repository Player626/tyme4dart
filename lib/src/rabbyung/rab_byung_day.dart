import '../solar/solar_day.dart';
import '../unit/day_unit.dart';
import 'rab_byung_month.dart';

/// 藏历日，仅支持藏历1950年十二月初一（公历1951年1月8日）至藏历2050年十二月三十（公历2051年2月11日）
///
/// Author: 6tail
class RabByungDay extends DayUnit {
  static const List<String> names = ['初一', '初二', '初三', '初四', '初五', '初六', '初七', '初八', '初九', '初十', '十一', '十二', '十三', '十四', '十五', '十六', '十七', '十八', '十九', '二十', '廿一', '廿二', '廿三', '廿四', '廿五', '廿六', '廿七', '廿八', '廿九', '三十'];

  /// 是否闰日
  late final bool leap;

  static void validate(int year, int month, int day) {
    if (day == 0 || day < -30 || day > 30) {
      throw ArgumentError('illegal day $day in $month');
    }
    RabByungMonth m = RabByungMonth.fromYm(year, month);
    bool leap = day < 0;
    int d = day.abs();
    if (leap && !m.getLeapDays().contains(d)) {
      throw ArgumentError('illegal leap day $d in $m');
    }
    if (!leap && m.getMissDays().contains(d)) {
      throw ArgumentError('illegal day $d in $m');
    }
  }

  RabByungDay(int year, int month, int day): super(year, month, day.abs()) {
    validate(year, month, day);
    leap = day < 0;
  }

  /// 使用[year]藏历年、[month]藏历月(闰月为负)、[day]藏历日(闰日为负)初始化
  RabByungDay._fromYmd(int year, int month, int day): this(year, month, day);

  static RabByungDay fromYmd(int year, int month, int day) {
    return RabByungDay._fromYmd(year, month, day);
  }

  static RabByungDay fromSolarDay(SolarDay solarDay) {
    int days = solarDay.subtract(SolarDay.fromYmd(1951, 1, 8));
    RabByungMonth m = RabByungMonth.fromYm(1950, 12);
    int count = m.getDayCount();
    while (days >= count) {
      days -= count;
      m = m.next(1);
      count = m.getDayCount();
    }
    int day = days + 1;
    for (int d in m.getSpecialDays()) {
      if (d < 0) {
        if (day >= -d) {
          day++;
        }
      } else if (d > 0) {
        if (day == d + 1) {
          day = -d;
          break;
        } else if (day > d + 1) {
          day--;
        }
      }
    }
    return RabByungDay(m.getYear(), m.getMonthWithLeap(), day);
  }

  /// 藏历月
  RabByungMonth getRabByungMonth() => RabByungMonth.fromYm(year, month);

  /// 是否闰日
  bool isLeap() => leap;

  /// 日（闰日返回负数）
  int getDayWithLeap() => leap ? -day : day;

  @override
  String getName() => (leap ? '闰' : '') + names[day - 1];

  @override
  String toString() => getRabByungMonth().toString() + getName();

  /// 藏历日相减
  int subtract(RabByungDay target) {
    return getSolarDay().subtract(target.getSolarDay());
  }

  /// 公历日
  SolarDay getSolarDay() {
    RabByungMonth m = RabByungMonth.fromYm(1950, 12);
    RabByungMonth cm = getRabByungMonth();
    int n = 0;
    while (m != cm) {
      n += m.getDayCount();
      m = m.next(1);
    }
    int t = day;
    for (int d in m.getSpecialDays()) {
      if (d < 0) {
        if (t > -d) {
          t--;
        }
      } else if (d > 0) {
        if (t > d) {
          t++;
        }
      }
    }
    if (leap) {
      t++;
    }
    return SolarDay.fromYmd(1951, 1, 7).next(n + t);
  }

  @override
  RabByungDay next(int n) {
    return getSolarDay().next(n).getRabByungDay();
  }
}
