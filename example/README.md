## 示例

    import 'package:tyme/tyme.dart';
     
    void main() {
      // 公历
      SolarDay solarDay = SolarDay.fromYmd(1986, 5, 29);
       
      // 1986年5月29日
      print(solarDay);
       
      // 农历丙寅年四月廿一
      print(solarDay.getLunarDay());
       
      // 第十七饶迥火虎年四月廿一
      print(solarDay.getRabByungDay());
       
      // 1406年赖买丹月20日
      print(solarDay.getHijriDay());
    }
