import '../abstract_tyme.dart';
import '../culture/direction.dart';
import '../culture/duty.dart';
import '../culture/element.dart';
import '../culture/fetus/fetus_day.dart';
import '../culture/god.dart';
import '../culture/star/nine/nine_star.dart';
import '../culture/star/twelve/twelve_star.dart';
import '../culture/star/twentyeight/twenty_eight_star.dart';
import '../culture/taboo.dart';
import '../solar/solar_day.dart';
import '../solar/solar_term.dart';
import '../solar/solar_time.dart';
import 'three_pillars.dart';
import 'sixty_cycle.dart';
import 'sixty_cycle_hour.dart';
import 'sixty_cycle_month.dart';
import 'sixty_cycle_year.dart';

/// 干支日（立春换年，节令换月）
///
/// Author: 6tail
class SixtyCycleDay extends AbstractTyme {
  /// 公历日
  final SolarDay solarDay;

  /// 干支月
  final SixtyCycleMonth month;

  /// 日柱
  final SixtyCycle day;

  SixtyCycleDay(this.solarDay, this.month, this.day);

  static SixtyCycleDay fromSolarDay(SolarDay solarDay) {
    SolarTerm term = solarDay.getTerm();
    int index = term.getIndex();
    int offset = -1;
    if (index < 3) {
      if (index == 0) {
        offset = -2;
      }
    } else {
      offset = (index - 3) ~/ 2;
    }
    return SixtyCycleDay(solarDay, SixtyCycleYear(term.getYear()).getFirstMonth().next(offset), SixtyCycle(solarDay.subtract(SolarDay.fromYmd(2000, 1, 7))));
  }

  /// 公历日
  SolarDay getSolarDay() => solarDay;

  /// 干支月
  SixtyCycleMonth getSixtyCycleMonth() => month;

  /// 年柱
  SixtyCycle getYear() => month.getYear();

  /// 月柱
  SixtyCycle getMonth() => month.getSixtyCycle();

  /// 干支
  SixtyCycle getSixtyCycle() => day;

  @override
  String getName() => '$day日';

  @override
  String toString() => '$month${getName()}';

  /// 建除十二值神
  Duty getDuty() => Duty(day.getEarthBranch().getIndex() - getMonth().getEarthBranch().getIndex());

  /// 黄道黑道十二神
  TwelveStar getTwelveStar() => TwelveStar(day.getEarthBranch().getIndex() + (8 - getMonth().getEarthBranch().getIndex() % 6) * 2);

  /// 九星
  NineStar getNineStar() {
    int y = solarDay.getYear();
    SolarDay winterSolstice = SolarTerm.fromIndex(y, 0).getSolarDay();
    SolarDay summerSolstice = SolarTerm.fromIndex(y, 12).getSolarDay();
    SolarDay nextWinterSolstice = SolarTerm.fromIndex(y + 1, 0).getSolarDay();
    SolarDay w = winterSolstice.next(winterSolstice.getLunarDay().getSixtyCycle().stepsCloseTo(0));
    SolarDay s = summerSolstice.next(summerSolstice.getLunarDay().getSixtyCycle().stepsCloseTo(0));
    SolarDay n = nextWinterSolstice.next(nextWinterSolstice.getLunarDay().getSixtyCycle().stepsCloseTo(0));
    if (solarDay.isBefore(w)) {
      return NineStar.fromIndex(w.subtract(solarDay) - 1);
    }
    if (solarDay.isBefore(s)) {
      return NineStar.fromIndex(solarDay.subtract(w));
    }
    return NineStar.fromIndex(solarDay.isBefore(n) ? n.subtract(solarDay) - 1 : solarDay.subtract(n));
  }

  /// 太岁方位
  Direction getJupiterDirection() {
    int index = day.getIndex();
    return index % 12 < 6 ? Element.fromIndex(index ~/ 12).getDirection() : month.getSixtyCycleYear().getJupiterDirection();
  }

  /// 逐日胎神
  FetusDay getFetusDay() => FetusDay.fromSixtyCycleDay(this);

  /// 二十八宿
  TwentyEightStar getTwentyEightStar() => TwentyEightStar([10, 18, 26, 6, 14, 22, 2][solarDay.getWeek().getIndex()]).next(-7 * day.getEarthBranch().getIndex());

  /// 神煞列表(吉神宜趋，凶神宜忌)
  List<God> getGods() => God.getDayGods(getMonth(), day);

  /// 宜
  List<Taboo> getRecommends() => Taboo.getDayRecommends(getMonth(), day);

  /// 忌
  List<Taboo> getAvoids() => Taboo.getDayAvoids(getMonth(), day);

  @override
  SixtyCycleDay next(int n) => SixtyCycleDay.fromSolarDay(solarDay.next(n));

  /// 干支时辰列表
  List<SixtyCycleHour> getHours() {
    List<SixtyCycleHour> l = [];
    SolarDay d = solarDay.next(-1);
    SixtyCycleHour h = SixtyCycleHour.fromSolarTime(SolarTime.fromYmdHms(d.getYear(), d.getMonth(), d.getDay(), 23, 0, 0));
    l.add(h);
    for (int i = 0; i < 11; i++) {
      h = h.next(7200);
      l.add(h);
    }
    return l;
  }

  /// 三柱
  ThreePillars getThreePillars() => ThreePillars(getYear(), getMonth(), getSixtyCycle());
}
