import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_music_in_background/page_maincat.dart';

import 'listing_page_cat.dart';


class Splash extends StatefulWidget {

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    gotonext();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
        'assets/image_1.jpg',
        fit: BoxFit.fill,
      ),
    );
  }


  gotonext() async {
    setState(() {
      Timer(
          Duration(seconds: 2),
          () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      /*MusicPlayer_list()*/
                       PageMain_Cat() )));
    });
  }
}
