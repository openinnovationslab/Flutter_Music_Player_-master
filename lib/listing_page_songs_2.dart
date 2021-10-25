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
import 'package:marquee/marquee.dart';
import 'DetailPage.dart';
import 'package:http/http.dart' as http;



class listing_page_songs_2 extends StatefulWidget {
  String songName, album, songPath, albumImage, cat_name;
  int index_val;
  listing_page_songs_2({this.songName, this.album, this.songPath, this.albumImage, this.cat_name, this.index_val});

  @override
  _listing_page_songsState_2 createState() => _listing_page_songsState_2();
}

class _listing_page_songsState_2 extends State<listing_page_songs_2>
{

  static const String iapId = 'android.test.purchased';
  List<IAPItem> _items = [];

  StreamSubscription _purchaseUpdatedSubscription;
  StreamSubscription _purchaseErrorSubscription;
  StreamSubscription _conectionSubscription;

  String songName, album, songPath, albumImage, cat_name;
  int index;


  var str_title="",str_albumname="", str_url="", str_albumimagepath="", str_tap="";
  double val_pos;
  IconData btnIcon = Icons.play_arrow;
  //var bgColor=  const Color(0xFF03174C);
  var iconHoverColor = const Color(0xFF065BC3);

  Duration duration = new Duration();
  Duration position = new Duration();



  //9.Now add music player
  AudioPlayer audioPlayer = new AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  bool isPlaying = false;
  String currentSong = "";

  List<songlist> list_song = [];
  int tappedIndex;
  bool isLoading = false;


