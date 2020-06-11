import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'feature.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool isAnimated = false;
  AudioCache ioPlayer = AudioCache();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildAnimatedCrossFade(),
              MaterialButton(
                color: Colors.green,
                onPressed: () {
                  ioPlayer.play("countdown.mp3");
                  setState(() {
                    isAnimated = true;
                  });
                  Timer(Duration(seconds: 4), () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => EvenOdd()));
                  });
                },
                child:
                    Text("Start Game", style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }

  AnimatedCrossFade buildAnimatedCrossFade() {
    return AnimatedCrossFade(
      crossFadeState:
          isAnimated ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      firstCurve: Curves.easeInOutCirc,
      secondCurve: Curves.easeInCirc,
      duration: Duration(seconds: 3),
      firstChild: _buildFirstChild(),
      secondChild: _buildSecondChild(),
    );
  }

  Text _buildSecondChild() {
    return Text.rich(TextSpan(
      text: "Lets  ",
      style: TextStyle(
          color: Colors.grey.shade700,
          fontWeight: FontWeight.bold,
          fontSize: 28),
      children: <TextSpan>[
        TextSpan(
          text: "Go...",
          style: TextStyle(
            color: Colors.redAccent,
          ),
        )
      ],
    ));
  }

  Text _buildFirstChild() {
    return Text.rich(TextSpan(
      text: "Simple ",
      style: TextStyle(
          color: Colors.grey.shade700,
          fontWeight: FontWeight.bold,
          fontSize: 28),
      children: <TextSpan>[
        TextSpan(
          text: "Game",
          style: TextStyle(
            color: Colors.redAccent,
          ),
        )
      ],
    ));
  }
}
