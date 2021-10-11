import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_in_background/components/custom_list_view.dart';
import 'package:flutter_music_in_background/model/Musics.dart';
import 'package:flutter_svg/svg.dart';
import 'DetailPage.dart';

/*void main() {
  runApp(listing_page_songs());
}*/

/*class listing_page_songs extends StatefulWidget {
  // This widget is the root of your application.
  *//*@override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _listing_page_songs(),
    );
  }*//*

  @override
  _listing_page_songs createState() => _listing_page_songs();



}*/
//1.create class and design



class listing_page_songs extends StatefulWidget {
  @override
  _listing_page_songsState createState() => _listing_page_songsState();
}

class _listing_page_songsState extends State<listing_page_songs> {
  var str_title="",str_singer="", str_url="";
  IconData btnIcon = Icons.play_arrow;
  var bgColor=  const Color(0xFF03174C);
  var iconHoverColor = const Color(0xFF065BC3);

  Duration duration = new Duration();
  Duration position = new Duration();

  //9.Now add music player
  AudioPlayer audioPlayer = new AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  bool isPlaying = false;
  String currentSong = "";

  List musics;

  @override
  void initState() {
    musics = getList();

    setState(() {
      str_title = musics[0].title;
      str_singer = musics[0].singer;
      str_url = musics[0].url;
    });


    super.initState();
  }

  List getList() {
    return [
      Musics(
          title: "Uptown Funk",
          singer: "One Republic",
          url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
          image:
              "https://img.mensxp.com/media/content/2020/Apr/Leading-B-Wood-Singers-Who-Lost-On-Reality-Shows8_5ea7d4f04e41e.jpeg"),
      Musics(
        title: "Black Space",
        singer: "Sia",
        url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
        image:
            "https://img.mensxp.com/media/content/2020/Apr/Leading-B-Wood-Singers-Who-Lost-On-Reality-Shows10_5ea7d51d28f24.jpeg",
      ),
      Musics(
        title: "Shake it off",
        singer: "Coldplay",
        url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3",
        image:
            "https://img.mensxp.com/media/content/2020/Apr/Leading-B-Wood-Singers-Who-Lost-On-Reality-Shows2_5ea7d47403432.jpeg",
      ),
      Musics(
          title: "Lean On",
          singer: "T. Schürger",
          url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3",
          image:
              "https://i.pinimg.com/originals/ea/60/26/ea60268f4374e8840c4529ee1462fa38.jpg"),
      Musics(
          title: "Sugar",
          singer: "Adele",
          url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3",
          image:
              "https://img.mensxp.com/media/content/2020/Apr/Leading-B-Wood-Singers-Who-Lost-On-Reality-Shows7_5ea7d4db364a2.jpeg"),
      Musics(
          title: "Believer",
          singer: "Ed Sheeran",
          url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3",
          image:
              "https://img.mensxp.com/media/content/2020/Apr/Leading-B-Wood-Singers-Who-Lost-On-Reality-Shows6_5ea7d4c7225c1.jpeg"),
      Musics(
          title: "Stressed out",
          singer: "Mark Ronson",
          url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3",
          image:
              "https://i.pinimg.com/originals/7c/a1/08/7ca1080bde6228e9fb8460915d36efdd.jpg"),
      Musics(
          title: "Girls Like You",
          singer: "Maroon 5",
          url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3",
          image:
              "https://i.pinimg.com/originals/1b/b8/55/1bb8552249faa2f89ffa0d762d87088d.jpg"),
      Musics(
          title: "Let her go",
          singer: "Passenger",
          url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-9.mp3",
          image:
              "https://64.media.tumblr.com/5b7c0f14e4e50922ccc024573078db42/15bda826b481de6f-5a/s1280x1920/b26b182f789ef7bb7be15b037e2e687b0fbc437d.jpg"),
      Musics(
          title: "Roar",
          singer: "Katy Perry",
          url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-10.mp3",
          image:
              "https://cdn2.stylecraze.com/wp-content/uploads/2013/11/Jesus-On-Her-Wrist.jpg.webp"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF03174C),
        appBar: AppBar(
          backgroundColor: const Color(0xFF03174C),
          title: Text(
            "Songs List",
            style: TextStyle(
                color: Colors.white70,
                fontStyle: FontStyle.italic,
                fontSize: 20.0),
          ),
        ),
        body: Column(
           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            //divided into two parts
            //one which consists of list of songs

          Container(
            height: MediaQuery.of(context).size.height*0.34,
            //color: Colors.red,
            child: ListView.builder(
                itemCount: getList().length,
                itemBuilder: (context, index) => customListView(
                      onTap: () {
                        setState(() {
                          str_title = musics[index].title;
                          str_singer = musics[index].singer;
                          str_url = musics[index].url;
                        });

                        /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailPage(mMusic: musics[index])),
                        );*/

                      },

                      title: musics[index].title,
                      singer: musics[index].singer,
                      image: musics[index].image,
                    )),
          ),
          Container(
              //color: Colors.yellow,
              height: MediaQuery.of(context).size.height*0.5,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,20,0,10),
                    child: Container(

                      height: MediaQuery.of(context).size.height*0.1,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(/*widget.mMusic.image*/""),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [bgColor.withOpacity(0.4), bgColor],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                          Container(
                           height: 50,
                           child: Column(
                           children: [
                       /*  Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              *//*Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(50.0)),
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                  ),
                                ),*//*
                              *//*Column(
                                children: [
                                  Text(
                                    'PLAYLIST',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.6)),
                                  ),
                                  Text('Best Vibes of the Week',
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),*//*
                              *//*Icon(
                                  Icons.playlist_add,
                                  color: Colors.white,
                                )*//*
                            ],
                          ),*/

                          //Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(left: 0, top: 5, bottom: 0),
                            child: Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(/*widget.mMusic.title*/str_title,
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
                              /*widget.mMusic.singer*/str_singer,
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
                  Slider.adaptive(

                    //change value after 11 step, and add min and max
                    value: position.inSeconds.toDouble(),
                    min: 0.0,
                    max: duration.inSeconds.toDouble(),
                    onChanged: (value) {},
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.fast_rewind,
                        color: Colors.white54,
                        size: 42.0,
                      ),
                      SizedBox(width: 32.0),
                      Container(
                        decoration: BoxDecoration(
                            color: iconHoverColor,
                            borderRadius: BorderRadius.circular(50.0)),
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              onPressed: () {
                                //10.lets Build the Pause button
                                playMusic(/*widget.mMusic.url*/str_url);
                                if(isPlaying)
                                {
                                  audioPlayer.pause();
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
                                }
                              },
                              iconSize: 42.0,
                              icon: Icon(btnIcon),
                              color: Colors.white,
                            )
                        ),
                      ),
                      SizedBox(width: 32.0),
                      Icon(
                        Icons.fast_forward,
                        color: Colors.white54,
                        size: 42.0,
                      ),
                    ],
                  ),
                  Spacer(),
                  /* Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(
                    Icons.bookmark_border,
                    color: iconHoverColor,
                  ),
                  Icon(
                    Icons.shuffle,
                    color: iconHoverColor,
                  ),
                  Icon(
                    Icons.repeat,
                    color: iconHoverColor,
                  ),
                ],
              ),
              SizedBox(height: 58.0),*/
                ],
              )

          )

        ]));
  }

  void playMusic(String url) async {
    if (isPlaying && currentSong != url) {
      audioPlayer.pause();
      int result = await audioPlayer.play(url);
      if (result == 1) {
        setState(() {
          currentSong = url;
        });
      }
    } else if (!isPlaying) {
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
}
