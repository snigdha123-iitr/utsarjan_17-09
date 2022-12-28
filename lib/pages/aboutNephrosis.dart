// import 'package:flutter/material.dart';
// class AboutNephrosis extends StatefulWidget {
//   @override
//   _AboutNephrosisState createState() => _AboutNephrosisState();
// }

// class _AboutNephrosisState extends State<AboutNephrosis> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(children: <Widget>[
//         Container(
//           child: Text("data")),
//       ],)

//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:utsarjan/services/globalData.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutNephrosis extends StatefulWidget {
  @override
  _AboutNephrosisState createState() => _AboutNephrosisState();
}

class _AboutNephrosisState extends State<AboutNephrosis> {
  YoutubePlayerController _controller;
  bool _muted = false;
  bool _isPlayerReady = false;

  String videoId;

  @override
  void initState() {
    super.initState();
    //videoId = YoutubePlayer.convertUrlToId("https://youtu.be/aOnBdaisamw");
      videoId = YoutubePlayer.convertUrlToId("https://youtu.be/bbeOKPZyvxo");

    print("234567890-");
    print(videoId);
    if (this.mounted)
      setState(() {
        print(videoId);
      });

    //if (videoId == "" || videoId == null) videoId = videoId;
    print("ffffffffffff");
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        mute: false,
        hideThumbnail: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: true,
        //isLive: false,
      //  forceHideAnnotation: true,
      ),
    )..addListener(listener);
  }

  void listener() {
    print("ggggggggggggggggg");
    if (_isPlayerReady) {
      if (_controller.value.playerState == PlayerState.playing) {}
    }
  }

  @override
  void deactivate() {
    // This pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[200],
        //automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 1.0,
        title: SizedBox(
          height: 45.0,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){
                openBrowser(serverIP+"/public/Document/FAQs_NS_english_version_v2.html");
              },
              child: Text(AppLocalizations.of(context).faqsAboutNephroticEnglish,style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.red[200],
                  fontWeight: FontWeight.w500
              ),),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){
                openBrowser(serverIP+"/public/Document/FAQs_NS_hindi_version_v2.html");
              },
              child: Text(
                AppLocalizations.of(context).faqsAboutNephroticHindi,style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.red[200],
                  fontWeight: FontWeight.w500
              ),),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){
                //openBrowser("https://youtube.com/channel/UCAIsTaTlcN-obNmgtzS8HVA");
                openBrowser(serverIP+"/public/Document/About_the_disease_videos.html");
              },
              child: Text(
                AppLocalizations.of(context).utsarjanYouTube,style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.red[200],
                  fontWeight: FontWeight.w500
              ),),
            ),
          ),
          Visibility(
            visible: false,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  /*YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.blueAccent,
                    topActions: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        onPressed: () {},
                      ),
                      Expanded(
                        child: Text(
                          'Ustarjan App',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _muted ? Icons.volume_off : Icons.volume_up,
                          color: Colors.white,
                          size: 25,
                        ),
                        onPressed: _isPlayerReady
                            ? () {
                                _muted ? _controller.unMute() : _controller.mute();
                                setState(() {
                                  _muted = !_muted;
                                });
                              }
                            : null,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 25.0,
                        ),
                        onPressed: () {},
                      ),
                    ],
                    onReady: () {
                      _isPlayerReady = true;
                      //_controller.addListener(listener);
                    },
                    onEnded: (id) {},
                  ),*/
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        "Nephrotic Syndrome is a condition that causes the kidneys to leak large amounts of protein into the urine. This can lead to a range of problems, including swelling of body tissues and a greater chance of catching infections. Although Nephrotic Syndrome can affect people of any age, but it is usually first diagnosed in children aged between 2 and 5 years old. Around 1 in every 50,000 children are diagnosed with the condition every year.\n Nephrotic Syndrome can usually be diagnosed after dipping a dipstick into a urine sample. If there is large amount of proteins in a person’s urine, there will be a colour change on the stick. The results of a dipstick to test are recorded as either:"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            "Nil- [0mg of proteinuria per deciliter of urine (mg/dL)] - yellow"),
                        Text("Trace- (15 to 30mg/dL) - yellow"),
                        Text("1+- (30 to 100mg/dL) – light green"),
                        Text("2+- (100 to 300mg/dL)– light green"),
                        Text("3+- (300 to 1,000mg/dL) – dark green")
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        "If a dipstick shows 3+ or more of protein in a urine, this means the patient is having a relapse.\nPoor compliance to drugs is associated with poor outcomes and therefore we will be developing a smartphone application for monitoring and management of the diseases. We will be building the App on Flutter as it is a cross platform SDK (Software Development Kit) to build an interactive Apps for both Android and iOS platforms. The App will act as a doctor-patient interface to help the patient to record their health periodically. In addition, the development of this platform will lead to the collection of information about the different categories in patients. Subsequently, the patient data will be used to generate disease progress prediction model and prevent relapses using Machine Learning."),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        "SRNS- Children with Nephrotic Syndrome when do not respond to initial treatment with corticosteroids, a condition named Steroid-Resistance Nephrotic Syndrome\nSSNS- Steroid Sensitive Nephrotic Syndrome"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  openBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }else{
      print("not open");
    }
  }
}
