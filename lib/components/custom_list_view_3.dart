import 'package:flutter/material.dart';

//4.Define seperate list widget and use it as template
Widget customListView_3({
  String title,
  String albumname,
  String image,
  onTap,
}) {
  return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          height: 70.0,
          color: Colors.transparent,
          child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))
              ),
              child: new Center(
                child:  Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            title,
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.normal,
                                fontSize: 20.0
                            ),
                          ),
                        ),
                        SizedBox(height: 1.0),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(7.0,0,0,0),
                          child: Text(
                            albumname,
                            style: TextStyle(
                                color: Colors.black12.withOpacity(0.5), fontSize: 14.0),
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
