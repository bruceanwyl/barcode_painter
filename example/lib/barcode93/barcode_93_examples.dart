import 'package:barcode_painter/barcode_painter.dart';
import 'package:barcode_painter_demo/common/barcode_example_dto.dart';
import 'package:flutter/material.dart';

class Barcode93Examples {
//
  // Note that hot reload has no effect if you change the data here.
  // You need to reload the app.
  //
  static List<BarcodeExampleDTO> data = [
    BarcodeExampleDTO(
      "Code 93",
      "Small value, default values for all settings.",
      Barcode93(
        data: "BARCODE93",
      ),
    ),
    BarcodeExampleDTO(
      "Code 93",
      [
        "As above and showing the barcode data as text under the bars.",
        "Note how the height of the lines is reduced by the amount of space needed to show the text.",
      ].join("\n"),
      Barcode93(
        data: "BARCODE93",
        showText: true,
      ),
    ),
    BarcodeExampleDTO(
      "Code 93",
      "As above and fontSize is 20.",
      Barcode93(
        data: "BARCODE93",
        showText: true,
        fontSize: 20.0,
      ),
    ),
    BarcodeExampleDTO(
      "Code 93",
      "As above and foregroundColor is red.",
      Barcode93(
        data: "BARCODE93",
        showText: true,
        fontSize: 20.0,
        foregroundColor: Colors.red,
      ),
    ),
    BarcodeExampleDTO(
      "Code 93",
      "As above and backgroundColor is yellow.\nYes, it actually scans :-)",
      Barcode93(
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
      Barcode93(
        data: "BARCODE93",
        showText: true,
        fontSize: 20.0,
        foregroundColor: Colors.red,
        backgroundColor: Colors.yellow,
        height: 60,
      ),
    ),
    BarcodeExampleDTO(
      "Code 93",
      [
        "Large value and showing the value as text.",
        "The line width is automatically scaled down so that the barcode fits its container.",
      ].join("\n"),
      Barcode93(
        data: "62733538535715976",
        showText: true,
      ),
    ),
    BarcodeExampleDTO(
      "Code 93",
      "Small barcode with text. Line width is set to 1.0 (default is 2.0)",
      Barcode93(
        data: "BARCODE93",
        lineWidth: 1.0,
        showText: true,
      ),
    ),
    BarcodeExampleDTO(
      "Code 93",
      "The data for this example (BaRCODE93) contains a lower case character.\nThis is not valid for basic Code 93 so...\n\nbarcode.hasError = true;\n\nThe background color is yellow to demonstrate that the painter still renders the canvas, but without bars or text.\n\nThe value of barcode.lastErrorMessage is shown below the canvas.",
      Barcode93(
        data: "BaRCODE93",
        backgroundColor: Colors.yellow,
      ),
    ),
  ];
}
