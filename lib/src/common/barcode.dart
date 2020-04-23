import 'package:flutter/material.dart';

typedef void BarcodeError(String errorMessage);

enum BarcodeAlignment { start, center, end }

// enum VerticalAlignment { start, center, end }

/// The base class for painting barcodes.
///
/// This class is abstract, while extending CustomPainter so that subclasses
/// must implement the CustomPainter interface as well as getting the two
/// fields that the BarcodePainter class uses to size the Container wrapping
/// its CustomPaint widget.
///
/// It also indicates whether the barcode that it is going to paint
/// has an error condition or not.
abstract class Barcode extends CustomPainter {
  Barcode({this.height});

  /// The preferred, or minimum, width of the Canvas that can fit the bars
  /// representing the data at the line width specified (by the subclass)
  ///
  /// This value is calculated by the subclass and so is only a getter.
  double get width;

  /// The preferred, or minimum, height of the barcode.
  ///
  /// The value of height includes the space taken by the barcode text,
  /// if it is being shown.
  final double height;

  /// Indicates whether or not an error occurred while creating the barcode
  /// from the data provided as a value.
  bool get hasError;

  /// A description of the most recent error encountered.
  String get lastErrorMessage;
}
