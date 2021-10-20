import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_in_background/components/custom_list_view.dart';
import 'package:flutter_music_in_background/model/Musics.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'DetailPage.dart';
import 'components/custom_list_view_2.dart';
import 'components/custom_list_view_3.dart';
import 'components/custom_list_view_4.dart';
import 'listing_page_cat.dart';
import 'listing_page_songs.dart';
import 'listing_page_songs_2.dart';
import 'package:http/http.dart' as http;

/*void main() {
  runApp(MusicPlayer_list());
}*/


class PageMain_Cat extends StatefulWidget {
  @override
  _PageMain_Cat createState() => _PageMain_Cat();
}

class _PageMain_Cat extends State<PageMain_Cat> {
  List<musiccat> musics = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getdata();

  }





  Future<void> getdata() async
  {
    setState(() {
      isLoading = true;
    });

    var response = await http.get(Uri.parse("http://15.206.220.241:83/api/GetCategoryList"));
    var jsonData = jsonDecode(response.body);
    print("list Response List----->" + response.body);

    if (response.statusCode == 200) {
      List Json_data = jsonData['categoryList'];
      var i = 1;
      Json_data.forEach((element)
      {
        print("id"+element["catId"]);

        var imgaeUrl ;
        if(i % 2 == 0)
        {
          imgaeUrl = "assets/ver_rect.jpg";
        }
        else{
          imgaeUrl = "assets/img_med.jpg";
        }

        setState(() {
            musics.add(musiccat(
                element["catId"],
                element["catName"],
                element["totalSong"],
                element["isActive"],
                imgaeUrl
                ));
            isLoading = false;
        } );
        i++;
      });
    }
    else{

      print(response.reasonPhrase);
      var msg = jsonData['msg'];

      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 15.0);

      setState(() {
        isLoading = false;
        Navigator.of(context).pop();
        musics.clear();
      });
      return false;
    }
 }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF000c24),
        appBar: AppBar(
          backgroundColor: const Color(0xFF000c24),
          title:  new Center(
              child: new Text(
                  "Category",
                  style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0),
                  textAlign: TextAlign.center))

        ),
        body: Container(
          height: 350,
          child: isLoading
              ? Center(
              child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation(Colors.white),
              strokeWidth: 5,
              //semanticsValue: "Loading...",
            ),
          )
              :ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: musics.length,
              itemBuilder: (context, index) => customListView_4(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MusicPlayer_list( cat_name: musics[index].catName ) ),
                      );
                    },
                    cat_id: musics[index].catId,
                    title: musics[index].catName,
                    total_song: musics[index].totalSong,
                    is_active:musics[index].isActive,
                    image_url:musics[index].image_url
                  )),
        ));
  }

}


class musiccat {
  String catId;
  String catName;
  String totalSong;
  String image_url;
  bool isActive;

  musiccat(this.catId, this.catName, this.totalSong, this.isActive, this.image_url);

}


