import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Initialize Hive
  await Hive.openBox('counters'); // Open a Hive box
  runApp(const MyApp());
}

//------------------------------------------------------------------------------
// Main App Widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color(0xFF292929), // Background color
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

//------------------------------------------------------------------------------
// Home Page
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: controller,
          children: const [
            DetailPage(date: "2024-22-19"),
            DetailPage(date: "2024-22-18")
          ],
        ));
  }
}

//------------------------------------------------------------------------------
// Detail Page
class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.date});

  final String date;

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
            Text(widget.date,
                style: const TextStyle(color: Colors.white, fontSize: 48)),
            TrackingElement(
                color: const Color(0xffd4da13),
                iconData: Icons.directions_run,
                unit: "m",
                max: 5000,
                date: widget.date),
            TrackingElement(
                color: const Color(0xff379bef),
                iconData: Icons.water_drop,
                unit: "ml",
                max: 3000,
                date: widget.date),
            TrackingElement(
                color: const Color(0xffff5858),
                iconData: Icons.lunch_dining,
                unit: "cal",
                max: 2000,
                date: widget.date)
          ],
        ));
  }
}

//------------------------------------------------------------------------------
// Tracking Element
class TrackingElement extends StatefulWidget {
  const TrackingElement({
    super.key,
    required this.color,
    required this.iconData,
    required this.unit,
    required this.max,
    required this.date,
  });

  final Color color;
  final IconData iconData;
  final String unit;
  final double max;
  final int steps = 5;
  final String date;

  String get storageKey => '${date}_${unit}';

  @override
  State<TrackingElement> createState() => _TrackingElementState();
}

class _TrackingElementState extends State<TrackingElement> {
  int _counter = 0;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    final box = Hive.box('counters'); // Open the Hive box
    setState(() {
      _counter = box.get(widget.storageKey, defaultValue: 0) as int; // Read from Hive
      _progress = _counter / widget.max;
    });
  }

  Future<void> _incrementCounter() async {
    if (_counter < widget.max) {
      setState(() {
        _counter += (widget.max / widget.steps).toInt();
        _progress = _counter / widget.max;
      });
      final box = Hive.box('counters'); // Open the Hive box
      box.put(widget.storageKey, _counter); // Write to Hive
    }
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
                Text(
                  ' $_counter / ${widget.max.toInt()} ${widget.unit}',
                  style: const TextStyle(color: Colors.white, fontSize: 35), // Text color
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
