import 'package:barcode_painter/barcode_painter.dart';
import 'package:flutter/material.dart';

class AlignmentDemo extends StatefulWidget {
  @override
  _AlignmentDemoState createState() => _AlignmentDemoState();
}

class _AlignmentDemoState extends State<AlignmentDemo> {
  BarcodeAlignment _verticalAlignment;
  BarcodeAlignment _horizontalAlignment;

  @override
  void initState() {
    super.initState();
    _verticalAlignment = BarcodeAlignment.start;
    _horizontalAlignment = BarcodeAlignment.start;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(16.0),
        // color: Colors.black26,
        child: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
            elevation: 2.0,
            margin: EdgeInsets.only(bottom: 16.0),
            // color: Colors.blueGrey[50],
            child: Container(
              padding: EdgeInsets.only(
                  top: 16.0, left: 16.0, right: 16.0, bottom: 16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          "Alignment",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      //
                      // I want the text to wrap so it needs to be contained
                      // within an Expanded Widget.
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            [
                              "The canvas on which a barcode is painted is the size of its parent.",
                              "If the canvas is larger than the barcode, then the barcode is positioned within the canvas based on its value of horizontal and vertical alignment.",
                              "",
                              "Try tapping the buttons.",
                            ].join("\n"),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 150.0,
                          // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                          color: Colors.black12,
                          child: BarcodeCanvas(
                            painter: Code39Painter(
                              height: 100.0,
                              data: "BARCODE39",
                              showText: true,
                              lineWidth: 1.0,
                              verticalAlignment: _verticalAlignment,
                              horizontalAlignment: _horizontalAlignment,
                              backgroundColor: Colors.yellow,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Text(
                          "Horizontal",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.format_align_left),
                          padding: EdgeInsets.all(0.0),
                          color: Colors.blue,
                          onPressed: () {
                            setState(() {
                              _horizontalAlignment = BarcodeAlignment.start;
                            });
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.format_align_center),
                          padding: EdgeInsets.all(0.0),
                          color: Colors.blue,
                          onPressed: () {
                            setState(() {
                              _horizontalAlignment = BarcodeAlignment.center;
                            });
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.format_align_right),
                          padding: EdgeInsets.all(0.0),
                          color: Colors.blue,
                          onPressed: () {
                            setState(() {
                              _horizontalAlignment = BarcodeAlignment.end;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Text(
                          "Vertical",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.vertical_align_top),
                          color: Colors.blue,
                          onPressed: () {
                            setState(() {
                              _verticalAlignment = BarcodeAlignment.start;
                            });
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.vertical_align_center),
                          color: Colors.blue,
                          onPressed: () {
                            setState(() {
                              _verticalAlignment = BarcodeAlignment.center;
                            });
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.vertical_align_bottom),
                          color: Colors.blue,
                          onPressed: () {
                            setState(() {
                              _verticalAlignment = BarcodeAlignment.end;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
