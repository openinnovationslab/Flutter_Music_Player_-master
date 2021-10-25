import 'package:flutter/material.dart';



Widget customListView_3({
  String title,
  String albumname,
  String image,
  bool is_Paid,
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
                  borderRadius: BorderRadius.all(Radius.circular(8.0))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              //color: Colors.pink,
                              child: Text(
                                title,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0
                                ),
                              ),
                            ),
                          ),
                        ),

                        Visibility(
                          visible: is_Paid == true ? true : false,
                          child: Expanded(
                            flex: 4,
                            child: Container(
                              //color: Colors.yellow,
                              child: Padding(
                                  padding: EdgeInsets.all(2.0),
                                child: Icon(Icons.lock ,
                                color: Colors.black,),
                              )
                            ),
                          ),
                        )
                      ],
                    ),
                  ),


                  Padding(
                    padding: const EdgeInsets.fromLTRB(7.0,0,0,0),
                    child: Text(
                      albumname,
                      style: TextStyle(
                          color: Colors.black12.withOpacity(0.5), fontSize: 14.0),
                    ),
                  ),


                ],
              )),
        ),


      ),
  );
}
