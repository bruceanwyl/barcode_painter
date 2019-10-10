/// A data transfer object that holds the various representations of a
/// character that are used in the process of generating a barcode.
class BarEncodingDTO {
  /// The text character that is to be encoded into a barcode.
  final String character;

  /// A binary expression of the bars that produce the barcode for this
  /// character. For example 101011110 where:
  ///   * 1 indicates the position of a (typically black) bar
  ///   * 0 indicates the position of a (typically white) bar
  ///   * 11 is a double width black bar
  ///   * 00 is a double width white bar etc.
  final int barEncoding;

  /// Used to create checksums and as an index into the table of values.
  final int value;

  BarEncodingDTO(this.character, this.barEncoding, this.value);
}
