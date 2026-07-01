import '../evt/event.dart';
import '../solar/solar_day.dart';
import 'abstract_festival.dart';

/// 公历现代节日
///
/// Author: 6tail
class SolarFestival extends AbstractFestival {
  static const List<String> names = ['元旦', '妇女节', '植树节', '劳动节', '青年节', '儿童节', '建党节', '建军节', '教师节', '国庆节'];

  static String data = '0VV__0Ux0Xc__0Ux0Xg__0_Q0ZV__0Ux0ZY__0Ux0aV__0Ux0bV__0Uo0cV__0Ug0de__0_V0eV__0Ux';

  SolarFestival(super.index, super.event, SolarDay super.day);

  static SolarFestival? fromIndex(int year, int index) {
    if (index < 0 || index >= names.length) {
      return null;
    }
    int start = index * 8;
    Event e = Event(names[index], '@${data.substring(start, start + 8)}');
    return year < e.getStartYear() ? null : SolarFestival(index, e, SolarDay(year, e.getValue(2), e.getValue(3)));
  }

  static SolarFestival? fromYmd(int year, int month, int day) {
    SolarDay d = SolarDay(year, month, day);
    for (int i = 0, j = names.length; i < j; i++) {
      int start = i * 8;
      Event e = Event(names[i], '@${data.substring(start, start + 8)}');
      if (d.year >= e.getStartYear() && d.month == e.getValue(2) && d.day == e.getValue(3)) {
        return SolarFestival(i, e, d);
      }
    }
    return null;
  }

  @override
  SolarFestival next(int n) {
    int size = names.length;
    int i = index + n;
    return fromIndex((day.getYear() * size + i) ~/ size, indexOfSize(i, size))!;
  }

  @override
  SolarDay getDay() => day as SolarDay;

  int getStartYear() => event.getStartYear();
}
