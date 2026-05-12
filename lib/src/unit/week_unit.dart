import 'month_unit.dart';

/// 周
///
/// Author: 6tail
abstract class WeekUnit extends MonthUnit {
  static const List<String> names = ['第一周', '第二周', '第三周', '第四周', '第五周', '第六周'];

  /// 索引，0-5
  final int index;

  /// 起始星期，1234560分别代表星期一至星期天
  final int start;

  WeekUnit(super.year, super.month, this.index, this.start);

  /// 索引，0-5
  int getIndex() => index;

  /// 起始星期，1234560分别代表星期一至星期天
  int getStart() => start;

  static void validate(int index, int start) {
    if (index < 0 || index > 5) {
      throw ArgumentError('illegal week index: $index');
    }
    if (start < 0 || start > 6) {
      throw ArgumentError('illegal week start: $start');
    }
  }
}
