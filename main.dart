// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyAppHome(),
    );
  }
}

class MyAppHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppHomeState();
  }
}

class _MyAppHomeState extends State<MyAppHome> {
  int typedCharLength = 0;
  String lorem =
      "                                                  Lorem Ipsum, dizgi ve baskı endüstrisinde kullanılan mıgır metinlerdir. Lorem Ipsum, adı bilinmeyen bir matbaacının bir hurufat numune kitabı oluşturmak üzere bir yazı galerisini alarak karıştırdığı 1500'lerden beri endüstri standardı sahte metinler olarak kullanılmıştır. Beşyüz yıl boyunca varlığını sürdürmekle kalmamış, aynı zamanda pek değişmeden elektronik dizgiye de sıçramıştır. 1960'larda Lorem Ipsum pasajları da içeren Letraset yapraklarının yayınlanması ile ve yakın zamanda Aldus PageMaker gibi Lorem Ipsum sürümleri içeren masaüstü yayıncılık yazılımları ile popüler olmuştur."
          .toLowerCase()
          .replaceAll(',', '')
          .replaceAll('.', '');

  int step = 0;
  late int lastTypedAt;

  void updateLastTypedAt() {
    this.lastTypedAt = new DateTime.now().millisecondsSinceEpoch;
  }

  void onType(String value) {
    updateLastTypedAt();
    String trimmedValue = lorem.trimLeft();
    if (trimmedValue.indexOf(value) != 0) {
      setState(() {
        step = 2;
      });
    } else {
      typedCharLength = value.length;
    }
  }

  void resetGame() {
    setState(() {
      typedCharLength = 0;
      step = 0;
    });
  }

  void onStartClick() {
    setState(() {
      updateLastTypedAt();
      step++;
    });

    Timer.periodic(new Duration(seconds: 1), (timer) {
      int now = new DateTime.now().millisecondsSinceEpoch;

      // Game Over
      setState(() {
        if (step != 1) {
          timer.cancel();
        }
        if (step == 1 && now - lastTypedAt > 2000) {
          step++;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> shownWidget;
    if (step == 0) {
      shownWidget = <Widget>[
        Text('Merhaba'),
        Container(
          padding: const EdgeInsets.only(top: 10),
          child: RaisedButton(
            child: Text('basla'),
            onPressed: onStartClick,
          ),
        ),
      ];
    } else if (step == 1) {
      shownWidget = <Widget>[
        Text('$typedCharLength'),
        Container(
            height: 40,
            margin: const EdgeInsets.only(left: 100),
            child: Marquee(
              text: lorem,
              style: TextStyle(fontSize: 24),
              scrollAxis: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              blankSpace: 20.0,
              velocity: 75,
              pauseAfterRound: Duration(seconds: 9),
              startPadding: 0,
              accelerationDuration: Duration(seconds: 1),
              accelerationCurve: Curves.ease,
              decelerationDuration: Duration(milliseconds: 500),
              decelerationCurve: Curves.easeOut,
            )),
        Padding(
          padding: EdgeInsets.all(32),
          child: TextField(
            autofocus: true,
            onChanged: onType,
            obscureText: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Type',
            ),
          ),
        ),
      ];
    } else {
      shownWidget = <Widget>[
        Text('gg skorun $typedCharLength'),
        Container(
          padding: const EdgeInsets.only(top: 10),
          child: RaisedButton(
            child: Text('yeniden basla'),
            onPressed: resetGame,
          ),
        ),
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('İlk Proje Flutter'),
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: shownWidget)),
    );
  }
}
