import '../abstract_culture.dart';
import '../unit/month_unit.dart';
import 'hijri_day.dart';
import 'hijri_year.dart';

/// 回历月
///
/// Author: 6tail
class HijriMonth extends MonthUnit {
  static const List<String> names = ['穆哈兰姆月', '色法尔月', '赖比尔·敖外鲁月', '赖比尔·阿色尼月', '主马达·敖外鲁月', '主马达·阿色尼月', '赖哲卜月', '舍尔邦月', '赖买丹月', '闪瓦鲁月', '都尔喀尔德月', '都尔黑哲月'];

  HijriMonth(int year, int month) : super(year, month) {
    validate(year, month);
  }

  static void validate(int year, int month) {
    AbstractCulture.validateRange(month, 1, 12, 'hijri month');
    HijriYear.validate(year);
  }

  HijriMonth.fromYm(int year, int month) : this(year, month);

  /// 公历年
  HijriYear getHijriYear() => HijriYear(year);

  /// 天数（单数月30天，双数月29天，闰年第12月30天)
  int getDayCount() {
    int d = month % 2 == 0 ? 29 : 30;
    // 闰年第12月30天
    if (12 == month && getHijriYear().isLeap()) {
      d++;
    }
    return d;
  }

  /// 位于当年的索引，0-11
  int getIndexInYear() => month - 1;

  @override
  String getName() => names[getIndexInYear()];

  @override
  String toString() => '${getHijriYear()}${getName()}';

  @override
  HijriMonth next(int n) {
    int i = month - 1 + n;
    return HijriMonth((year * 12 + i) ~/ 12, indexOfSize(i, 12) + 1);
  }

  /// 回历日列表
  List<HijriDay> getDays() {
    int size = getDayCount();
    List<HijriDay> l = [];
    for (int i = 1; i <= size; i++) {
      l.add(HijriDay(year, month, i));
    }
    return l;
  }

  /// 首日
  HijriDay getFirstDay() => HijriDay(year, month, 1);
}
