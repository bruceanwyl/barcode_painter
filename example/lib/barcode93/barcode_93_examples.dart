import 'package:barcode_painter/barcode_painter.dart';
import 'package:barcode_painter_demo/common/barcode_example_dto.dart';
import 'package:flutter/material.dart';

class Barcode93Examples {
  static List<BarcodeExampleDTO> data = [
    BarcodeExampleDTO(
      "Code 93",
      "Small value, default values for all settings.",
      Code93Painter(
        data: "BARCODE93",
      ),
    ),
    BarcodeExampleDTO(
      "Code 93",
      [
        "As above and showing the barcode data as text under the bars.",
        "Note how the height of the lines is reduced by the amount of space needed to show the text.",
      ].join("\n"),
      Code93Painter(
        data: "BARCODE93",
        showText: true,
      ),
    ),
    BarcodeExampleDTO(
      "Code 93",
      "As above and fontSize is 20.",
      Code93Painter(
        data: "BARCODE93",
        showText: true,
        fontSize: 20.0,
      ),
    ),
    BarcodeExampleDTO(
      "Code 93",
      "As above and foregroundColor is red.",
      Code93Painter(
        data: "BARCODE93",
        showText: true,
        fontSize: 20.0,
        foregroundColor: Colors.red,
      ),
    ),
    BarcodeExampleDTO(
      "Code 93",
      "As above and backgroundColor is yellow.\nYes, it actually scans :-)",
      Code93Painter(
        data: "BARCODE93",
        showText: true,
        fontSize: 20.0,
        foregroundColor: Colors.red,
        backgroundColor: Colors.yellow,
      ),
    ),
    BarcodeExampleDTO(
      "Code 93",
      "As above and height set to 60.0",
      Code93Painter(
        data: "BARCODE93",
        showText: true,
        fontSize: 20.0,
        foregroundColor: Colors.red,
        backgroundColor: Colors.yellow,
        height: 60.0,
      ),
    ),
    BarcodeExampleDTO(
      "Code 93",
      [
        "Large value and showing the value as text.",
        "The line width is automatically scaled down so that the barcode fits its container.",
      ].join("\n"),
      Code93Painter(
        data: "62733538535715976",
        showText: true,
      ),
    ),
    BarcodeExampleDTO(
      "Code 93",
      [
        "Small value and showing the barcode data as text underneath the bars.",
        "Line width is set to 1.0 (default is 2.0)",
        "",
        "As in this case, when a barcode is not as wide as its canvas," +
            "it will be positioned on the canvas according to its horizontal alignment",
        "",
        "horizontalAlignment=left (the default)",
      ].join("\n"),
      Code93Painter(
        data: "BARCODE93",
        lineWidth: 1.0,
        showText: true,
      ),
    ),
    BarcodeExampleDTO(
      "Code 93",
      "As above, horizontalAlignment=center",
      Code93Painter(
        data: "BARCODE93",
        lineWidth: 1.0,
        showText: true,
        horizontalAlignment: BarcodeAlignment.center,
      ),
    ),
    BarcodeExampleDTO(
      "Code 93",
      "As above, horizontalAlignment=end",
      Code93Painter(
        data: "BARCODE93",
        lineWidth: 1.0,
        showText: true,
        horizontalAlignment: BarcodeAlignment.end,
      ),
    ),
    BarcodeExampleDTO(
      "Code 93",
      "The data for this example (BaRCODE93) contains a lower case character.\nThis is not valid for basic Code 93 so...\n\nbarcode.hasError = true;\n\nFor the purpose of this example, the value of barcode.lastErrorMessage is shown both on and below the canvas.\n\nHave a look at the code for BarcodePainter to see how the error is shown on the canvas.",
      Code93Painter(
        data: "BaRCODE93",
        backgroundColor: Colors.yellow,
      ),
    ),
  ];
}
