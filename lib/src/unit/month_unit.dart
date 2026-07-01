import 'year_unit.dart';

/// 月
///
/// Author: 6tail
abstract class MonthUnit extends YearUnit {
  /// 月
  final int month;

  MonthUnit(super.year, this.month);

  /// 月
  int getMonth() => month;

  @override
  int getCompareIndex() => super.getCompareIndex() + (month > 0 ? month * 2 : -month * 2 + 1) * 100;
}
