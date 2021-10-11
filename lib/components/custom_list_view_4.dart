import 'package:flutter/material.dart';

//4.Define seperate list widget and use it as template
Widget customListView_4({
  String title,
  String singer,
  String image,
  onTap,
}) {
  return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          width: 150.0,

          color: Colors.transparent,
          child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/ver_rect.jpg"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))
              ),
              child: new Center(
                child:  Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            title,
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.normal,
                                fontSize: 20.0
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    /*Spacer(),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.black87.withOpacity(0.6),
                      size: 32.0,
                    )*/
                  ],
                ),

              )),
        ),


      ),
  );
}
