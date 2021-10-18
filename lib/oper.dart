class MacroType {
  static const TypeAtom Number = TypeAtom.Number;
  static const TypeAtom Bool = TypeAtom.Bool;
}

enum TypeAtom {
  Number,
  Bool,
}

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
