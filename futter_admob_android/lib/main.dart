import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Admob Sample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Admob Sample'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;
  int _rewardPoints = 0;

  @override
  void initState() {
    super.initState();
    //initialize Firebase Admob
    FirebaseAdMob.instance.initialize(appId: "ca-app-pub-6338065160193589~6620147429"); //TODO: replace it with your own Admob App ID

    //initialize Banner Ad
    _bannerAd = BannerAd(
      adUnitId: BannerAd.testAdUnitId, //TODO: replace it with your own Admob Banner ID
      size: AdSize.banner,
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );
    _showBannerAd();
    _initRewardedVideoAdListener();
  }

  void _showBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.bottom);
  }

  void _showInterstitialAd() {
    //initialize Interstitial Ad
    _interstitialAd = InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId, //TODO: replace it with your own Admob Interstitial ID
      listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");
      },
    );

    _interstitialAd
      ..load()
      ..show();
  }

  void _showRewardedAd() {
    //RewardedVideoAdEvent must be loaded to show video ad thus we check and show it via listener
    //Tip: You chould show a loading spinner while waiting it to be loaded.
    RewardedVideoAd.instance.load(adUnitId: RewardedVideoAd.testAdUnitId); //TODO: replace it with your own Admob Rewarded ID
  }

  void _initRewardedVideoAdListener()
  {
    RewardedVideoAd.instance.listener = (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      print("RewardedVideoAd event is $event");
      if (event == RewardedVideoAdEvent.loaded)
        RewardedVideoAd.instance.show();
      else if (event == RewardedVideoAdEvent.rewarded) {
        setState(() {
          // Video ad should be finish to get the reward amount.
          _rewardPoints += rewardAmount;
        });
      }
    };
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                onPressed: () {
                  _showInterstitialAd();
                },
                child: Text("Show Interstitial Ad"),
              ),
              RaisedButton(
                onPressed: () {
                  _showRewardedAd();
                },
                child: Text("Show Rewarded Video Ad"),
              ),
              Text("REWARD POINTS: " + _rewardPoints.toString()),
            ],
          ),
        ));
  }
}
