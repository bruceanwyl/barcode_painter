import '../common/bar_encoding_dto.dart';

/// Takes a String value on construction and encodes it into a:
///   * List of bool as a left to right representation of barcode lines.
///       * true represents a black barcode line
///       * false represents a white barcode line
class Code93 {
  final String data;

  BarEncodingDTO get encodedStartCharacter => _startEncoding;
  BarEncodingDTO get encodedStopCharacter => _stopEncoding;
  BarEncodingDTO getCharacterEncoding(String character) {
    return _getCharacterEncoding(character);
  }

  /// Returns the value of the Code93 "C" checksum.
  ///
  /// algorithm based on Code93 barcode description at http://www.barcodeisland.com/code93.phtml
  int get checkSumC => _checkSumC();

  /// Returns the value of the Code93 "K" checksum.
  ///
  /// algorithm based on Code93 barcode description at http://www.barcodeisland.com/code93.phtml
  int get checkSumK => _checkSumK();

  /// Indicates whether the encoding of the barcode data and the two
  /// checksum values was successful or not.
  bool get hasError {
    return _hasError;
  }

  /// If [hasError] is true then [lastErrorMessage] contains a description
  /// of the error that was encountered.
  String get lastErrorMessage {
    return _lastErrorMessage;
  }

  List<bool> getLinesAsBool() => _getLinesAsBool();

  Code93(this.data) {
    _buildBarcodeTable();
  }

  /// Creates the representation of the barcode as a list of [BarEncodingDTO]
  /// objects.
  void _buildBarcodeTable() {
    _hasError = false;
    _lastErrorMessage = "";
    BarEncodingDTO dto;

    // Add the encoding for the start character
    _barcodeTable.add(encodedStartCharacter);

    // Add the encoding for each character in the data string.
    for (int j = 0; j < data.length; j++) {
      String key = data[j];
      dto = getCharacterEncoding(key);
      if (dto == null) {
        _lastErrorMessage =
            "Failed to find a Code93 encoding for the character [$key]";
        _hasError = true;
        _barcodeTable = [];
        return;
      }
      _barcodeTable.add(dto);
    }

    // Add the encoding for the "C" checksum
    int checksumC = _checkSumC();
    dto = _getEncodingForValue(checksumC);
    if (dto == null) {
      _lastErrorMessage =
          "Failed to find a Code93 encoding for the checksum 'C' value [$checksumC]";
      _hasError = true;
      _barcodeTable = [];
      return;
    }
    _barcodeTable.add(dto);

    // Add the encoding for the "K" checksum
    int checksumK = _checkSumK();
    dto = _getEncodingForValue(checksumK);
    if (dto == null) {
      _lastErrorMessage =
          "Failed to find a Code93 encoding for the checksum 'K' value [$checksumK]";
      _hasError = true;
      _barcodeTable = [];
      return;
    }
    _barcodeTable.add(dto);

    // Add the encoding for the stop character
    _barcodeTable.add(encodedStopCharacter);
  }

  List<bool> _getLinesAsBool() {
    List<bool> lines = [];

    // Conservative check, but if the value contains characters that cannot
    // be encoded as Barcode93 then we simply return the empty list.
    if (hasError) {
      return lines;
    }

    // All of the encoded characters for the barcode generation are present
    // and correct, so it is now as simple as...
    _barcodeTable.forEach((dto) {
      for (int i = 0; i < 9; i++) {
        lines.add(_bitIsSet(i, dto.barEncoding));
      }
    });

    // Important!!!
    //
    // The Code93 barcode has a single solid line appended to the end.
    lines.add(true);

    return lines;
  }

  int _checkSumC() {
    //
    // If we already have found an error in the data,
    // there is no point to continue here.
    //
    if (this._hasError) {
      return 0;
    }

    int weight = 0;
    int weightedSum = 0;
    int total = 0;

    this.data.split('').reversed.forEach((String character) {
      BarEncodingDTO dto = getCharacterEncoding(character);

      // Not expecting this to ever happen but...
      if (dto == null) {
        this._hasError = true;
        this._lastErrorMessage =
            "Could not find a Code93 encoding for character=$character";
      }

      // generates a continuous sequence 1..20 followed by 1..20 etc etc
      weight = ++weight <= 20 ? weight : 1;
      weightedSum = dto.value * weight;
      total += weightedSum;
    });

    if (this._hasError) {
      return 0;
    } else {
      return total % 47;
    }
  }

  int _checkSumK() {
    //
    // If we already have found an error in the data,
    // there is no point to continue here.
    //
    if (this._hasError) {
      return 0;
    }

    int weight = 0;
    int weightedSum = 0;
    int total = 0;

    BarEncodingDTO dto;
    // The first values come from checksumC
    int checksum = this.checkSumC;
    dto = _getEncodingForValue(checksum);
    // Not expecting this to ever happen but...
    if (dto == null) {
      this._hasError = true;
      this._lastErrorMessage =
          "Could not find a Code93 encoding with value=$checksum";
    }
    // generates a continuous sequence 1..15 followed by 1..15 etc etc
    weight = ++weight <= 15 ? weight : 1;
    weightedSum = dto.value * weight;
    total += weightedSum;

    // Now we work on the data.
    this.data.split('').reversed.forEach((String character) {
      BarEncodingDTO dto = getCharacterEncoding(character);
      // Not expecting this to ever happen but...
      if (dto == null) {
        this._hasError = true;
        this._lastErrorMessage =
            "Could not find a Code93 encoding for character=$character";
      }
      // generates a continuous sequence 1..15 followed by 1..15 etc etc
      weight = ++weight <= 15 ? weight : 1;
      weightedSum = dto.value * weight;
      total += weightedSum;
    });
    if (this._hasError) {
      return 0;
    } else {
      return total % 47;
    }
  }

