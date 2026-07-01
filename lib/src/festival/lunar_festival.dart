import '../enums/event_type.dart';
import '../evt/event.dart';
import '../lunar/lunar_day.dart';
import '../solar/solar_term.dart';
import '../solar/solar_term_day.dart';
import 'abstract_festival.dart';

/// 农历传统节日（依据国家标准《农历的编算和颁行》GB/T 33661-2017）
///
/// Author: 6tail
class LunarFestival extends AbstractFestival {
  static const List<String> names = ['春节', '元宵节', '龙头节', '上巳节', '清明节', '端午节', '七夕节', '中元节', '中秋节', '重阳节', '冬至节', '腊八节', '除夕'];

  static String data = '2VV__0002Vj__0002WW__0002XX__0003b___0002ZZ__0002bb__0002bj__0002cj__0002dd__0003s___0002gc__0002hV_U000';

  LunarFestival(super.index, super.event, LunarDay super.day);

  @override
  LunarFestival next(int n) {
    int size = names.length;
    int i = index + n;
    return fromIndex((day.getYear() * size + i) ~/ size, indexOfSize(i, size))!;
  }

  static LunarFestival? fromIndex(int year, int index) {
    if (index < 0 || index >= names.length) {
      return null;
    }
    int start = index * 8;
    Event e = Event(names[index], '@${data.substring(start, start + 8)}');
    switch (e.getType()) {
      case EventType.LUNAR_DAY:
        List<int> m = e.getMonth(year);
        LunarDay d = LunarDay(m[0], m[1], e.getValue(3));
        int offset = e.getValue(5);
        return LunarFestival(index, e, offset == 0 ? d : d.next(offset));
      case EventType.TERM_DAY:
        return LunarFestival(index, e, SolarTerm(year, e.getValue(2)).getSolarDay().getLunarDay());
      default:
        return null;
    }
  }

  static LunarFestival? fromYmd(int year, int month, int day) {
    LunarDay d = LunarDay(year, month, day);
    for (int i = 0, j = names.length; i < j; i++) {
      int start = i * 8;
      Event e = Event(names[i], '@${data.substring(start, start + 8)}');
      switch (e.getType()) {
        case EventType.LUNAR_DAY:
          int offset = e.getValue(5);
          if (offset == 0) {
            if (d.month == e.getValue(2) && d.day == e.getValue(3)) {
              return LunarFestival(i, e, d);
            }
          } else {
            List<int> m = e.getMonth(d.year);
            LunarDay next = d.next(-offset);
            if (next.year == m[0] && next.month == m[1] && next.day == e.getValue(3)) {
              return LunarFestival(i, e, d);
            }
          }
          break;
        case EventType.TERM_DAY:
          final term = d.getSolarDay().getTermDay();
          if (term.dayIndex == 0 && term.getSolarTerm().index == e.getValue(2) % 24) {
            return LunarFestival(i, e, d);
          }
          break;
        default:
      }
    }
    return null;
  }

  /// 农历日
  @override
  LunarDay getDay() => day as LunarDay;

  /// 节气
  SolarTerm? getSolarTerm() {
    SolarTermDay t = getDay().getSolarDay().getTermDay();
    return t.dayIndex == 0 ? t.getSolarTerm() : null;
  }
}
