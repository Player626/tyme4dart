import 'event.dart';

/// 事件管理器
///
/// Author: 6tail
class EventManager {
  /// 有效字符
  static const String chars = "0123456789ABCDEFGHIJKLMNOPQRSTU_VWXYZabcdefghijklmnopqrstuvwxyz";

  /// 数据匹配的正则表达式
  static const String regex = r'(@[0-9A-Za-z_]{8})(%s)';

  /// 全量事件数据，@[1] 事件类型[1] 内容[3] 偏移天数(-31到31)[1] 起始年[3] 名称[n]
  static String data = '';

  /// 删除名为[name]的事件
  static void remove(String name) {
    data = data.replaceAll(RegExp(regex.replaceFirst('%s', name)), '');
  }

  static void _saveOrUpdate(String name, String d) {
    RegExp reg = RegExp(regex.replaceFirst('%s', name));
    Match? match = reg.firstMatch(data);
    if (match != null) {
      data = data.replaceAll(reg, d);
    } else {
      data += d;
    }
  }

  /// 以事件[event]新增或更新名为[name]的事件
  static void update(String name, Event event) {
    _saveOrUpdate(name, event.data + (event.name.isEmpty ? name : event.name));
  }

  /// 以数据[data]新增或更新名为[name]的事件
  static void updateData(String name, String data) {
    Event.validate(data);
    _saveOrUpdate(name, data);
  }
}
