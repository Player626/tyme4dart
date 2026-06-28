import '../abstract_culture.dart';
import '../abstract_tyme.dart';
import '../culture/element.dart';
import '../culture/zodiac.dart';
import '../sixtycycle/sixty_cycle.dart';
import '../solar/solar_year.dart';
import 'rab_byung_element.dart';
import 'rab_byung_month.dart';

/// 藏历年(公历1027年为藏历元年，第一饶迥火兔年）
///
/// Author: 6tail
class RabByungYear extends AbstractTyme {
  /// 饶迥(胜生周)序号，从0开始
  final int rabByungIndex;

  /// 五行索引，从0开始
  final int elementIndex;

  /// 生肖索引，从0开始
  final int zodiacIndex;

  static void validate(int year) {
    AbstractCulture.validateRange(year, 1027, 9999, 'rab-byung year');
  }

  RabByungYear(this.rabByungIndex, this.elementIndex, this.zodiacIndex) {
    if (rabByungIndex < 0 || rabByungIndex > 150) {
      throw ArgumentError('illegal rab-byung index: $rabByungIndex');
    }
    if (elementIndex < 0 || elementIndex >= Element.names.length) {
      throw ArgumentError('illegal element index: $elementIndex');
    }
    if (zodiacIndex < 0 || zodiacIndex >= Zodiac.names.length) {
      throw ArgumentError('illegal element index: $zodiacIndex');
    }
  }

  RabByungYear.fromSixtyCycle(int rabByungIndex, SixtyCycle sixtyCycle) : this(rabByungIndex, sixtyCycle.getHeavenStem().getElement().getIndex(), sixtyCycle.getEarthBranch().getZodiac().getIndex());

  RabByungYear.fromElementZodiac(int rabByungIndex, RabByungElement element, Zodiac zodiac) : this(rabByungIndex, element.getIndex(), zodiac.getIndex());

  static RabByungYear fromYear(int year) {
    validate(year);
    return RabByungYear.fromSixtyCycle((year - 1024) ~/ 60, SixtyCycle.fromIndex(year - 4));
  }

  /// 饶迥序号
  int getRabByungIndex() => rabByungIndex;

  /// 干支
  SixtyCycle getSixtyCycle() => SixtyCycle.fromIndex(6 * (elementIndex * 2 + zodiacIndex % 2) - 5 * zodiacIndex);

  /// 生肖
  Zodiac getZodiac() => Zodiac.fromIndex(zodiacIndex);

  /// 五行
  RabByungElement getElement() => RabByungElement.fromIndex(elementIndex);

  @override
  String getName() {
    const digits = ['零', '一', '二', '三', '四', '五', '六', '七', '八', '九'];
    const units = ['', '十', '百'];
    int n = rabByungIndex + 1;
    String s = '';
    int pos = 0;
    while (n > 0) {
      int digit = n % 10;
      if (digit > 0) {
        s = digits[digit] + units[pos] + s;
      } else if (s.isNotEmpty) {
        s = digits[digit] + s;
      }
      n ~/= 10;
      pos++;
    }
    String letter = s;
    if (letter.startsWith('一十')) {
      letter = letter.substring(1);
    }
    return '第$letter饶迥${getElement()}${getZodiac()}年';
  }

  @override
  RabByungYear next(int n) => RabByungYear.fromYear(getYear() + n);

  /// 年
  int getYear() => 1024 + rabByungIndex * 60 + getSixtyCycle().getIndex();

  /// 闰月
  int getLeapMonth() {
    int y = 1;
    int m = 4;
    int t = 1;
    int currentYear = getYear();
    while (y < currentYear) {
      int i = m + 31 + t;
      y += 2;
      m = i - 23;
      if (i > 35) {
        y += 1;
        m -= 12;
      }
      t = 1 - t;
    }
    return y == currentYear ? m : 0;
  }

  /// 公历年
  SolarYear getSolarYear() => SolarYear(getYear());

  /// 首月
  RabByungMonth getFirstMonth() => RabByungMonth(getYear(), 1);

  /// 月份数量
  int getMonthCount() => getLeapMonth() < 1 ? 12 : 13;

  /// 藏历月列表
  List<RabByungMonth> getMonths() {
    List<RabByungMonth> l = [];
    int y = getYear();
    int leapMonth = getLeapMonth();
    for (int i = 1; i < 13; i++) {
      l.add(RabByungMonth(y, i));
      if (i == leapMonth) {
        l.add(RabByungMonth(y, -i));
      }
    }
    return l;
  }
}
