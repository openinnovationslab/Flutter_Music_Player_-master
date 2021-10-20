import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_in_background/components/custom_list_view.dart';
import 'package:flutter_music_in_background/model/Musics.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marquee/marquee.dart';
import 'DetailPage.dart';
import 'package:http/http.dart' as http;
import 'package:audio_manager/audio_manager.dart';

class listing_page_songs_3 extends StatefulWidget {
  String songName, album, songPath, albumImage, cat_name;
  /*int index_val;*/
  listing_page_songs_3({
    this.songName,
    this.album,
    this.songPath,
    this.albumImage,
    this.cat_name,
    /*this.index_val*/
  });

  @override
  _listing_page_songsState_3 createState() => _listing_page_songsState_3();
}

class _listing_page_songsState_3 extends State<listing_page_songs_3> with SingleTickerProviderStateMixin{
  var str_title = "",
      str_albumname = "",
      str_url = "",
      str_albumimagepath = "",
      str_tap = "";
  double val_pos;
  //IconData btnIcon = Icons.pause;
  //var bgColor=  const Color(0xFF03174C);
  var iconHoverColor = const Color(0xFF065BC3);

  //Duration duration = new Duration();
  //Duration position = new Duration();



  Duration position2 = AudioManager.instance.position;
  Duration duration2 = AudioManager.instance.duration;
  PlayMode playMode = AudioManager.instance.playMode;

  List<AudioInfo> _list;

  //val_pos = position.inSeconds.toDouble();

  //9.Now add music player
  //AudioPlayer audioPlayer = new AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  bool isPlaying = false;
  String currentSong = "";

  List<songlist> list_song = [];

  final list_2 = [];

  int tappedIndex;
  bool isLoading = false;

  int _selectedIndex = 0;

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  void initState() {
    super.initState();
    //print("val->"+widget.index_val.toString());

    tappedIndex = 0;

    setupAudio();
    //getdata();


    if (this.mounted) {
      setState(() {
        str_title = widget.songName;
        str_albumname = widget.album;
        str_url = widget.songPath;
        str_albumimagepath = widget.albumImage;
        //val_pos = position.inSeconds.toDouble();
      });
    }



    //playMusic(str_url);

    /* audioPlayer.onPlayerCompletion.listen((event) {
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

            */ /*if(isPlaying)
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
          }*/ /*
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

    });*/
  }

