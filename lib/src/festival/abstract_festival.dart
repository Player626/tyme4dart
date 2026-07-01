import '../abstract_tyme.dart';
import '../evt/event.dart';
import '../unit/day_unit.dart';

/// 节日抽象
///
/// Author: 6tail
abstract class AbstractFestival extends AbstractTyme {
  /// 索引
  int index;

  /// 日
  DayUnit day;

  /// 事件
  Event event;

  AbstractFestival(this.index, this.event, this.day);

  /// 索引
  int getIndex() => index;

  /// 日
  DayUnit getDay() => day;

  @override
  String getName() => event.name;

  @override
  String toString() => '${getDay()} ${getName()}';
}
