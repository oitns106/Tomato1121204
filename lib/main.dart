import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

void main()=>runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tomato alarm',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const DEFAULT_COUNT_DOWN=Duration.secondsPerMinute * 1;
  int counterDown=0;
  Timer? timer;
  final player=AudioPlayer();

  void resetCount() {
    setState(() {
      counterDown=5;
    });
  }

  void startCountDown() {
    if (timer!=null) timer!.cancel();
    counterDown = 5;
    timer=Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        counterDown--;
      });
      if (counterDown==0) {
        timer!.cancel();
        player.play(AssetSource('Alarm.mp3'));
        showDialog(context: context, builder: (context) {
          return AlertDialog(
            content: Text("成功獲得一顆蕃茄，請多注意休息~"),
            actions: [
              TextButton(onPressed: () {
                                         player.stop();
                                         Navigator.pop(context);
                                       },
                         child: Text('OK'),),
            ],
          );
        });
      }
    });
  }

  String padDigits(int value) {
    return value.toString().padLeft(2,'0');
  }

  String parseText() {
    return '${padDigits(counterDown~/60)}:${padDigits(counterDown%60)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tomato Alarm'),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(parseText(), style: TextStyle(fontSize: 48,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.blue),),
            GestureDetector(child: Text('Reset', style: TextStyle(fontSize: 32),),
                            onTap: resetCount,),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow),
        onPressed: startCountDown,
      ),
    );
  }
}

