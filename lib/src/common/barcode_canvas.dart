import 'package:flutter/material.dart';

import 'barcode_painter.dart';

/// [BarcodeCanvas] wraps a CustomPaint Widget that uses a BarcodePainter
/// object to paint its content.
///
/// This Widget is provided as an example of how to use the CustomPaint Widget
/// with a BarcodePainter object from this package.
///
/// You can easily create your own wrapper for CustomPaint and use that instead.
class BarcodeCanvas extends StatelessWidget {
  final BarcodePainter painter;
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
  const BarcodeCanvas({Key key, @required this.painter, this.showErrors = true})
      : assert(painter != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget childOfPaint = Container();
    if (showErrors && painter.hasError) {
      childOfPaint = Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red, width: 4.0),
          color: Colors.yellow,
        ),
        padding: EdgeInsets.all(8.0),
        child: Text("Error: ${painter.lastErrorMessage}"),
      );
    }
    return ClipRect(
      child: Container(
        // decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
        // Uncomment the above line if you want to see the
        // boundaries of your canvas.
        width: painter.width,
        height: painter.height,
        child: CustomPaint(
          child: childOfPaint,
          painter: painter,
        ),
      ),
    );
  }
}
