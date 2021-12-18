import 'dart:convert';
import 'dart:typed_data';

import "package:nodd/scj_number.dart";
import 'package:test/test.dart';
import 'package:pointycastle/pointycastle.dart';
// ignore: implementation_imports
import "package:pointycastle/src/utils.dart";

Uint8List createUint8ListFromHexString(String hex) =>
    Uint8List.fromList(RegExp("(..)")
        .allMatches(hex)
        .map((match) => match.group(0))
        .map((byte) => int.parse(byte!, radix: 16))
        .toList());

void main() {
  group('Convert ID to Uint8List', () {
    test('Convert ID (= 0x1) to Uint8List', () {
      const id = 0x1;
      final chunk = Uint8List.fromList([id >> 24, id >> 16, id >> 8, id]);
      expect(chunk, Uint8List.fromList([0, 0, 0, 1]));
    });
    test('Convert ID (= 0x100) to Uint8List ', () {
      const id = 0x100;
      final chunk = Uint8List.fromList([id >> 24, id >> 16, id >> 8, id]);
      expect(chunk, Uint8List.fromList([0, 0, 1, 0]));
    });
    test('Convert ID (= 0x10000) to Uint8List ', () {
      const id = 0x10000;
      final chunk = Uint8List.fromList([id >> 24, id >> 16, id >> 8, id]);
      expect(chunk, Uint8List.fromList([0, 1, 0, 0]));
    });
    test('Convert ID (= 0x1000000) to Uint8List ', () {
      const id = 0x1000000;
      final chunk = Uint8List.fromList([id >> 24, id >> 16, id >> 8, id]);
      expect(chunk, Uint8List.fromList([1, 0, 0, 0]));
    });
  });
  group('Convert ID to SCJ Number', () {
    test('Convert ID (= 0x4e6f6464) to SCJ Number', () {
      // See https://sita.app/keccak224-hash-generator
      const input = 'Nodd';
      const output = '8d60cd44afb0c0c43168b6a68d2edaef89e2d6ba74ace5aea2aeb4e2';
      const id = 0x4e6f6464;
      final keccak = Digest("Keccak/224");
      final chunk = Uint8List.fromList(utf8.encode(input));
      keccak.update(chunk, 0, chunk.length);
      final hash = Uint8List(keccak.digestSize);
      keccak.doFinal(hash, 0);
      expect(hash, createUint8ListFromHexString(output));
      final expected = (decodeBigInt(hash) % BigInt.from(9000)).toInt() + 1000;
      final number = scjNumber(id);
      expect(number, expected);
    });
    test('Convert ID (= 0x30313233) to SCJ Number', () {
      // See https://sita.app/keccak224-hash-generator
      const input = '0123';
      const output = 'bbaa36d852cd2cbf312497943ed5ea4d9faf1554b664fe921af7dfd8';
      const id = 0x30313233;
      final keccak = Digest("Keccak/224");
      final chunk = Uint8List.fromList(utf8.encode(input));
      keccak.update(chunk, 0, chunk.length);
      final hash = Uint8List(keccak.digestSize);
      keccak.doFinal(hash, 0);
      expect(hash, createUint8ListFromHexString(output));
      final expected = (decodeBigInt(hash) % BigInt.from(9000)).toInt() + 1000;
      final number = scjNumber(id);
      expect(number, expected);
    });
  });
}
