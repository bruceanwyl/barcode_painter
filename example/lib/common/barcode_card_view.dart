import 'package:barcode_painter/barcode_painter.dart';
import 'package:barcode_painter_demo/common/barcode_example_dto.dart';
import 'package:flutter/material.dart';

class BarcodeCardView extends StatelessWidget {
  final BarcodeExampleDTO data;

  const BarcodeCardView({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        elevation: 2.0,
        margin: EdgeInsets.only(bottom: 16.0),
        // color: Colors.blueGrey[50],
        child: Container(
          padding:
              EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 16.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      data.title,
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
                        data.description,
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
                children: <Widget>[
                  //
                  // When you put a BarcodePainter in a Row, it must be
                  // contained within an Expanded widget or it may overflow
                  // the right hand side of its containing Widget.
                  //
                  Expanded(
                    child: Container(
                      // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                      child: BarcodeCanvas(
                        painter: data.barcode,
                      ),
                    ),
                  ),
                ],
              ),
              !data.barcode.hasError
                  ? Row()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        //
                        // I want the text to wrap so it needs to be contained
                        // within an Expanded Widget.
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              data.barcode.lastErrorMessage,
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
            ],
          ),
        ),
      ),
    );
  }
}
