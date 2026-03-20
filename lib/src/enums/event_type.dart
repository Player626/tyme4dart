/// 事件类型
///
/// Author: 6tail
enum EventType {
  SOLAR_DAY(0, '公历日期'),
  SOLAR_WEEK(1, '几月第几个星期几'),
  LUNAR_DAY(2, '农历日期'),
  TERM_DAY(3, '节气日期'),
  TERM_HS(4, '节气天干'),
  TERM_EB(5, '节气地支');

  /// 代码
  final int code;

  /// 名称
  final String name;

  const EventType(this.code, this.name);

  /// 从代码获取枚举
  static EventType? fromCode(int code) {
    for (var item in EventType.values) {
      if (item.code == code) {
        return item;
      }
    }
    return null;
  }

  /// 从名称获取枚举
  static EventType? fromName(String name) {
    for (var item in EventType.values) {
      if (item.name == name) {
        return item;
      }
    }
    return null;
  }

  String getName() => name;

  int getCode() => code;

  @override
  String toString() => name;
}
