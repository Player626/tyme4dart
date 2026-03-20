import 'month_unit.dart';

/// 日
///
/// Author: 6tail
abstract class DayUnit extends MonthUnit {
  /// 日
  final int day;

  DayUnit(super.year, super.month, this.day);

  /// 日
  int getDay() => day;
}
