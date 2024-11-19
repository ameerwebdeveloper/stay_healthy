import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

//------------------------------------------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color(0xFF292929), //Hintergunf Farbe
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

//------------------------------------------------------------------------------
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//------------------------------------------------------------------------------

class _MyHomePageState extends State<MyHomePage> {
  final controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
      controller: controller,
      children: const [
        DetailPage(headline: "Heute"),
        DetailPage(headline: "gestern")
      ],
    ));
  }
}

//------------- Ein Page

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.headline});

  final String headline;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 60, 0, 32),
        child: Column(
          children: [
            Text(widget.headline,
                style: const TextStyle(color: Colors.white, fontSize: 48)),
            const TrackingElement(
                color: Color(0xffd4da13),
                iconData: Icons.directions_run,
                unit: "m",
                max: 5000),
            const TrackingElement(
                color: Color(0xff379bef),
                iconData: Icons.water_drop,
                unit: "ml",
                max: 3000),
            const TrackingElement(
                color: Color(0xffff5858),
                iconData: Icons.lunch_dining,
                unit: "cal",
                max: 2000)
          ],
        ));
  }
}

//---- balken und texte
class TrackingElement extends StatefulWidget {
  const TrackingElement({
    super.key,
    required this.color,
    required this.iconData,
    required this.unit,
    required this.max,
  });

  final Color color;
  final IconData iconData;
  final String unit;
  final double max;
  final int steps = 5;

  @override
  State<TrackingElement> createState() => _TrackingElementState();
}

class _TrackingElementState extends State<TrackingElement> {
  int _counter = 0;
  double _progress = 0;

  void _incrementCounter() {
    setState(() {
      if (_counter < widget.max) {
        _counter += (widget.max / widget.steps).toInt();
        _progress += 1 / widget.steps;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _incrementCounter,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(32, 80, 32, 24),
            child: Row(
              children: <Widget>[
                Icon(widget.iconData, color: Colors.white70, size: 50),
                Text(' $_counter / ${widget.max.toInt()} ${widget.unit}',
                    style: const TextStyle(
                        color: Colors.white, fontSize: 35) //Schrift farbe,
                    ),
              ],
            ),
          ),
          LinearProgressIndicator(
            value: _progress,
            color: widget.color,
            backgroundColor: const Color(0x9dffffff),
            minHeight: 12.0,
          )
        ],
      ),
    );
  }
}
