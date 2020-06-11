import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';

import 'startScreen.dart';

class EvenOdd extends StatefulWidget {
  @override
  _EvenOddState createState() => _EvenOddState();
}

class _EvenOddState extends State<EvenOdd> {
  AudioCache audioCache = AudioCache();

  Map<String, bool> score = {};

  int maxnumber = 10;
  int seed = 0;

  int totalTime = 30;
  int settimer = 0;

  String result;
  bool isTimerActive = true;

  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      print(timer.tick);
      setState(() {
        isTimerActive = timer.isActive;
        settimer = timer.tick;
      });

      if (timer.tick == totalTime) {
        timer.cancel();
        setState(() {
          isTimerActive = timer.isActive;
        });
      }

      if (score.length == 10) {
        timer.cancel();
        setState(() {
          isTimerActive = timer.isActive;
        });
      }
    });
  }

  void showSnackBar(String message) {
    _key.currentState.showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(seconds: 1),
      backgroundColor: Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (score.length == maxnumber) audioCache.play('success.mp3');
    return Scaffold(
      key: _key,
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: SingleChildScrollView(
                  child: isTimerActive
                      // * 😉 Lists of dragable widgets
                      ? _buildCenter()
                      : Column(
                          children: [
                            Text(
                              score.length == 10 ? "Great" : "Try again",
                              style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                            MaterialButton(
                              color: Colors.red,
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => StartScreen()));
                              },
                              child: Text("Go Back",
                                  style: TextStyle(color: Colors.white)),
                            )
                          ],
                        )),
            ),
            _buildScoreStatus(size),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.all(8.0),
        child: buildRow(),
      ),
    );
  }

  Positioned _buildScoreStatus(Size size) {
    return Positioned(
      top: 0.0,
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        width: size.width,
        height: 50,
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text.rich(TextSpan(
              text: "Score: ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              children: <TextSpan>[
                TextSpan(
                  text: "${score.length.toString()}",
                  style: TextStyle(color: Colors.green),
                ),
                TextSpan(text: "/"),
                TextSpan(
                    text: "$maxnumber", style: TextStyle(color: Colors.red))
              ],
            )),
            Text("Timer: ${settimer.toString()}"),
          ],
        )),
      ),
    );
  }

  Row buildRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // * 😋
        _buildEven(),

        // * 😝
        _buildOdd(),
      ],
    );
  }

  DragTarget<int> _buildOdd() {
    return DragTarget(
      onAccept: (int value) {
        if (value % 2 != 0) {
          print("Odd" + score["$value"].toString());

          setState(() {
            score["$value"] = true;
          });
        } else {
          showSnackBar("Wrong Answer");
        }
      },
      builder: (BuildContext context, List<dynamic> acceptedData,
          List<dynamic> rejectedData) {
        return Container(
          width: 80,
          height: 80,
          child: CircleAvatar(
            backgroundColor: Colors.yellow,
            child: Text(
              "Odd",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  DragTarget<int> _buildEven() {
    return DragTarget(
      onAccept: (int value) {
        if (value % 2 == 0) {
          setState(() {
            score["$value"] = true;
          });
        } else {
          showSnackBar("Wrong Answer");
        }
      },
      builder: (BuildContext context, List<dynamic> acceptedData,
          List<dynamic> rejectedData) {
        return Container(
          width: 80,
          height: 80,
          child: CircleAvatar(
            backgroundColor: Colors.green,
            child: Text(
              "Even",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Container _buildCenter() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Wrap(
        children: List.generate(
          maxnumber,
          (index) => _buildDragable(index),
        )..shuffle(Random(seed)),
      ),
    );
  }

  Draggable<int> _buildDragable(int index) {
    return Draggable<int>(
      data: index,
      child: Container(
        padding: EdgeInsets.all(10),
        width: 80,
        height: 80,
        child: CircleAvatar(
          backgroundColor: Colors.white38,
          child: Text(score["$index"] == true ? "✔" : index.toString(),
              style: TextStyle(
                  color: Colors.black87, fontWeight: FontWeight.bold)),
        ),
      ),
      childWhenDragging: Container(
        padding: EdgeInsets.all(10),
        width: 80,
        height: 80,
        child: CircleAvatar(
          backgroundColor: Colors.white60,
        ),
      ),
      feedback: Container(
        padding: EdgeInsets.all(10),
        width: 80,
        height: 80,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Text(
            index.toString(),
            style:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
