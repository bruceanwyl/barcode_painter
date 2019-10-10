import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_painter/src/barcode93/barcode93_core.dart';

void main() {
  test("Code93 checksumC", () {
    String data = "TEST93";

    Barcode93Core barcode93 = Barcode93Core(data);
    int checksumC = barcode93.checkSumC;
    expect(checksumC, 41);
  });
  test("Code93 checksumK", () {
    String data = "TEST93";

    Barcode93Core barcode93 = Barcode93Core(data);
    int checksumK = barcode93.checkSumK;
    expect(checksumK, 6);
  });

  test("Code93 checksumC invalid character in data", () {
    String data = "TeST93";

    Barcode93Core barcode93 = Barcode93Core(data);
    int checksumC = barcode93.checkSumC;
    expect(barcode93.hasError, true);
    expect(barcode93.lastErrorMessage, "Failed to find a Code93 encoding for the character [e]");
    expect(checksumC, 0);
  });

  test("Code93 checksumK invalid character in data", () {
    String data = "TeST93";

    Barcode93Core barcode93 = Barcode93Core(data);
    int checksumC = barcode93.checkSumK;
    expect(barcode93.hasError, true);
    expect(barcode93.lastErrorMessage, "Failed to find a Code93 encoding for the character [e]");
    expect(checksumC, 0);
  });
}