  bool _bitIsSet(int position, int barEncoding) {
    int bitMask = 0x100; // 100000000
    return (bitMask & (barEncoding << position)) == bitMask;
  }

  BarEncodingDTO _getCharacterEncoding(String character) {
    return _encodingTable.firstWhere(
      (item) => item.character == character,
      orElse: () => null,
    );
  }

  BarEncodingDTO _getEncodingForValue(int value) {
    return _encodingTable.firstWhere(
      (item) => item.value == value,
      orElse: () => null,
    );
  }

  /// A table with one row for each character that can be represented
  /// in Code93.
  ///
  /// The barEncoding field of each element contains an hexadecimal value that
  /// represents the binary form of a single character encoded as Code93 that...
  ///  * has one bit for each line in the barcode character
  ///  * is 9 bits (lines) wide
  ///  * starts with one or more solid (1) bars
  ///  * ends with a single space (0)
  ///  * can be visualised from the binary representation shown in
  ///    the comments below as follows:
  ///     * 1 is narrow solid bar
  ///     * 0 is a narrow space
  ///     * 11 is a wide solid bar (twice as wide as narrow)
  ///     * 00 is a wide space (twice as wide as narrow)
  ///
  final List<BarEncodingDTO> _encodingTable = [
    BarEncodingDTO('0', 0x114, 0), //  100010100
    BarEncodingDTO('1', 0x148, 1), //  101001000
    BarEncodingDTO('2', 0x144, 2), //  101000100
    BarEncodingDTO('3', 0x142, 3), //  101000010
    BarEncodingDTO('4', 0x128, 4), //  100101000
    BarEncodingDTO('5', 0x124, 5), //  100100100
    BarEncodingDTO('6', 0x122, 6), //  100100010
    BarEncodingDTO('7', 0x150, 7), //  101010000
    BarEncodingDTO('8', 0x112, 8), //  100010010
    BarEncodingDTO('9', 0x10a, 9), //  100001010
    BarEncodingDTO('A', 0x1a8, 10), //  110101000
    BarEncodingDTO('B', 0x1a4, 11), //  110100100
    BarEncodingDTO('C', 0x1a2, 12), //  110100010
    BarEncodingDTO('D', 0x194, 13), //  110010100
    BarEncodingDTO('E', 0x192, 14), //  110010010
    BarEncodingDTO('F', 0x18a, 15), //  110001010
    BarEncodingDTO('G', 0x168, 16), //  101101000
    BarEncodingDTO('H', 0x164, 17), //  101100100
    BarEncodingDTO('I', 0x162, 18), //  101100010
    BarEncodingDTO('J', 0x134, 19), //  100110100
    BarEncodingDTO('K', 0x11a, 20), //  100011010
    BarEncodingDTO('L', 0x158, 21), //  101011000
    BarEncodingDTO('M', 0x14c, 22), //  101001100
    BarEncodingDTO('N', 0x146, 23), //  101000110
    BarEncodingDTO('O', 0x12c, 24), //  100101100
    BarEncodingDTO('P', 0x116, 25), //  100010110
    BarEncodingDTO('Q', 0x1b4, 26), //  110110100
    BarEncodingDTO('R', 0x1b2, 27), //  110110010
    BarEncodingDTO('S', 0x1ac, 28), //  110101100
    BarEncodingDTO('T', 0x1a6, 29), //  110100110
    BarEncodingDTO('U', 0x196, 30), //  110010110
    BarEncodingDTO('V', 0x19a, 31), //  110011010
    BarEncodingDTO('W', 0x16c, 32), //  101101100
    BarEncodingDTO('X', 0x166, 33), //  101100110
    BarEncodingDTO('Y', 0x136, 34), //  100110110
    BarEncodingDTO('Z', 0x13a, 35), //  100111010
    BarEncodingDTO('-', 0x12e, 36), //  100101110
    BarEncodingDTO('.', 0x1d4, 37), //  111010100
    BarEncodingDTO(' ', 0x1d2, 38), //  111010010
    BarEncodingDTO('\$', 0x1ca, 39), // 111001010
    BarEncodingDTO('/', 0x16e, 40), //  101101110
    BarEncodingDTO('+', 0x176, 41), //  101110110
    BarEncodingDTO('%', 0x1ae, 42), //  110101110
  ];

  /// The actual barcode
  List<BarEncodingDTO> _barcodeTable = [];

  /// The start character for a Code93 barcode.
  final BarEncodingDTO _startEncoding =
      BarEncodingDTO('*', 0x15e, 43); //  101011110;

  /// The stop character for a Code93 barcode.
  final BarEncodingDTO _stopEncoding =
      BarEncodingDTO('*', 0x15e, 43); //  101011110

  // Value may change in _buildBarcodeTable() or during checksum calculations
  bool _hasError = false;

  // Value may change in _buildBarcodeTable() or during checksum calculations
  String _lastErrorMessage = "";
}
