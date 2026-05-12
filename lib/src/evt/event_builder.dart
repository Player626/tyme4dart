import '../enums/event_type.dart';
import 'event.dart';
import 'event_manager.dart';

/// 事件构造器
///
/// Author: 6tail
class EventBuilder {
  String? _name;
  final List<String> data = ['@', '_', '_', '_', '_', '_', '0', '0', '0'];

  /// 事件以[name]命名
  EventBuilder name(String name) {
    _name = name;
    return this;
  }

  static String _getChar(int index) => EventManager.chars[index];

  EventBuilder _setValue(int index, int n) {
    data[index] = _getChar(31 + n);
    return this;
  }

  EventBuilder _content(EventType type, int a, int b, int c) {
    data[1] = _getChar(type.code);
    return _setValue(2, a)._setValue(3, b)._setValue(4, c);
  }

  /// 公历[solarMonth]月（1至12）[solarDay]日（1至31），[delayDays]为顺延天数，例如生日在2月29，非闰年没有2月29，是+1天，还是-1天（最远支持-31至31天）
  EventBuilder solarDay(int solarMonth, int solarDay, int delayDays) {
    return _content(EventType.SOLAR_DAY, solarMonth, solarDay, delayDays);
  }

  /// 农历[lunarMonth]月（-12至-1，1至12，闰月为负）[lunarDay]日（1至30），[delayDays]为顺延天数，例如生日在某月的三十，但下一年当月可能只有29天，是+1天，还是-1天（最远支持-31至31天）
  EventBuilder lunarDay(int lunarMonth, int lunarDay, int delayDays) {
    return _content(EventType.LUNAR_DAY, lunarMonth, lunarDay, delayDays);
  }

  /// 公历[solarMonth]月第[weekIndex]个星期[week]
  EventBuilder solarWeek(int solarMonth, int weekIndex, int week) {
    return _content(EventType.SOLAR_WEEK, solarMonth, weekIndex, week);
  }

  /// 节气，[termIndex]为节气索引（0至23），[delayDays]为顺延天数（最远支持-31至31天）
  EventBuilder termDay(int termIndex, int delayDays) {
    return _content(EventType.TERM_DAY, termIndex, 0, delayDays);
  }

  /// 节气天干，[termIndex]为节气索引（0至23），[heavenStemIndex]为天干索引（0至11），[delayDays]为顺延天数（最远支持-31至31天）
  EventBuilder termHeavenStem(int termIndex, int heavenStemIndex, int delayDays) {
    return _content(EventType.TERM_HS, termIndex, heavenStemIndex, delayDays);
  }

  /// 节气地支，[termIndex]为节气索引（0至23），[earthBranchIndex]为地支索引（0至11），[delayDays]为顺延天数（最远支持-31至31天）
  EventBuilder termEarthBranch(int termIndex, int earthBranchIndex, int delayDays) {
    return _content(EventType.TERM_EB, termIndex, earthBranchIndex, delayDays);
  }

  /// 起始年[year]
  EventBuilder startYear(int year) {
    int size = EventManager.chars.length;
    int n = year;
    for (int i = 0; i < 3; i++) {
      data[8 - i] = _getChar(n % size);
      n ~/= size;
    }
    return this;
  }

  /// 偏移[days]天（最远支持-31至31天）
  EventBuilder offset(int days) => _setValue(5, days);

  /// 生成事件
  Event build() {
    return Event(_name ?? '', data.join());
  }
}