  Future<void> getdata() async {
    setState(() {
      isLoading = true;
    });

    var response = await http.post(
        Uri.parse("http://15.206.220.241:83/api/GetCatSongs"),
        body: {'GameName': widget.cat_name});

    var jsonData = jsonDecode(response.body);
    //print("list Response List----->" + response.body);

    if (response.statusCode == 200) {
      List JsonData = jsonData['songList'];

      JsonData.forEach((element) {
        setState(() {
          list_song.add(songlist(element["songId"], element["songName"],
              element["album"], element["albumImage"], element["songPath"]));
          isLoading = false;
        });
      });

      /*for(int i=0;i<list_song.length;i++)
      {
        print(list_song[i].songName);
      }*/

      _list.clear();
      AudioManager.instance.audioList.clear();

      for (int i = 0; i < list_song.length; i++) {
        _list.add(AudioInfo(list_song[i].songPath,
            title: list_song[i].songName,
            desc: list_song[i].album,
            coverUrl: list_song[i].albumImage));
      }

      AudioManager.instance.audioList = _list;
    } else {
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

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    AudioManager.instance.seekTo(newDuration);
  }

  /*void seekToSecond_2(int second) {
    Duration newDuration = Duration(seconds: second);
    position = newDuration;
    duration = newDuration;
    //audioPlayer.seek(newDuration);
    //position=0;
    //duration=0

  }*/

  @override
  void dispose() {
    AudioManager.instance.release();
    //_controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          print(
              'Backbutton pressed (device or appbar button), do whatever you want.');
          AudioManager.instance.release();
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
              child: Column(children: [
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
                    height: MediaQuery.of(context).size.height * 0.32,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.072,
                            child: Stack(
                              children: [
                                Container(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 0, top: 1, bottom: 0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                        padding: const EdgeInsets.only(
                                            left: 0, top: 2.5, bottom: 0),
                                        child: Text(
                                          /*widget.mMusic.singer*/ str_albumname,
                                          style: TextStyle(
                                              color:
                                              Colors.white.withOpacity(0.6),
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
                          padding: const EdgeInsets.only(
                              top: 0, left: 30, bottom: 0, right: 30),
                          child: Slider.adaptive(
                            //change value after 11 step, and add min and max
                            value: position2.inSeconds.toDouble(),
                            min: 0.0,
                            max: duration2.inSeconds.toDouble(),
                            onChanged: (double value) {
                              setState(() {
                                value = value;
                                seekToSecond(value.toInt());
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              /*Text(position.inMinutes.toString()+":" + position.inSeconds.toString()  ,
                          style: TextStyle(color: Colors.white)),*/
                              Text(
                                  position2.toString().split(".")[0].toString(),
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.5))),
                              /*Text(duration.inMinutes.toString()+":" + duration.inSeconds.toString(),
                          style: TextStyle(color: Colors.white))*/
                              Text(
                                  duration2.toString().split(".")[0].toString(),
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.5)))
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
                                icon: Icon(Icons.skip_previous),
                                color: Colors.white54,
                                onPressed: () {
                                  /* if(widget.index_val > 0)
                                  {
                                    widget.index_val = widget.index_val-1;
                                    print("index->rewind"+widget.index_val.toString());
                                    setState(() {
                                      str_title = list_song[widget.index_val].songName;
                                      str_albumname = list_song[widget.index_val].album;
                                      str_url = list_song[widget.index_val].songPath;
                                      str_albumimagepath= list_song[widget.index_val].albumImage;
                                  });



                                audioPlayer.stop();
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

                              }*/
                                  //AudioManager.instance.stop();

                                  //AudioManager.instance.stop();
                                  AudioManager.instance.previous();

                                  int indexVal = AudioManager.instance.curIndex;
                                  setState(() {
                                    str_title = list_song[indexVal].songName;
                                    str_albumname = list_song[indexVal].album;
                                    str_url = list_song[indexVal].songPath;
                                    str_albumimagepath =
                                        list_song[indexVal].albumImage;
                                    position2 = new Duration();
                                    AudioManager.instance.seekTo(position2);

                                    //print("str_title"+str_title);
                                  });
                                }),
                            SizedBox(width: 32.0),
                            Container(
                              decoration: BoxDecoration(
                                  color: iconHoverColor,
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                    onPressed: () async {
                                      AudioManager.instance.playOrPause();

                                      /*print("value=======>" +
                                          isPlaying.toString());
                                      if (isPlaying) {
                                        print("play");
                                        AudioManager.instance.toPause();
                                        //audioPlayer.pause();
                                        setState(() {
                                          btnIcon = Icons.play_arrow;
                                          isPlaying = false;
                                        });
                                      } else {
                                        print("pause");
                                        AudioManager.instance.toPlay();
                                        //audioPlayer.resume();
                                        setState(() {
                                          btnIcon = Icons.pause;
                                          isPlaying = true;
                                        });
                                      }*/
                                    },
                                    iconSize: 32.0,
                                    icon: Icon(AudioManager.instance.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,),
                                    color: Colors.white,
                                  )),
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
                                  /*if(widget.index_val < list_song.length)
                            {
                              widget.index_val = widget.index_val+1;

                              if(widget.index_val >= list_song.length)
                              {
                                // nothing do
                              }
                              else{
                                //do
                                print("index->forward->"+widget.index_val.toString());
                                setState(() {
                                  str_title = list_song[widget.index_val].songName;
                                  str_albumname = list_song[widget.index_val].album;
                                  str_url = list_song[widget.index_val].songPath;
                                  str_albumimagepath= list_song[widget.index_val].albumImage;
                                  //print("str_title"+str_title);
                                });


                                */ /*audioPlayer.stop();
                                setState(() {
                                  btnIcon = Icons.play_arrow;
                                  isPlaying = false;
                                  seekToSecond_2(0);
                                });


                                Future.delayed(Duration(milliseconds: 800), () {
                                  // Do something
                                  print("url=>"+str_url);
                                  playMusic_2(str_url);
                                });*/ /*
                              }

                            }*/

                                  //AudioManager.instance.stop();

                                  AudioManager.instance.next();

                                  int index_val =
                                      AudioManager.instance.curIndex;
                                  setState(() {
                                    str_title = list_song[index_val].songName;
                                    str_albumname = list_song[index_val].album;
                                    str_url = list_song[index_val].songPath;
                                    str_albumimagepath =
                                        list_song[index_val].albumImage;
                                    position2 = new Duration();
                                    AudioManager.instance.seekTo(position2);
                                    //print("str_title"+str_title);
                                  });
                                }),
                          ],
                        ),
                      ],
                    )),
                Container(
                  //color: Colors.red,
                  height: MediaQuery.of(context).size.height * 0.270,
                  child: isLoading
                      ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                      strokeWidth: 5,
                      //semanticsValue: "Loading...",
                    ),
                  )
                      : ListView.builder(
                      itemCount: list_song.length,
                      itemBuilder: (context, index) => customListView(
                        onTap: () {
                          setState(() {
                            str_title = list_song[index].songName;
                            str_albumname = list_song[index].album;
                            str_url = list_song[index].songPath;
                            str_albumimagepath =
                                list_song[index].albumImage;

                            AudioManager.instance.play(index: index);

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

                          /*audioPlayer.stop();
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
                          */
                        },
                        title: list_song[index].songName,
                        albumname: list_song[index].album,
                        image: list_song[index].albumImage,
                      )),
                ),
              ]),
            )));
  }

  /*void playMusic(String url) async {

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
*/

  void setupAudio() {
    _list = [];

    _list.add(AudioInfo(widget.songPath,
        title: widget.songName,
        desc: widget.album,
        coverUrl: widget.albumImage));

    AudioManager.instance.audioList = _list;
    AudioManager.instance.intercepter = true;
    AudioManager.instance.play(auto: true);

    AudioManager.instance.onEvents((events, args) {
      print("events" + events.toString());
      switch (events) {
        case AudioManagerEvents.start:
          position2 = AudioManager.instance.position;
          duration2 = AudioManager.instance.duration;

          print("start load data callback, curIndex is ${AudioManager.instance.curIndex}");

          if(this.mounted)
          {
            print("if");
            setState(() {
            });
          }
          else{
            print("else");
          }
          break;
        case AudioManagerEvents.ready:
          print("ready to play");
          position2 = AudioManager.instance.position;
          duration2 = AudioManager.instance.duration;
          setState(() {});
          break;
        case AudioManagerEvents.seekComplete:
          position2 = AudioManager.instance.position;
          setState(() {});
          /*setState(() {
            AudioManager.instance.next();

            str_title = list_song[AudioManager.instance.curIndex].songName;
            str_albumname = list_song[AudioManager.instance.curIndex].album;
            str_url = list_song[AudioManager.instance.curIndex].songPath;
            str_albumimagepath =
                list_song[AudioManager.instance.curIndex].albumImage;

            position2 = new Duration();
            AudioManager.instance.seekTo(position2);

            print("str_title==>" + str_title);
          });*/
          print("seek event is completed. position is [$args]/ms");
          break;
        case AudioManagerEvents.buffering:
          print("buffering $args");
          break;
        case AudioManagerEvents.playstatus:
          isPlaying = AudioManager.instance.isPlaying;

          break;
        case AudioManagerEvents.timeupdate:
          position2 = AudioManager.instance.position;
          setState(() {});
          /*setState(() {
            setState(() {
              isPlaying = true;
              btnIcon = Icons.pause;
            });
          });*/
          AudioManager.instance.updateLrc(args["position"].toString());
          break;
        case AudioManagerEvents.error:
          setState(() {});
          break;
        case AudioManagerEvents.ended:
          AudioManager.instance.next();
          break;
        case AudioManagerEvents.volumeChange:
          setState(() {});
          break;
        default:
          break;
      }
    });
  }
}

class songlist {
  String songId;
  String songName;
  String album;
  String albumImage;
  String songPath;
  //String tap;
  songlist(
      this.songId, this.songName, this.album, this.albumImage, this.songPath);
}
