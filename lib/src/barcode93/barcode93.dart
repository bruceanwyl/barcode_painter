import 'package:barcode_painter/src/barcode93/barcode93_core.dart';
import 'package:barcode_painter/src/common/barcode.dart';
import 'package:flutter/rendering.dart';

/// A CustomPainter that represents a basic Code93 barcode
/// as defined in /// https://en.wikipedia.org/wiki/Code_93#Detailed_Outline
///
/// The Full ASCII code version of Code93 described in
/// https://en.wikipedia.org/wiki/Code_93#Full_ASCII_Code_93  is not implemented.
///
/// You can use [Barcode93] in in its simplest form as follows
/// ```Dart
///        Container(
///        child: BarcodePainter(
///          barcode: Barcode93(
///            data: "62733538535715976",
///            showText: true,
///          ),
///        ),
///      ),
/// ```
class Barcode93 extends Barcode {
  /// The value of the barcode that would be read by a barcode scanner.
  final String data;

  /// The width of each barcode line. The default value is 2.0
  final double lineWidth;

  /// The color that the solid lines are painted. The default is black.
  final Color foregroundColor;

  /// The color that the canvas background is painted, effectively the same
  /// as if we had painted the spaces this color. The default is white.
  final Color backgroundColor;

  /// If true, the barcode data is shown as text beneath the barcode itself.
  ///
  /// The default is false.
  final bool showText;

  /// The font size of the text below the barcode, if it is shown.
  ///
  /// The default is 15.0
  final double fontSize;

  /// A callback that if provided, will receive any error messages from here.
  final BarcodeError onError;

  /// The preferred width of the barcode.
  ///
  /// The value is calculated in the constructor using the [lineWidth]
  /// and number of characters in the barcode [data] and the number of lines
  /// in each barcode character representation (9).
  ///
  /// If the widget containing this barcode is smaller than the preferred width
  /// then the barcode lineWidth is scaled down so that it will fit.
  @override
  double get width => _preferredWidth;

  /// Indicates whether or not an error occurred while creating the barcode
  /// from the data provided as a value.
  @override
  bool get hasError => this._code93Core.hasError;

  /// A description of the most recent error encountered.
  @override
  String get lastErrorMessage => this._code93Core.lastErrorMessage;

  final BarcodeAlignment horizontalAlignment;
  final BarcodeAlignment verticalAlignment;

  /// Creates a CustomPainter that can paint a Code93 format barcode.
  Barcode93({
    this.data,
    this.lineWidth = 2.0,
    double height = 100.0,
    this.foregroundColor = const Color(0xFF000000),
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.showText = false,
    this.fontSize = 15.0,
    this.onError,
    this.horizontalAlignment = BarcodeAlignment.start,
    this.verticalAlignment = BarcodeAlignment.start,
  }) : super(height: height) {
    // This is the canvas width required to render the barcode data
    // using the requested lineWidth.
    // We have data, stop and start characters and two checksum characters,
    // 9 lines per character and one extra solid bar at the end.
    _preferredWidth = (data.length + 4) * 9 * lineWidth + lineWidth;
    _code93Core = Barcode93Core(data);
  }

  /// Paints the barcode.
  @override
  void paint(Canvas canvas, Size size) {
    Paint painter = Paint()..style = PaintingStyle.fill;
    double scaledLineWidth = lineWidth;
    double lineLeft = 0.0;
    double paintStart = 0.0;
    double paintWidth = size.width;
    double lineTop = 0.0;

    if (height < size.height) {
      // we need to align the barcode vertically
      switch (verticalAlignment) {
        case BarcodeAlignment.start:
          lineTop = 0.0;
          break;
        case BarcodeAlignment.center:
          lineTop = (size.height - height) / 2.0;
          break;
        case BarcodeAlignment.end:
          lineTop = size.height - height;
          break;
      }
    }

    if (_preferredWidth > size.width) {
      //
      // If the size of our container is less than our preferred width,
      // then we scale the lineWidth so that the barcode will fit exactly
      // inside the container.
      //
      scaledLineWidth = lineWidth * size.width / _preferredWidth;
    }
    if (_preferredWidth < size.width) {
      //
      // We will only paint to the preferred width and take into account
      // the alignment parameters.
      switch (horizontalAlignment) {
        case BarcodeAlignment.start:
          // actually nothing to do for this one
          break;
        case BarcodeAlignment.center:
          paintStart = (size.width - _preferredWidth) / 2.0;
          break;
        case BarcodeAlignment.end:
          paintStart = size.width - _preferredWidth;
          break;
      }
      paintWidth = _preferredWidth;
    }

    if (_code93Core.hasError) {
      // we might do something here in the future
    } else {
      //
      // Now we can fill the area to be painted with the backgroundColor.
      //
      Rect rect = Rect.fromLTWH(paintStart, lineTop, paintWidth, height);
      painter.color = this.backgroundColor;
      canvas.drawRect(rect, painter);
      //
      // If we are showing the text below the barcode, we need reduce the bar
      // height by the amount of space taken by text of size [fontSize].
      // Thus we will have space below the barcode, and within the canvas,
      // where we can print the text.
      // We remove 20% of the fontSize value, to get similar spacing
      // above and below the text.
      //
      double lineHeight = showText ? height - 1.2 * this.fontSize : height;
      lineLeft = paintStart;
      painter.color = this.foregroundColor;
      _code93Core.getLinesAsBool().forEach((printBarcode) {
        if (printBarcode) {
          canvas.drawRect(
            Rect.fromLTWH(lineLeft, lineTop, scaledLineWidth, lineHeight),
            painter,
          );
        }
        // The next line position on the canvas.
        lineLeft += scaledLineWidth;
      });

      // Optionally, paint the barcode text
      if (showText) {
        // Reset our position to 2.5 barcode characters from the origin
        // of the barcode. With alignment, this is additionally offset by
        // the value of paintStart.
        // Remember that each Code93 barcode character consists of 9 bars and
        // there are two checksum characters as well.
        // All of this effort will space the text characters nicely as well as
        // aligning the center of the text with the center of the barcode.
        double charCenter = scaledLineWidth * 9 * 2.5 + paintStart;
        TextStyle textStyle = TextStyle(
          color: this.foregroundColor,
          fontSize: this.fontSize,
        );
        for (int i = 0; i < data.length; i++) {
          TextSpan span = TextSpan(style: textStyle, text: data[i]);
          TextPainter textPainter = TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
          );
          textPainter.layout();
          //  After layout(), we can determine how wide the character is...
          double minIntrinsicWidth = textPainter.minIntrinsicWidth;
          //  ... and offset the character to the left by half of its width so
          //      that it is neatly centered underneath the barcode character.
          double dx = charCenter - minIntrinsicWidth / 2.0;
          textPainter.paint(canvas, Offset(dx, lineTop + lineHeight));
          // move to the center of the next character position
          charCenter += 9 * scaledLineWidth;
        }
      }
    }
  }

  /// Always returns false for this implementation because the data cannot change.
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  //
  // private attributes and methods
  //
  double _preferredWidth;
  Barcode93Core _code93Core;
}
