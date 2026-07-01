import '../abstract_culture.dart';
import '../abstract_tyme.dart';
import '../culture/direction.dart';
import '../culture/star/nine/nine_star.dart';
import '../culture/twenty.dart';
import 'sixty_cycle.dart';
import 'sixty_cycle_month.dart';

/// 干支年
///
/// Author: 6tail
class SixtyCycleYear extends AbstractTyme {
  /// 年
  final int year;

  SixtyCycleYear(this.year) {
    AbstractCulture.validateRange(year, -1, 9999, 'sixty cycle year');
  }

  /// 从年初始化（支持-1到9999年）
  SixtyCycleYear.fromYear(int year) : this(year);

  /// 年
  int getYear() => year;

  /// 干支
  SixtyCycle getSixtyCycle() => SixtyCycle(year - 4);

  @override
  String getName() {
    return '${getSixtyCycle()}年';
  }

  /// 运
  Twenty getTwenty() => Twenty(((year - 1864) / 20).floor());

  /// 九星
  NineStar getNineStar() => NineStar(63 + getTwenty().getSixty().getIndex() * 3 - getSixtyCycle().getIndex());

  /// 太岁方位
  Direction getJupiterDirection() => Direction([0, 7, 7, 2, 3, 3, 8, 1, 1, 6, 0, 0][getSixtyCycle().getEarthBranch().getIndex()]);

  @override
  SixtyCycleYear next(int n) => SixtyCycleYear(year + n);

  /// 首月（五虎遁）
  SixtyCycleMonth getFirstMonth() => SixtyCycleMonth(this, SixtyCycle.fromIndex(year * 12 - 46));

  /// 干支月列表
  List<SixtyCycleMonth> getMonths() {
    List<SixtyCycleMonth> l = [];
    SixtyCycleMonth m = getFirstMonth();
    l.add(m);
    for (int i = 1; i < 12; i++) {
      l.add(m.next(i));
    }
    return l;
  }
}
