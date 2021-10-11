import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_in_background/components/custom_list_view.dart';
import 'package:flutter_music_in_background/model/Musics.dart';
import 'package:flutter_svg/svg.dart';

import 'DetailPage.dart';
import 'components/custom_list_view_2.dart';
import 'components/custom_list_view_3.dart';
import 'components/custom_list_view_4.dart';
import 'listing_page_cat.dart';
import 'listing_page_songs.dart';
import 'listing_page_songs_2.dart';

/*void main() {
  runApp(MusicPlayer_list());
}*/


class PageMain_Cat extends StatefulWidget {
  @override
  _PageMain_Cat createState() => _PageMain_Cat();
}

class _PageMain_Cat extends State<PageMain_Cat> {
  List musics;
  @override
  void initState() {
    musics = getList();
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

    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF000c24),
        appBar: AppBar(
          backgroundColor: const Color(0xFF000c24),
          title: Text(
            "Main Category",
            style: TextStyle(
                color: Colors.white70,
                fontStyle: FontStyle.italic,
                fontSize: 20.0),
          ),
        ),
        body: Container(
          child: Container(
            height: 250,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: getList().length,
                itemBuilder: (context, index) => customListView_4(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MusicPlayer_list() ),
                        );
                      },
                      title: musics[index].title,
                      singer: musics[index].singer,
                      image: musics[index].image,
                    )),
          ),
        ));
  }


}
