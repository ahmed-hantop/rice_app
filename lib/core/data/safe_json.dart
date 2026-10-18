abstract class SafeJson {}

class SafeJsonData implements SafeJson {
  static int intSafe(dynamic value) => switch (value) {
    null => 0,
    int() => value,
    String() => int.tryParse(value) ?? 0,
    double() => value.toInt(),
    _ => 0,
  };

  static double doubleSafe(dynamic value) => switch (value) {
    null => 0,
    int() => value.toDouble(),
    String() => double.tryParse(value) ?? 0,
    double() => value,
    _ => 0,
  };
  static String stringSafe(dynamic value) => switch (value) {
    null => '',
    String() => value,
    int() => value.toString(),
    double() => value.toString(),
    _ => '',
  };

  static bool boolSafe(dynamic value) => switch (value) {
    null => false,
    bool() => value,
    String() => value.toLowerCase() == 'true',
    int() => value != 0,
    double() => value != 0.0,
    _ => false,
  };

  final dynamic _value;

  SafeJsonData(this._value);

  int get asInt => intSafe(_value);
  double get asDouble => doubleSafe(_value);
  String get asString => stringSafe(_value);
  bool get asBool => boolSafe(_value);
}
