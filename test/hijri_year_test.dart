import 'package:test/test.dart';
import 'package:tyme/tyme.dart';

/// 回历年测试
///
/// Author: 6tail
void main() {
  group('HijriYear Tests', () {
    /// 回历年是否闰年
    test('test0 - 回历年是否闰年', () {
      expect(HijriYear.fromYear(1).isLeap(), false);
      expect(HijriYear.fromYear(2).isLeap(), true);
      expect(HijriYear.fromYear(0).isLeap(), false);
      expect(HijriYear.fromYear(-1).isLeap(), true);
    });
  });
}
