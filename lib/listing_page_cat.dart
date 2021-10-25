import 'dart:async';
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
  MusicPlayer_list({this.cat_name} );
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer_list> {
  List<songlist> list_song = [];
  static const String iapId = 'android.test.purchased';
  List<IAPItem> _items = [];


  String songName, album, songPath, albumImage, cat_name;
  int index;

   StreamSubscription _purchaseUpdatedSubscription;
   StreamSubscription _purchaseErrorSubscription;
   StreamSubscription _conectionSubscription;


  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    // prepare
    var result = await FlutterInappPurchase.instance.initConnection;
    print('result: $result');
    if (!mounted) return;
    //String msg = await FlutterInappPurchase.instance.consumeAllItems;
    //print('consumeAllItems: $msg');

    try{
       _purchaseUpdatedSubscription = FlutterInappPurchase.purchaseUpdated.listen((productItem) {
         var purchaseStatus="";
         if(productItem.purchaseStateAndroid != null) {
            purchaseStatus = productItem.purchaseStateAndroid.toString();
         }

         else
           purchaseStatus="";

        if(purchaseStatus == "PurchaseState.purchased")
        {
          print("purchased");
          /*Fluttertoast.showToast(
             msg: "Item Purchased successfully",
             toastLength: Toast.LENGTH_SHORT,
             gravity: ToastGravity.BOTTOM,
             timeInSecForIosWeb: 1,
             backgroundColor: Colors.white,
             textColor: Colors.black,
             fontSize: 15.0);*/

          /*Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
             listing_page_songs_2(songName: this.songName, album:  this.album, songPath: this.songPath, albumImage: this.albumImage,cat_name:this.cat_name,index_val:this.index,)
         ) );*/

        }
        else{
          print("error");
        }
      });

      _purchaseErrorSubscription = FlutterInappPurchase.purchaseError.listen((purchaseError) {

        print('purchase-error11: $purchaseError');
        this.songName="";
        this.album="";
        this.songPath="";
        this.albumImage="";
        this.cat_name="";
        this.index=0;
      });

      _purchaseErrorSubscription = FlutterInappPurchase.purchaseError.listen((purchaseError) {
        print('purchase-error12: $purchaseError');
        this.songName="";
        this.album="";
        this.songPath="";
        this.albumImage="";
        this.cat_name="";
        this.index=0;


      });

    }
    catch(e)
    {
      print(e);
    }



    await getdata();
    await _getProduct();
  }


  Future<Null> _buySong(IAPItem item, String songName, String album, String songPath, String albumImage,  String cat_name, int index ) async
  {
    try {
      this.songName = songName;
      this.album = album;
      this.songPath = songPath;
      this.albumImage = albumImage;
      this.cat_name = cat_name;
      this.index = index;
      PurchasedItem purchased = await FlutterInappPurchase.instance.requestPurchase(item.productId.toString());
      print("item purchased=>"+purchased.toString());



      //String msg = await FlutterInappPurchase.instance.consumeAllItems;
      //print('consumeAllItems: $msg');
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
    print("list Response List----->" + response.body);
    print("list Response List----->");

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
              element["isPaid"],
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


  Future<Null> _getProduct() async {
    List<IAPItem> items = await FlutterInappPurchase.instance.getProducts([iapId]);
    for (var item in items) {
      print(item.toString());
      _items.add(item);
    }
    setState(() {
      _items = items;
    });
  }

  @override
  void dispose() async {
    super.dispose();
  /*  _purchaseUpdatedSubscription?.cancel();
    _purchaseUpdatedSubscription = null;
    _purchaseErrorSubscription?.cancel();
    _purchaseErrorSubscription = null;
    await FlutterInappPurchase.instance.endConnection;*/
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
                        list_song[index].is_Paid == true
                         ? _buySong( _items[0] , list_song[index].songName, list_song[index].album, list_song[index].songPath,list_song[index].albumImage,widget.cat_name,index)
                         :  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  listing_page_songs_2(songName: list_song[index].songName, album:  list_song[index].album, songPath: list_song[index].songPath, albumImage: list_song[index].albumImage,cat_name:widget.cat_name,index_val: index,) ),
                          //listing_page_songs_3(songName: list_song[index].songName, album:  list_song[index].album, songPath: list_song[index].songPath, albumImage: list_song[index].albumImage,cat_name:widget.cat_name) ),
                        );
                      },
                      title: list_song[index].songName,
                      albumname: list_song[index].album,
                      image: "assets/rect.jpg",
                      is_Paid: list_song[index].is_Paid ,

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
  bool is_Paid;
  songlist(this.songId, this.songName, this.album, this.albumImage, this.songPath, this.is_Paid);

}

