import 'package:barcode_painter/src/common/bar_encoding_dto.dart';

/// Takes a String value on construction and encodes it into a:
///   * List of bool as a left to right representation of barcode lines.
///       * true represents a black barcode line
///       * false represents a white barcode line
class Code39 {
  final String data;

  BarEncodingDTO get encodedStartCharacter => _startEncoding;
  BarEncodingDTO get encodedStopCharacter => _stopEncoding;
  BarEncodingDTO getCharacterEncoding(String character) {
    return _getCharacterEncoding(character);
  }

  /// Indicates whether the encoding of the barcode data was successful or not.
  bool get hasError {
    return _hasError;
  }

  /// If [hasError] is true then [lastErrorMessage] contains a description
  /// of the error that was encountered.
  String get lastErrorMessage {
    return _lastErrorMessage;
  }

  List<bool> getLinesAsBool() => _getLinesAsBool();

  Code39(this.data) {
    _buildBarcodeTable();
  }

  void _buildBarcodeTable() {
    _hasError = false;
    _lastErrorMessage = "";
    BarEncodingDTO dto;

    // Add the encoding for the start character
    _barcode.add(encodedStartCharacter);

    // Add the encoding for each character in the data string.
    for (int j = 0; j < data.length; j++) {
      String key = data[j];
      dto = getCharacterEncoding(key);
      if (dto == null) {
        _lastErrorMessage =
            "Failed to find a Code39 encoding for the character [$key]";
        _hasError = true;
        _barcode = [];
        return;
      }
      _barcode.add(dto);
    }

    // Add the encoding for the stop character
    _barcode.add(encodedStopCharacter);
  }

  List<bool> _getLinesAsBool() {
    List<bool> lines = [];

    // Conservative check, but if the value contains characters that cannot
    // be encoded as Barcode39 then we simply return the empty list.
    if (hasError) {
      return lines;
    }

    // All of the encoded characters for the barcode generation are present
    // and correct, so it is now as simple as...
    _barcode.forEach((dto) {
      for (int i = 0; i < 12; i++) {
        lines.add(_bitIsSet(i, dto.barEncoding));
      }
      // Add the inter character space, one white line.
      lines.add(false);
    });
    //  We do not need a trailing space after the last (stop) character
    lines.removeLast();
    return lines;
  }

  bool _bitIsSet(int position, int barEncoding) {
    int bitMask = 0x800; // 100000000000
    return (bitMask & (barEncoding << position)) == bitMask;
  }

  BarEncodingDTO _getCharacterEncoding(String character) {
    return _encodingTable.firstWhere(
      (item) => item.character == character,
      orElse: () => null,
    );
  }

  /// A table of each character that can be represented in Code39.
  ///
  /// The barEncoding field of each element contains an hexadecimal value that
  /// represents the binary form of a single character encoded as Code39 that...
  ///  * has one bit for each line in the barcode character
  ///  * is 12 bits (lines) wide
  ///  * starts with one or more solid (1) bars
  ///  * ends with one or more solid (1) bars
  ///  * can be visualised from the binary representation shown in
  ///    the comments below as follows:
  ///     * 1 is narrow solid bar
  ///     * 0 is a narrow space
  ///     * 11 is a wide solid bar (twice as wide as narrow)
  ///     * 00 is a wide space (twice as wide as narrow)
  ///
  /// Note also that a Code39 encoded character has a space between it
  /// and the next one that is not part of the actual encoded character.
  /// This space is the width of a single bar
  List<BarEncodingDTO> _encodingTable = [
    BarEncodingDTO('0', 0xa6d, 0), // 101001101101
    BarEncodingDTO('1', 0xd2b, 1), // 110100101011
    BarEncodingDTO('2', 0xb2b, 2), // 101100101011
    BarEncodingDTO('3', 0xd95, 3), // etc.
    BarEncodingDTO('4', 0xa6b, 4),
    BarEncodingDTO('5', 0xd35, 5),
    BarEncodingDTO('6', 0xb35, 6),
    BarEncodingDTO('7', 0xa5b, 7),
    BarEncodingDTO('8', 0xd2d, 8),
    BarEncodingDTO('9', 0xb2d, 9),
    BarEncodingDTO('A', 0xd4b, 10),
    BarEncodingDTO('B', 0xb4b, 11),
    BarEncodingDTO('C', 0xda5, 12),
    BarEncodingDTO('D', 0xacb, 13),
    BarEncodingDTO('E', 0xd65, 14),
    BarEncodingDTO('F', 0xb65, 15),
    BarEncodingDTO('G', 0xa9b, 16),
    BarEncodingDTO('H', 0xd4d, 17),
    BarEncodingDTO('I', 0xb4d, 18),
    BarEncodingDTO('J', 0xacd, 19),
    BarEncodingDTO('K', 0xd53, 20),
    BarEncodingDTO('L', 0xb53, 21),
    BarEncodingDTO('M', 0xda9, 22),
    BarEncodingDTO('N', 0xad3, 23),
    BarEncodingDTO('O', 0xd69, 24),
    BarEncodingDTO('P', 0xb69, 25),
    BarEncodingDTO('Q', 0xab3, 26),
    BarEncodingDTO('R', 0xd59, 27),
    BarEncodingDTO('S', 0xb59, 28),
    BarEncodingDTO('T', 0xad9, 29),
    BarEncodingDTO('U', 0xcab, 30),
    BarEncodingDTO('V', 0x9ab, 31),
    BarEncodingDTO('W', 0xcd5, 32),
    BarEncodingDTO('X', 0x96b, 33),
    BarEncodingDTO('Y', 0xcb5, 34),
    BarEncodingDTO('Z', 0x9b5, 35),
    BarEncodingDTO('-', 0x95b, 36),
    BarEncodingDTO('.', 0xcad, 37),
    BarEncodingDTO(' ', 0x9ad, 38),
    BarEncodingDTO('\$', 0x925, 39),
    BarEncodingDTO('/', 0x929, 40),
    BarEncodingDTO('+', 0x949, 41),
    BarEncodingDTO('%', 0xa49, 42),
  ];

  /// The actual barcode
  List<BarEncodingDTO> _barcode = [];

  /// The start character for a Code39 barcode.
  BarEncodingDTO _startEncoding = BarEncodingDTO('*', 0x96d, 43);

  /// The stop character for a Code39 barcode.
  BarEncodingDTO _stopEncoding = BarEncodingDTO('*', 0x96d, 43);

  // Value may change in _buildBarcodeTable()
  bool _hasError = false;

  // Value may change in _buildBarcodeTable()
  String _lastErrorMessage = "";
}
