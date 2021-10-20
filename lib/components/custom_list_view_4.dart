import 'package:flutter/material.dart';

//4.Define seperate list widget and use it as template
Widget customListView_4({
  String title,
  String cat_id,
  String total_song,
  bool is_active,
  String image_url,

  onTap,
}) {
  return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          width: 150.0,
          child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(image_url),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 150, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          color: image_url.contains("img_med.jpg")?Colors.white: Color(int.parse("0xff6faff2")),
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )),
        ),
      ),
  );
}
