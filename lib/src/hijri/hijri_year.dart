import '../abstract_culture.dart';
import '../unit/year_unit.dart';
import 'hijri_month.dart';

/// 回历年
///
/// Author: 6tail
class HijriYear extends YearUnit {
  HijriYear(int year): super(year) {
    validate(year);
  }

  static void validate(int year) {
    AbstractCulture.validateRange(year, -640, 9666, 'hijri year');
  }

  /// 从[year]年初始化，支持1到9999年
  HijriYear.fromYear(int year) : this(year);

  /// 天数（平年354天，闰年355天）
  int getDayCount() => isLeap() ? 355 : 354;

  /// 是否闰年(1个闰周为30年，1个闰周中第2、5、7、10、13、16、18、21、24、26、29年为闰年)
  bool isLeap() {
    int i = indexOfSize(year - 1, 30);
    return i == 1 || i == 4 || i == 6 || i == 9 || i == 12 || i == 15 || i == 17 || i == 20 || i == 23 || i == 25 || i == 28;
  }

  @override
  String getName() => '$year年';

  @override
  HijriYear next(int n) => HijriYear(year + n);

  /// 月份列表，1年有12个月。
  List<HijriMonth> getMonths() {
    List<HijriMonth> l = [];
    for (int i = 1; i < 13; i++) {
      l.add(HijriMonth(year, i));
    }
    return l;
  }

  /// 首月
  HijriMonth getFirstMonth() => HijriMonth(year, 1);
}
