import 'package:flutter/material.dart';

//4.Define seperate list widget and use it as template
Widget customListView({
  String title,
  String albumname,
  String image,
  String tap,
  onTap,
}) {
  return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(8.0,8,8.0,8.0),
        child: Row(
          children: [
            /*Stack(children: [
              Container(
                height: 80.0,
                width: 80.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: 80.0,
                width: 80.0,
                child: Icon(
                  Icons.play_circle_filled,
                  color: Colors.white.withOpacity(0.7),
                  size: 42.0,
                ),
              )
            ]),*/
            //SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 13.0
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  albumname,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.5), fontSize: 12.0),
                ),
              ],
            ),
            Spacer(),
            /*Icon(
              tap == "0" ? Icons.play_arrow : Icons.bar_chart_sharp,
              color: Colors.white.withOpacity(0.6),
              size: 16.0,
            )*/
          ],
        ),
      ),


  );
}
