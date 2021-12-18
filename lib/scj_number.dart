import 'dart:typed_data';

import 'package:pointycastle/pointycastle.dart';
// ignore: implementation_imports
import "package:pointycastle/src/utils.dart";

int scjNumber(int id) {
  final keccak = Digest("Keccak/224");
  final chunk = Uint8List.fromList([id >> 24, id >> 16, id >> 8, id]);
  keccak.update(chunk, 0, chunk.length);
  final hash = Uint8List(keccak.digestSize);
  keccak.doFinal(hash, 0);
  return (decodeBigInt(hash) % BigInt.from(9000)).toInt() + 1000;
}
