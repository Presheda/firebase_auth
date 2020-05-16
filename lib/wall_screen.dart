import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebaseauth/fullscreen_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

const String testDevice = "";
const String adMobID = "ca-app-pub-6325262826298881~9011838322";

class WallScreen extends StatefulWidget {
  @override
  _WallScreenState createState() => _WallScreenState();
}

class _WallScreenState extends State<WallScreen> {
  static final MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: <String>[],
    keywords: <String>["wallpapers", "walls", "amoled"],
  );

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;

  List<DocumentSnapshot> wallpapersList;
  final CollectionReference collectionReference =
      Firestore.instance.collection("wallpapers");
  StreamSubscription<QuerySnapshot> subscription;

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("Banner event : $event");
      },
    );
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("Banner event : $event");
      },
    );
  }

  @override
  void initState() {
    super.initState();

    FirebaseAdMob.instance.initialize(appId: adMobID);

    _bannerAd = createBannerAd()..load()..show();
   // _interstitialAd = createInterstitialAd();
    subscription = collectionReference.snapshots().listen((dataSnapShot) {
      setState(() {
        wallpapersList = dataSnapShot.documents;
      });
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Walify"),
        ),
        body: wallpapersList != null
            ? StaggeredGridView.countBuilder(
                padding: EdgeInsets.all(8.0),
                crossAxisCount: 4,
                itemCount: wallpapersList.length,
                itemBuilder: (context, i) {
                  String imgPath = wallpapersList[i].data["url"];

                  return Material(
                    elevation: 8.0,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: InkWell(
                      onTap: () {
                        createInterstitialAd()
                          ..load()
                          ..show();

                        Navigator.push(


                            context,
                            MaterialPageRoute(
                                builder: (c) => FullScreenImagePage(imgPath)));
                      },
                      child: Hero(
                        tag: imgPath,
                        child: FadeInImage(
                          placeholder: AssetImage("assets/wallfy.png"),
                          image: NetworkImage(imgPath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
                staggeredTileBuilder: (i) =>
                    StaggeredTile.count(2, i.isEven ? 2 : 3),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