  @override
  void initState() {
    super.initState();
    //audioPlayer.stop();
    //print("val->"+widget.index_val.toString());
    initPlatformState();
    //getdata();
    setState(() {
      str_title = widget.songName;
      str_albumname = widget.album;
      str_url = widget.songPath;
      str_albumimagepath = widget.albumImage;
      //val_pos = position.inSeconds.toDouble();
    });

    playMusic(str_url);

    audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        position = duration;
      });
      if(position.inSeconds==duration.inSeconds && position.inMinutes==duration.inMinutes)
      {
        print("Condition true, next song play");
        //Just for test
        if(widget.index_val < list_song.length)
        {
          print("index->complete"+widget.index_val.toString());
          widget.index_val = widget.index_val+1;
          if(widget.index_val >= list_song.length)
          {
            // nothing do
          }
          else{
             // do work
            String url;
            setState(() {
              str_title = list_song[widget.index_val].songName;
              str_albumname = list_song[widget.index_val].album;
              str_url = list_song[widget.index_val].songPath;
              str_albumimagepath= list_song[widget.index_val].albumImage;
            });

            /*if(isPlaying)
          {
            audioPlayer.stop();
            setState(() {
              btnIcon = Icons.play_arrow;
              isPlaying = false;
            });
          }else{
            audioPlayer.resume();
            setState(() {
              btnIcon = Icons.pause;
              isPlaying = true;
            });
          }*/
            audioPlayer.stop();
            setState(() {
              btnIcon = Icons.play_arrow;
              isPlaying = false;
              seekToSecond(0);
            });


            Future.delayed(Duration(milliseconds: 800), () {
              // Do something
              print("url=>"+str_url);
              playMusic(str_url);
            });

          }
        }
      }
    });

  }

  Future<void> initPlatformState() async {
    // prepare
    var result = await FlutterInappPurchase.instance.initConnection;
    //print('result: $result');


    if (!mounted) return;


    _purchaseUpdatedSubscription = FlutterInappPurchase.purchaseUpdated.listen((productItem) {
      var purchaseStatus = productItem.purchaseStateAndroid.toString();
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

       /* setState(() {
          str_title = this.songName;
          str_albumname = this.album;
          str_url = this.songPath;
          str_albumimagepath= this.albumImage;
          widget.index_val = this.index;
        });

        audioPlayer.stop();
        setState(() {
          btnIcon = Icons.play_arrow;
          isPlaying = false;
          seekToSecond_2(0);
        });

        Future.delayed(Duration(milliseconds: 800), () {
          // Do something
          playMusic_2(str_url);
        });*/
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


    await getdata();
    await _getProduct();

  }

  Future<Null> _buySong(IAPItem item, String songName, String album, String songPath, String albumImage,  String cat_name, int index) async
  {
    try {
      this.songName = songName;
      this.album = album;
      this.songPath = songPath;
      this.albumImage = albumImage;
      this.cat_name = cat_name;
      this.index = index;
      PurchasedItem purchased = await FlutterInappPurchase.instance.requestPurchase(item.productId.toString());
      //print("item purchased=>"+purchased.toString());
    } catch (error) {
      print('$error');
    }
  }

  Future<void> getdata() async
  {
    setState(() {
      isLoading = true;
    });

    var response = await http.post(Uri.parse("http://15.206.220.241:83/api/GetCatSongs"),  body: {
      'GameName': widget.cat_name
    });

    var jsonData = jsonDecode(response.body);
    print("list Response List----->" + response.body);

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

      /*for(int i=0;i<list_song.length;i++)
      {
        print(list_song[i].songName);
      }*/

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
    //print("url==>"+musics[0].image_url);
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

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    audioPlayer.seek(newDuration);

  }

  void seekToSecond_2(int second) {
    Duration newDuration = Duration(seconds: second);
    position = newDuration;
    duration = newDuration;
    audioPlayer.seek(newDuration);
    //position=0;
    //duration=0

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
      //print('Backbutton pressed (device or appbar button), do whatever you want.');
      //audioPlayer.stop();

      //trigger leaving and use own data
      Navigator.pop(context, false);

      //we need to return a future
      return Future.value(false);
    },


    child: Scaffold(
        //backgroundColor: const Color(0xFF03174C),
        appBar: AppBar(
          backgroundColor: const Color(0xFF000c24),
          title: Text(
            "Song",
            style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontSize: 20.0),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/image.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
              children: [
            Container(
                  //color: Colors.red,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 150.0,
                          width: 120.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                str_albumimagepath,
                              ),
                              fit: BoxFit.fill,
                            ),
                            shape: BoxShape.rectangle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

            Container(
                //color: Colors.yellow,
                height: MediaQuery.of(context).size.height*0.32,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,10,0,10),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.072,
                        child: Stack(
                          children: [
                            Container(
                             child: Column(
                             children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 0, top: 1, bottom: 0),
                              child: Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                 Text(str_title,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0)),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 0, top: 2.5, bottom: 0),
                              child: Text(
                                /*widget.mMusic.singer*/str_albumname,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 18.0),
                              ),
                            ),
                          ],
                        ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only( top: 0, left: 30, bottom: 0, right: 30),
                      child: Slider.adaptive(
                        //change value after 11 step, and add min and max
                        value: position.inSeconds.toDouble(),
                        min: 0.0,
                        max: duration.inSeconds.toDouble(),
                        onChanged: (double value) {
                           setState(() {
                             value = value;
                             seekToSecond(value.toInt());
                           });
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0,0,20,0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          /*Text(position.inMinutes.toString()+":" + position.inSeconds.toString()  ,
                          style: TextStyle(color: Colors.white)),*/
                          Text(position.toString().split(".")[0].toString()  ,
                          style: TextStyle(color: Colors.white.withOpacity(0.5))),
                          /*Text(duration.inMinutes.toString()+":" + duration.inSeconds.toString(),
                          style: TextStyle(color: Colors.white))*/
                          Text(duration.toString().split(".")[0].toString(),
                              style: TextStyle(color: Colors.white.withOpacity(0.5)))

                        ],
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          /*Icons.fast_forward,
                          color: Colors.white54,
                          size: 30.0,*/
                            iconSize: 30.0,
                            icon: Icon(Icons.fast_rewind),
                            color: Colors.white54,
                            onPressed: () {
                              if(widget.index_val > 0)
                              {
                                widget.index_val = widget.index_val-1;
                                //audioPlayer.stop();

                                if(widget.index_val != 1)
                                {
                                  //print("index->rewind"+widget.index_val.toString());
                                  /*list_song[ widget.index_val].is_Paid == true
                                ?_buySong( _items[0] , list_song[widget.index_val].songName, list_song[widget.index_val].album, list_song[widget.index_val].songPath,list_song[widget.index_val].albumImage,widget.cat_name,widget.index_val)
                                :*/ setState(() {
                                  str_title = list_song[widget.index_val].songName;
                                  str_albumname = list_song[widget.index_val].album;
                                  str_url = list_song[widget.index_val].songPath;
                                  str_albumimagepath= list_song[widget.index_val].albumImage;
                                });

                                setState(() {
                                  btnIcon = Icons.play_arrow;
                                  isPlaying = false;
                                  seekToSecond_2(0);
                                });

                                Future.delayed(Duration(milliseconds: 500), () {
                                  // Do something
                                  print("url=>"+str_url);
                                  playMusic_2(str_url);
                                });
                                }


                              }
                            }
                        ),
                        SizedBox(width: 32.0),
                        Container(
                          decoration: BoxDecoration(
                              color: iconHoverColor,
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                onPressed: () {
                                  //10.lets Build the Pause button

                                  if(isPlaying)
                                  {
                                    print("hi");
                                    audioPlayer.pause();
                                    setState(() {
                                      btnIcon = Icons.play_arrow;
                                      isPlaying = false;
                                    });
                                  }
                                  else{
                                    print("hi2");
                                    audioPlayer.resume();
                                    setState(() {
                                      btnIcon = Icons.pause;
                                      isPlaying = true;
                                    });

                                    //playMusic(str_url);
                                  }
                                },

                                iconSize: 32.0,
                                icon: Icon(btnIcon),
                                color: Colors.white,
                              )
                          ),
                        ),
                        SizedBox(width: 32.0),
                        IconButton(
                          /*Icons.fast_forward,
                          color: Colors.white54,
                          size: 30.0,*/
                          iconSize: 30.0,
                          icon: Icon(Icons.fast_forward),
                          color: Colors.white54,
                          onPressed: () {

                            if(widget.index_val < list_song.length)
                            {
                              widget.index_val = widget.index_val+1;
                              if(widget.index_val != 1)
                              {
                                if(widget.index_val >= list_song.length)
                                {
                                  // nothing do in this code
                                }
                                else{
                                  print("index->forward->"+widget.index_val.toString());
                                  audioPlayer.stop();

                                  /*list_song[widget.index_val].is_Paid == true
                                 ? _buySong( _items[0] , list_song[widget.index_val].songName, list_song[widget.index_val].album, list_song[widget.index_val].songPath,list_song[widget.index_val].albumImage,widget.cat_name,widget.index_val)
                                 :*/ setState(() {
                                    str_title = list_song[widget.index_val].songName;
                                    str_albumname = list_song[widget.index_val].album;
                                    str_url = list_song[widget.index_val].songPath;
                                    str_albumimagepath= list_song[widget.index_val].albumImage;
                                    //print("str_title"+str_title);
                                  });


                                  setState(() {
                                    btnIcon = Icons.play_arrow;
                                    isPlaying = false;
                                    seekToSecond_2(0);
                                  });

                                  Future.delayed(Duration(milliseconds: 800), () {
                                    // Do something
                                    //print("url=>"+str_url);
                                    playMusic_2(str_url);
                                  });
                                }
                              }
                            }
                          }
                        )
                       ,
                      ],
                    ),
                  ],
                )

            ),

            Container(
                  //color: Colors.red,
                  height: MediaQuery.of(context).size.height*0.270,
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
                      itemCount: list_song.length,
                      itemBuilder: (context, index) => customListView(
                        onTap: () {
                          list_song[index].is_Paid == true
                              ? _buySong( _items[0],  list_song[index].songName, list_song[index].album, list_song[index].songPath,list_song[index].albumImage,widget.cat_name,index)

                            :setState(() {
                            str_title = list_song[index].songName;
                            str_albumname = list_song[index].album;
                            str_url = list_song[index].songPath;
                            str_albumimagepath= list_song[index].albumImage;
                            //tappedIndex=index;
                            widget.index_val = index;
                            /*for(int i = 0; i<list_song.length; i++)
                            {
                              print("index=>"+index.toString());
                              print("i==>"+i.toString());

                              if(i == index)
                              {
                                list_song[index].tap = "1";
                              }
                              else{
                                list_song[index].tap = "0";
                              }

                            }*/
                          });
                          audioPlayer.stop();
                          setState(() {
                            btnIcon = Icons.play_arrow;
                            isPlaying = false;
                            seekToSecond_2(0);
                          });

                          Future.delayed(Duration(milliseconds: 800), () {
                            // Do something
                            print("url=>"+str_url);
                            playMusic_2(str_url);
                          });


                        },
                        title: list_song[index].songName,
                        albumname: list_song[index].album,
                        image: list_song[index].albumImage,
                        is_Paid: list_song[index].is_Paid,
                      )),
                ),
          ]),
        )));
  }

  void playMusic(String url) async {

    if (isPlaying && currentSong != url)
    {
      print("==>"+"in if");
      audioPlayer.pause();
      int result = await audioPlayer.play(url);
      if (result == 1) {
        setState(() {
          currentSong = url;
        });
      }
    }
    else if (!isPlaying) {
      print("==>"+"in else");
      print("=>"+url);
      int result = await audioPlayer.play(url);
      if (result == 1) {
        setState(() {
          isPlaying = true;
          btnIcon = Icons.pause;
          //from now we hear song
        });
      }
    }

    //11
    audioPlayer.onDurationChanged.listen((event) {
      if(mounted)
        {
          setState(() {
            duration = event;
          });
        }

    });

    audioPlayer.onAudioPositionChanged.listen((event) {
      if(mounted)
      {
        setState(() {
          position = event;
        });
      }

    });
  }

  void playMusic_2(String url) async {
    if (isPlaying && currentSong != url)
    {
      audioPlayer.pause();
      int result = await audioPlayer.play(url);
      if (result == 1) {
        setState(() {
          currentSong = url;
        });
      }
    }
    else if (!isPlaying) {
      int result = await audioPlayer.play(url);
      if (result == 1) {
        setState(() {
          isPlaying = true;
          btnIcon = Icons.pause;
          //from now we hear song
        });
      }
    }
    //11
    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });

    audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });







  }


  @override
  void dispose() async {
    super.dispose();
    /*_purchaseUpdatedSubscription?.cancel();
    _purchaseUpdatedSubscription = null;
    _purchaseErrorSubscription?.cancel();
    _purchaseErrorSubscription = null;
    await FlutterInappPurchase.instance.endConnection;*/
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

