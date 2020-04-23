import 'package:flutter/rendering.dart';
import 'package:barcode_painter/src/common/barcode.dart';
import 'package:barcode_painter/src/barcode39/barcode39_core.dart';

/// A CustomPainter that represents a basic Code39 barcode
/// as defined in https://en.wikipedia.org/wiki/Code_39
///
/// You can use it in its simplest form as follows
/// ```Dart
///        Container(
///        child: BarcodePainter(
///          barcode: Barcode39(
///            data: "62733538535715976",
///            showText: true,
///          ),
///        ),
///      ),
/// ```
class Barcode39 extends Barcode {
  /// The value of the barcode that would be read by a barcode scanner.
  final String data;

  /// The width of each barcode line. The default value is 2.0
  final double lineWidth;

  /// The color that the solid lines are painted. The default is black.
  final Color foregroundColor;

  /// The color that the canvas background is painted, effectively the same
  /// as if we had painted the spaces this color. The default is white.
  final Color backgroundColor;

  /// Do you want the barcode data shown as text beneath the barcode itself.
  ///
  /// The default is false.
  final bool showText;

  /// The font size of the text displayed below the barcode, if it is shown.
  ///
  /// The default is 15.0
  final double fontSize;

  /// A callback that if provided, will receive any error messages from here.
  final BarcodeError onError;

  /// The preferred width of the barcode.
  ///
  /// The value is calculated in the constructor using the [lineWidth]
  /// and number of characters in the barcode [data] and the number of lines
  /// in each barcode character representation (12).
  ///
  /// If the widget containing this barcode is smaller than the preferred width
  /// then the barcode lineWidth is scaled down so that it will fit.
  @override
  double get width => _preferredWidth;

  /// Indicates whether or not an error occurred while creating the barcode
  /// from the data provided as a value.
  @override
  bool get hasError => this._code39Core.hasError;

  /// A description of the most recent error encountered.
  @override
  String get lastErrorMessage => this._code39Core.lastErrorMessage;

  /// If the canvas is wider than the barcode then it will be positioned
  /// horizontally on the canvas based on the value of horizontalAlignment.
  final BarcodeAlignment horizontalAlignment;

  /// If the canvas is taller than the barcode then it will be positioned
  /// vertically on the canvas based on the value of verticalAlignment.
  final BarcodeAlignment verticalAlignment;

  /// Creates a CustomPainter that can paint a Code39 format barcode.
  Barcode39({
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
    // with the specified lineWidth.
    // We have data, stop and start characters, 12 lines per character
    // and a one line space between all characters but no trailing space
    // after the last character.
    _preferredWidth = (data.length + 2) * 13 * lineWidth - lineWidth;
    _code39Core = BarCode39Core(this.data);
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
      // If the width of our container is less than our preferred width,
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

    if (_code39Core.hasError) {
      // let the outside world know we have a problem with the data.
      //this.onError(_code39Core.lastErrorMessage);
      // This turns out to be a bad idea.
      //TODO: remove it from the interface also.
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
      // Paint the barcode
      painter.color = this.foregroundColor;
      _code39Core.getLinesAsBool().forEach((printSolidBarcodeLine) {
        if (printSolidBarcodeLine) {
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
        // Reset our position to 1.5 barcode characters from the origin
        // of the barcode. With alignment, this is additionally offset by
        // the value of paintStart.
        // Remembering that each Code39 barcode character is 12 bars followed
        // by a single bar of space.
        // All of this effort will space the text characters nicely as well as
        // aligning the center of the text with the center of the barcode.
        double charCenter = scaledLineWidth * 13 * 1.5 + paintStart;
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
          charCenter += 13 * scaledLineWidth;
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
  BarCode39Core _code39Core;
}
