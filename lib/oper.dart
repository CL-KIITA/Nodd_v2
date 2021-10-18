// ignore_for_file: constant_identifier_names, unused_field, non_constant_identifier_names
// ignore: todo
// TODO: Delete ignore_for_file

class MacroType {
  static const TypeAtom Number = TypeAtom.Number;
  static const TypeAtom Bool = TypeAtom.Bool;
}

enum TypeAtom {
  Number,
  Bool,
}

/* FIXME:
extension TypeCallAtom on MacroType {
  @override
  String toString() {
    switch (this) {
      case TypeAtom.Number:
        return "MacroType.Number";
      case TypeAtom.Bool:
        return "MacroType.Bool";
    }
  }
}
*/

class ParamSet {
  late MacroType _type;
  late String _name;
  late Object _value;
  late bool _required;
  Paramset() {}
}

mixin ParamReq {
  late ParamSet _param;
}
