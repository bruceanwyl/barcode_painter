import 'package:flutter/material.dart';

// import 'package:flutter/widgets.dart';

import 'barcode.dart';

/// Creates a Widget to use as a canvas and uses the barcode CustomPainter,
/// provided in the constructor, to paint a barcode on that canvas.
///
/// The only thing this Widget knows about the barcode painter is its
/// preferredWidth and preferredHeight. The actual width and height can vary
/// depending on the size of the parent(s) of this Widget in the Widget tree.
class BarcodePainter extends StatelessWidget {
  final Barcode barcode;

  const BarcodePainter({Key key, this.barcode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Column(
        children: <Widget>[
          Container(
            width: barcode.width,
            height: barcode.height,
            child: CustomPaint(
              painter: barcode,
            ),
          ),
        ],
      ),
    );
  }
}
