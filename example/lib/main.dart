import 'package:barcode_painter_demo/alignment_demo.dart';
import 'package:flutter/material.dart';

import 'package:barcode_painter_demo/barcode39/barcode_39_examples.dart';
import 'package:barcode_painter_demo/barcode93/barcode_93_examples.dart';
import 'package:barcode_painter_demo/common/barcode_card_view.dart';
import 'package:barcode_painter_demo/common/barcode_example_dto.dart';
import 'package:barcode_painter_demo/common/placeholder_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barcode Painter Examples',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: LandingPage(title: 'Barcode Painter Examples'),
    );
  }
}

class LandingPage extends StatefulWidget {
  LandingPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyLandingPageState createState() => _MyLandingPageState();
}

class _MyLandingPageState extends State<LandingPage> with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: 8);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Painter'),
        centerTitle: true,
        bottom: TabBar(
          controller: _controller,
          isScrollable: true,
          unselectedLabelColor: Colors.white.withOpacity(0.3),
          indicatorColor: Colors.white,
          tabs: <Widget>[
            Tab(child: Text("Alignment")),
            Tab(child: Text("Code 39")),
            Tab(child: Text("Code 93")),
            Tab(child: Text("Code 128")),
            Tab(child: Text("EAN 8")),
            Tab(child: Text("EAN 13")),
            Tab(child: Text("UPC A")),
            Tab(child: Text("UPC E")),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          AlignmentDemo(),
          //_buildRawList(key: "rawcode39", data: Barcode39Examples.data),
          _buildList(key: "Code39", data: Barcode39Examples.data),
          _buildList(key: "Code93", data: Barcode93Examples.data),
          PlaceholderWidget("Coming soon..."),
          PlaceholderWidget("Coming soon..."),
          PlaceholderWidget("Coming soon..."),
          PlaceholderWidget("Coming soon..."),
          PlaceholderWidget("Coming soon..."),
        ],
      ),
    );
  }

  // Widget _buildRawList({String key, List<BarcodeExampleDTO> data}) {
  //   return ListView.builder(
  //     key: PageStorageKey(key),
  //     itemCount: data.length,
  //     itemBuilder: (BuildContext context, int index) {
  //       return Container(
  //         decoration: BoxDecoration(border: Border.all()),
  //         child: BarcodePainter(
  //           barcode: data[index].barcode,
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildList({String key, List<BarcodeExampleDTO> data}) {
    return Container(
      padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      color: Colors.blueGrey[50],
      child: ListView.builder(
        key: PageStorageKey(key),
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return BarcodeCardView(data: data[index]);
        },
      ),
    );
  }
}
