import '../abstract_culture.dart';
import '../enums/event_type.dart';
import '../lunar/lunar_day.dart';
import '../lunar/lunar_month.dart';
import '../solar/solar_day.dart';
import '../solar/solar_month.dart';
import '../solar/solar_term.dart';
import 'event_builder.dart';
import 'event_manager.dart';

/// 事件
///
/// Author: 6tail
class Event extends AbstractCulture {
  final String name;
  final String data;

  static void validate(String data) {
    if (data.length != 9) {
      throw ArgumentError('illegal event data: $data');
    }
  }

  Event(this.name, this.data) {
    validate(data);
  }

  static EventBuilder builder() => EventBuilder();

  static Event? fromName(String name) {
    Match? match = RegExp(EventManager.regex.replaceFirst('%s', name)).firstMatch(EventManager.data);
    return match != null ? Event(name, match.group(1)!) : null;
  }

  /// 名称
  @override
  String getName() => name;

  int _getCharIndex(int index) => EventManager.chars.indexOf(data[index]);

  int getValue(int index) => _getCharIndex(index) - 31;

  List<int> getMonth(int year) {
    int y = year;
    int m = getValue(2);
    if (m > 12) {
      m = 1;
      y += 1;
    }
    return [y, m];
  }

  EventType? getType() => EventType.fromCode(EventManager.chars.indexOf(data[1]));

  int getStartYear() {
    int n = 0;
    int size = EventManager.chars.length;
    for (int i = 0; i < 3; i++) {
      n = n * size + _getCharIndex(6 + i);
    }
    return n;
  }

  static List<Event> fromSolarDay(SolarDay d) {
    List<Event> l = [];
    for (Event e in all()) {
      if (d == e.getSolarDay(d.year)) {
        l.add(e);
      }
    }
    return l;
  }

  static List<Event> all() {
    List<Event> l = [];
    for (Match match in RegExp(EventManager.regex.replaceFirst('%s', r'.[^@]+')).allMatches(EventManager.data)) {
      l.add(Event(match.group(2)!, match.group(1)!));
    }
    return l;
  }

  SolarDay? getSolarDay(int year) {
    EventType? type = getType();
    if (type == null) {
      return null;
    }
    if (year < getStartYear()) {
      return null;
    }

    SolarDay? d;
    switch (type) {
      case EventType.SOLAR_DAY:
        d = _getSolarDayBySolarDay(year);
        break;
      case EventType.SOLAR_WEEK:
        d = _getSolarDayByWeek(year);
        break;
      case EventType.LUNAR_DAY:
        d = _getSolarDayByLunarDay(year);
        break;
      case EventType.TERM_DAY:
        d = _getSolarDayByTerm(year);
        break;
      case EventType.TERM_HS:
        d = _getSolarDayByTermHeavenStem(year);
        break;
      case EventType.TERM_EB:
        d = _getSolarDayByTermEarthBranch(year);
        break;
    }

    if (d == null) {
      return null;
    }
    int offset = getValue(5);
    return offset == 0 ? d : d.next(offset);
  }

  SolarDay? _getSolarDayBySolarDay(int year) {
    List<int> month = getMonth(year);
    int y = month[0];
    int m = month[1];
    int d = getValue(3);
    int delay = getValue(4);
    int lastDay = SolarMonth(y, m).getDayCount();
    if (d > lastDay) {
      if (delay == 0) {
        return null;
      }
      return delay < 0 ? SolarDay(y, m, d + delay) : SolarDay(y, m, lastDay).next(delay);
    }
    return SolarDay(y, m, d);
  }

  SolarDay? _getSolarDayByLunarDay(int year) {
    List<int> month = getMonth(year);
    int y = month[0];
    int m = month[1];
    int d = getValue(3);
    int delay = getValue(4);
    int lastDay = LunarMonth(y, m).getDayCount();
    if (d > lastDay) {
      if (delay == 0) {
        return null;
      }
      return delay < 0 ? LunarDay(y, m, d + delay).getSolarDay() : LunarDay(y, m, lastDay).getSolarDay().next(delay);
    }
    return LunarDay(y, m, d).getSolarDay();
  }

  SolarDay? _getSolarDayByWeek(int year) {
    int n = getValue(3);
    if (n == 0) {
      return null;
    }
    SolarMonth m = SolarMonth(year, getValue(2));
    int w = getValue(4);
    if (n > 0) {
      SolarDay d = m.getFirstDay();
      return d.next(d.getWeek().stepsTo(w) + 7 * n - 7);
    } else {
      SolarDay d = SolarDay(year, m.month, m.getDayCount());
      return d.next(d.getWeek().stepsBackTo(w) + 7 * n + 7);
    }
  }

  SolarDay? _getSolarDayByTerm(int year) {
    SolarDay d = SolarTerm(year, getValue(2)).getSolarDay();
    int offset = getValue(4);
    return offset == 0 ? d : d.next(offset);
  }

  SolarDay? _getSolarDayByTermHeavenStem(int year) {
    SolarDay d = _getSolarDayByTerm(year)!;
    return d.next(d.getLunarDay().getSixtyCycle().getHeavenStem().stepsTo(getValue(3)));
  }

  SolarDay? _getSolarDayByTermEarthBranch(int year) {
    SolarDay d = _getSolarDayByTerm(year)!;
    return d.next(d.getLunarDay().getSixtyCycle().getEarthBranch().stepsTo(getValue(3)));
  }
}
