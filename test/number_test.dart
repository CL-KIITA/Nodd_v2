// ignore_for_file: avoid_print
// ignore: todo
// TODO: Delete ignore_for_file

import "package:nodd/number.dart";
import 'package:test/test.dart';

void main() {
  test('number test', () async {
    int n = 86;
    int rad = 10;

    print("SCJ-Number\n\n");
    NumGen numgen = NumGen.init(rad, n);
    print("now?: $n");
    List<String> now = numgen.past;
    print(now.last.startsWith("@Deplet") ? "@Deplet" : now.join("\n"));
    print("next: ${++n}");
    print("\t" + numgen.next);
    print("next: ${++n}");
    print("\t" + numgen.next);
    print("next: ${++n}");
    print("\t" + numgen.next);
    print("next: ${++n}");
    print("\t" + numgen.next);
    print("next: ${++n}");
    print("\t" + numgen.next);
    print("next: ${++n}");
    print("\t" + numgen.next);
    print("next: ${++n}");
    print("\t" + numgen.next);
    print("next: ${++n}");
    print("\t" + numgen.next);
    print("next: ${++n}");
    print("\t" + numgen.next);
    print("next: ${++n}");
    print("\t" + numgen.next);
    print("next: ${++n}");
    print("\t" + numgen.next);
    print("next: ${++n}");
    print("\t" + numgen.next);
  });
}
