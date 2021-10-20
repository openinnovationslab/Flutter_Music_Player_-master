import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

import 'package:flutter_music_in_background/components/custom_list_view.dart';
import 'package:flutter_music_in_background/model/Musics.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import 'DetailPage.dart';
import 'components/custom_list_view_2.dart';
import 'components/custom_list_view_3.dart';
import 'listing_page_songs.dart';
import 'listing_page_songs_2.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';





import 'listing_page_songs_3.dart';




/*void main() {
  runApp(MusicPlayer_list());
}*/


class MusicPlayer_list extends StatefulWidget {
  String cat_name;
  final String testID='gems_test';
  MusicPlayer_list({this.cat_name} );

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer_list> {
  List<songlist> list_song = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    // prepare
    var result = await FlutterInappPurchase.initConnection;
    print('result: $result');
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    // refresh items for android
    String msg = await FlutterInappPurchase.consumeAllItems;
    print('consumeAllItems: $msg');

    await getdata();
  }


  Future<Null> _buySong(String songid) async {
    try {
      PurchasedItem purchased = await FlutterInappPurchase.buyProduct(songid);
      //PurchasedItem purchased = await FlutterInappPurchase.instance.requestPurchase(songid);
      print(purchased);
      String msg = await FlutterInappPurchase.consumeAllItems;
      print('consumeAllItems: $msg');
    } catch (error) {
      print('$error');
    }
  }


  Future<void> getdata() async
  {
    print("name"+widget.cat_name);
    setState(() {
      isLoading = true;
    });

    var response = await http.post(Uri.parse("http://15.206.220.241:83/api/GetCatSongs"),  body: {
      'GameName': widget.cat_name
    });
    var jsonData = jsonDecode(response.body);
    //print("list Response List----->" + response.body);

    if (response.statusCode == 200) {
      List JsonData = jsonData['songList'];

      JsonData.forEach((element)
      {
        setState(() {
          list_song.add(songlist(
              element["songId"],
              element["songName"],
              element["album"],
              element["albumImage"],
              element["songPath"],
          ));
          isLoading = false;
        } );

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
        list_song.clear();
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: const Color(0xFF03174C),
        appBar: AppBar(
          backgroundColor: const Color(0xFF000c24),
          title: new Text(
              "Song List",
              style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.normal,
                  fontSize: 20.0),
                  )),
        body: Container(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: isLoading
                ? Center(
                child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation(Colors.white),
                strokeWidth: 5,
                ),
              )
                : ListView.builder(
                itemCount: list_song.length,
                shrinkWrap: false,
                itemBuilder: (context, index) => customListView_3(
                      onTap: () {
                        _buySong(list_song[index].songId);
                        //_buyProduct(list_song[index].songId);

                        /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>

                               listing_page_songs_2(songName: list_song[index].songName, album:  list_song[index].album, songPath: list_song[index].songPath, albumImage: list_song[index].albumImage,cat_name:widget.cat_name,index_val: index,) ),
                              //listing_page_songs_3(songName: list_song[index].songName, album:  list_song[index].album, songPath: list_song[index].songPath, albumImage: list_song[index].albumImage,cat_name:widget.cat_name) ),


                        );*/

                      },
                      title: list_song[index].songName,
                      albumname: list_song[index].album,
                      image: "assets/rect.jpg",
                    )),
          ),
        ));
  }

}

class songlist {
  String songId;
  String songName;
  String album;
  String albumImage;
  String songPath;
  songlist(this.songId, this.songName, this.album, this.albumImage, this.songPath);

}

