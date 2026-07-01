import '../abstract_culture.dart';
import 'day_unit.dart';

/// 秒
///
/// Author: 6tail
abstract class SecondUnit extends DayUnit {
  /// 时
  final int hour;

  /// 分
  final int minute;

  /// 秒
  final int second;

  SecondUnit(super.year, super.month, super.day, this.hour, this.minute, this.second);

  /// 时
  int getHour() => hour;

  /// 分
  int getMinute() => minute;

  /// 秒
  int getSecond() => second;

  /// 当天秒数
  int getSecondsInDay() => hour * 3600 + minute * 60 + second;

  @override
  int getCompareIndex() => super.getCompareIndex() * 86400 + getSecondsInDay();

  static void validate(int hour, int minute, int second) {
    AbstractCulture.validateRange(hour, 0, 23, 'hour');
    AbstractCulture.validateRange(minute, 0, 59, 'minute');
    AbstractCulture.validateRange(second, 0, 59, 'second');
  }
}
