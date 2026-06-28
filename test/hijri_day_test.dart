import 'package:test/test.dart';
import 'package:tyme/tyme.dart';

/// 回历日测试
///
/// Author: 6tail
void main() {
  group('HijriDay Tests', () {
    test('test0 - 1年穆哈兰姆月1日', () {
      expect(SolarDay.fromYmd(622, 7, 16).getHijriDay().toString(), '1年穆哈兰姆月1日');
    });

    test('test1 - 1447年都尔喀尔德月26日', () {
      expect(SolarDay.fromYmd(2026, 5, 13).getHijriDay().toString(), '1447年都尔喀尔德月26日');
      expect(HijriDay.fromYmd(1447, 11, 26).getSolarDay().toString(), '2026年5月13日');
    });

    test('test2 - -538年都尔黑哲月12日', () {
      expect(SolarDay.fromYmd(100, 7, 8).getHijriDay().toString(), '-538年都尔黑哲月12日');
      expect(HijriDay.fromYmd(-538, 12, 12).getSolarDay().toString(), '100年7月8日');
    });

    test('test3 - -538年都尔黑哲月12日', () {
      expect(SolarDay.fromYmd(622, 7, 15).getHijriDay().toString(), '0年都尔黑哲月29日');
      expect(HijriDay.fromYmd(0, 12, 29).getSolarDay().toString(), '622年7月15日');
    });

    test('test4 - -640年主马达·敖外鲁月16日', () {
      expect(SolarDay.fromYmd(1, 1, 1).getHijriDay().toString(), '-640年主马达·敖外鲁月16日');
      expect(HijriDay.fromYmd(-640, 5, 16).getSolarDay().toString(), '1年1月1日');
    });

    test('test5 - 9666年赖比尔·阿色尼月2日', () {
      expect(SolarDay.fromYmd(9999, 12, 31).getHijriDay().toString(), '9666年赖比尔·阿色尼月2日');
      expect(HijriDay.fromYmd(9666, 4, 2).getSolarDay().toString(), '9999年12月31日');
    });
  });
}
