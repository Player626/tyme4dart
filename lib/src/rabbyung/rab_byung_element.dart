import '../culture/element.dart';

/// 藏历五行（铁替换金）
///
/// Author: 6tail
class RabByungElement extends Element {
  static const List<String> names = ['木', '火', '土', '铁', '水'];

  RabByungElement(int index) : super.fromIndexOf(names, index);

  RabByungElement.fromIndex(int index) : this(index);

  RabByungElement.fromName(String name) : super.fromNameOf(names, name);

  @override
  RabByungElement next(int n) {
    return RabByungElement.fromIndex(nextIndex(n));
  }

  /// 我生者
  @override
  RabByungElement getReinforce() {
    return next(1);
  }

  /// 我克者
  @override
  RabByungElement getRestrain() {
    return next(2);
  }

  /// 生我者
  @override
  RabByungElement getReinforced() {
    return next(-1);
  }

  /// 克我者
  @override
  RabByungElement getRestrained() {
    return next(-2);
  }
}
