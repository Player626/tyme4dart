import '../jd/julian_day.dart';
import '../solar/solar_day.dart';
import '../unit/day_unit.dart';
import 'hijri_month.dart';

/// 回历日
///
/// Author: 6tail
class HijriDay extends DayUnit {
  static const List<String> names = ['1日', '2日', '3日', '4日', '5日', '6日', '7日', '8日', '9日', '10日', '11日', '12日', '13日', '14日', '15日', '16日', '17日', '18日', '19日', '20日', '21日', '22日', '23日', '24日', '25日', '26日', '27日', '28日', '29日', '30日'];

  HijriDay(int year, int month, int day): super(year, month, day) {
    validate(year, month, day);
  }

  static void validate(int year, int month, int day) {
    if (day < 1 || day > HijriMonth.fromYm(year, month).getDayCount()) {
      throw ArgumentError('illegal hijri day: $year-$month-$day');
    }
  }

  HijriDay.fromYmd(int year, int month, int day) : this(year, month, day);

  /// 回历月
  HijriMonth getHijriMonth() => HijriMonth(year, month);

  @override
  String getName() => names[day - 1];

  @override
  String toString() => '${getHijriMonth()}${getName()}';

  @override
  HijriDay next(int n) => getSolarDay().next(n).getHijriDay();

  /// 是否在[target]指定回历日之前
  bool isBefore(HijriDay target) => getCompareIndex() < target.getCompareIndex();

  /// 是否在[target]指定回历日之后
  bool isAfter(HijriDay target) => getCompareIndex() > target.getCompareIndex();

  /// 与[target]指定回历日相减的天数
  int subtract(HijriDay target) => getJulianDay().subtract(target.getJulianDay()).toInt();

  /// 儒略日
  JulianDay getJulianDay() => JulianDay(((11 * year + 3) / 30).floor() + 354 * year + 30 * month - ((month - 1) / 2).floor() + day + 1948055);

  @override
  bool operator ==(Object other) {
    if (other is! HijriDay) return false;
    return year == other.year && month == other.month && day == other.day;
  }

  @override
  int get hashCode => Object.hash(year, month, day);

  /// 位于当年的索引
  int getIndexInYear() => subtract(HijriDay(year, 1, 1));

  /// 公历日
  SolarDay getSolarDay() => SolarDay(622, 7, 16).next(subtract(HijriDay(1, 1, 1)));
}
