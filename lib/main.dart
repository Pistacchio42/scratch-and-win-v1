import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scratcher/scratcher.dart';
import 'package:vibration/vibration.dart';

import 'GoldShineText.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gratta via il prurito di vittoria',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      home: MyHomePage(
        title: 'Gratta via il prurito di vittoria',
        storage: CounterStorage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.storage});

  final CounterStorage storage;
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final scratchKey = GlobalKey<ScratcherState>();
  int _counter = 0;
  bool scratched = false;
  late List<SizedBox> scratchList = [];
  var assets = [
    "assets/images/01.jpg",
    "assets/images/02.jpg",
    "assets/images/03.jpg",
    "assets/images/04.jpg",
    "assets/images/05.jpg",
    "assets/images/06.jpg",
    "assets/images/07.jpg",
    "assets/images/08.jpg",
    "assets/images/09.jpg",
    "assets/images/10.jpg",
    "assets/images/11.jpg",
    "assets/images/12.jpg",
    "assets/images/13.jpg",
    "assets/images/14.jpg",
    "assets/images/15.jpg",
    "assets/images/16.jpg",
    "assets/images/17.jpg",
    "assets/images/18.jpg",
    "assets/images/19.jpg",
    "assets/images/20.jpg",
    "assets/images/21.jpg",
    "assets/images/22.jpg",
    "assets/images/23.jpg",
    "assets/images/24.jpg",
    "assets/images/25.jpg",
    "assets/images/26.jpg",
  ];
  var selected = [0, 1, 2, 3, 4, 5];
  String soyjack = "assets/images/scratch.jpg";
  List keys = [];
  Timer? timer;
  bool first=true;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 12), (Timer t) => addMoney(1));
    // TODO: read value from money.txt and display it at the top of the app.
    //TODO: Check if the date in lastDate.txt is not today, if true give 5 money

    keys.add(new GlobalKey<ScratcherState>());
    keys.add(new GlobalKey<ScratcherState>());
    keys.add(new GlobalKey<ScratcherState>());
    keys.add(new GlobalKey<ScratcherState>());
    keys.add(new GlobalKey<ScratcherState>());
    keys.add(new GlobalKey<ScratcherState>());

    buyNewOne();
    widget.storage.readCounter().then((value) {
      setState(() {
        _counter = value;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<File>? buyNewOne() {
    if(!first && _counter<4) return null;
    for (int i = 0; i < 6; i++) {
      var intValue = Random().nextInt(assets.length);
      selected[i] = intValue;
    }
    setState(() {
      if(!first) {
        _counter -= 5;
      }
      first=false;
      scratchList.clear();
      for (int i = 0; i < 6; i++) {
        (keys.elementAt(i) as GlobalKey<ScratcherState>).currentState?.reset(
          duration: Duration(milliseconds: 100),
        );
        scratchList.add(ScratchPatch(i));
      }
    });

    return widget.storage.writeCounter(_counter);
  }

  Future<File> addMoney(int moneyToAdd) {
    setState(() {
      _counter += moneyToAdd;
    });
    return widget.storage.writeCounter(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GoldShineText('Gettoni: $_counter', size: 52),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              scratchList[0],
              SizedBox(height: 10, width: 10),
              scratchList[1],
            ],
          ),
          SizedBox(height: 10, width: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              scratchList[2],
              SizedBox(height: 10, width: 10),
              scratchList[3],
            ],
          ),
          SizedBox(height: 10, width: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              scratchList[4],
              SizedBox(height: 10, width: 10),
              scratchList[5],
            ],
          ),
        ],
      ),
      floatingActionButton: IconButton(
        onPressed: buyNewOne,
        icon: Icon(Icons.shopping_cart),
        tooltip: "Compra un nuovo biglietto a 5 gettoni",
      ),
    );
  }

  SizedBox ScratchPatch(int value) {
    return SizedBox(
      height: 200,
      width: 200,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Scratcher(
            key: keys.elementAt(value),
            image: Image.asset(soyjack),
            onChange: (percentage) => {
              if (percentage > 50) {checkVictory(value),}
              else vibrate(5),
            },
            child: SizedBox(
              height: 250,
              width: 250,
              child: Image.asset(assets[selected[value]]),
            ),
          ),
        ),
      ),
    );
  }

  var checkedBox = [false, false, false, false, false, false];

  void checkVictory(int value) {
    if (!checkedBox[value]) {
      print('check $value');
      checkedBox[value] = true;
      bool allChecked = checkedBox.fold(true, (t, e) => t && e);
      if (allChecked) wincondition();
    }
  }

  void wincondition() {
    //se ce ne sono 2 uguali 25 monete
    //3=> 100
    //4 => 500
    //5 => 1000
    //6 => 10000
    var howManyTimesDoesItAppear = Map();
    selected.forEach((value) {
      if (!howManyTimesDoesItAppear.containsKey(value)) {
        howManyTimesDoesItAppear[value] = 1;
      } else {
        howManyTimesDoesItAppear[value] += 1;
      }
    });
    howManyTimesDoesItAppear.forEach((key, value) {
      var mul = 1;
      switch (key) {
        case 0:
          if (value > 2) mul = 6;
          break;
        case 1:
          if (value > 2) mul = 5;
          break;
        case 2:
          if (value > 2) mul = 4;
          break;
        case 3:
          if (value > 2) mul = 3;
          break;
        case 4:
          if (value > 2) mul = 2;
          break;
      }

      switch (value) {
        case 2:
          addMoney(mul * 5);
          break;
        case 3:
          addMoney(mul * 100);
          break;
        case 4:
          addMoney(mul * 500);
          break;
        case 5:
          addMoney(mul * 1000);
          break;
        case 6:
          addMoney(mul * 10000);
          break;
      }
    });
    checkedBox = [false, false, false, false, false, false];
  }

  vibrate(int duration) async {
    if(await Vibration.hasVibrator()){
      if (await Vibration.hasAmplitudeControl())
        if(await Vibration.hasCustomVibrationsSupport()) {
          Vibration.vibrate(duration: duration,amplitude: 128);
        }
        else
          Vibration.vibrate(amplitude: 128);
        else
         Vibration.vibrate();
    }
  }
}

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/money.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }
}
