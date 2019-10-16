import 'package:flutter/material.dart';

import 'barcode.dart';

/// A Widget that wraps a CustomPaint Widget that uses a Barcode object
/// to paint its content.
///
/// This Widget is provided as an example of how to use the CustomPaint Widget
/// with a Barcode object from this package.
///
/// You can easily create your own wrapper for CustomPaint and use that instead.
class BarcodePainter extends StatelessWidget {
  final Barcode barcode;
  final bool showErrors;

  /// Creates a Widget to use as a canvas and uses the barcode, a CustomPainter,
  /// to paint a barcode on that canvas.
  ///
  /// The actual width and height of the canvas can be larger or smaller than
  /// the preferredWidth and preferredHeight of the barcode.
  /// It is completely dependant on the rendered size of its parent.
  ///
  /// If the canvas size is larger than the preferred size of the barcode
  /// then the CustomPainter will align the barcode within the canvas using the
  /// values of horizontalAlignment and verticalAlignment.
  ///
  /// If the canvas size is narrower than the preferred width of the barcode,
  /// the CustomPainter will scale the line width down so that the barcode fits.
  const BarcodePainter({Key key, @required this.barcode, this.showErrors = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget childOfPaint = Container();
    if (showErrors && barcode.hasError) {
      childOfPaint = Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red, width: 4.0),
          color: Colors.yellow,
        ),
        padding: EdgeInsets.all(8.0),
        child: Text("Error: ${barcode.lastErrorMessage}"),
      );
    }
    return ClipRect(
      child: Container(
        // decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
        width: barcode.width,
        height: barcode.height,
        child: CustomPaint(
          child: childOfPaint,
          painter: barcode,
        ),
      ),
    );
  }
}
