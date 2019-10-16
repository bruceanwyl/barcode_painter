import 'package:barcode_painter/barcode_painter.dart';
import 'package:barcode_painter_demo/common/barcode_example_dto.dart';
import 'package:flutter/material.dart';

class Barcode39Examples {
  static List<BarcodeExampleDTO> data = [
    BarcodeExampleDTO(
      "Code 39",
      "Small value, default values for all settings.",
      Barcode39(
        data: "BARCODE39",
      ),
    ),
    BarcodeExampleDTO(
      "Code 39",
      [
        "As above and showing the barcode data as text under the bars.",
        "Note how the height of the lines is reduced by the amount of space needed to show the text.",
      ].join("\n"),
      Barcode39(
        data: "BARCODE39",
        showText: true,
      ),
    ),
    BarcodeExampleDTO(
      "Code 39",
      "As above and fontSize is 20.",
      Barcode39(
        data: "BARCODE39",
        showText: true,
        fontSize: 20.0,
      ),
    ),
    BarcodeExampleDTO(
      "Code 39",
      "As above and foregroundColor is red.",
      Barcode39(
        data: "BARCODE39",
        showText: true,
        fontSize: 20.0,
        foregroundColor: Colors.red,
      ),
    ),
    BarcodeExampleDTO(
      "Code 39",
      "As above and backgroundColor is yellow.\nYes, it actually scans :-)",
      Barcode39(
        data: "BARCODE39",
        showText: true,
        fontSize: 20.0,
        foregroundColor: Colors.red,
        backgroundColor: Colors.yellow,
      ),
    ),
    BarcodeExampleDTO(
      "Code 39",
      "As above and height set to 60.0",
      Barcode39(
        data: "BARCODE39",
        showText: true,
        fontSize: 20.0,
        foregroundColor: Colors.red,
        backgroundColor: Colors.yellow,
        height: 60.0,
      ),
    ),
    BarcodeExampleDTO(
      "Code 39",
      [
        "Large value and showing the value as text.",
        "The line width is automatically scaled down so that the barcode fits its container.",
      ].join("\n"),
      Barcode39(
        data: "62733538535715976",
        showText: true,
      ),
    ),
    BarcodeExampleDTO(
      "Code 39",
      [
        "Small value and showing the barcode data as text underneath the bars.",
        "Line width is set to 1.0 (default is 2.0)",
        "",
        "As in this case, when a barcode is not as wide as its canvas," +
            "it will be positioned on the canvas according to its horizontal alignment",
        "",
        "horizontalAlignment=left (the default)",
      ].join("\n"),
      Barcode39(
        data: "BARCODE39",
        lineWidth: 1.0,
        showText: true,
      ),
    ),
    BarcodeExampleDTO(
      "Code 39",
      "As above, horizontalAlignment=center",
      Barcode39(
        data: "BARCODE39",
        lineWidth: 1.0,
        showText: true,
        horizontalAlignment: BarcodeAlignment.center,
      ),
    ),
    BarcodeExampleDTO(
      "Code 39",
      "As above, horizontalAlignment=end",
      Barcode39(
        data: "BARCODE39",
        lineWidth: 1.0,
        showText: true,
        horizontalAlignment: BarcodeAlignment.end,
      ),
    ),
    BarcodeExampleDTO(
      "Code 39",
      "The data for this example (BARCoDE39) contains a lower case character.\nThis is not valid for basic Code 39 so...\n\nbarcode.hasError = true;\n\nFor the purpose of this example, the value of barcode.lastErrorMessage is shown both on and below the canvas.\n\nHave a look at the code for BarcodePainter to see how the error is shown on the canvas.",
      Barcode39(
        data: "BARCoDE39",
        backgroundColor: Colors.yellow,
      ),
    ),
  ];
}
