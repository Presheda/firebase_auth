import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseauth/fullscreen_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';



class WallScreen extends StatefulWidget {
  @override
  _WallScreenState createState() => _WallScreenState();
}

class _WallScreenState extends State<WallScreen> {
  List<DocumentSnapshot> wallpapersList;

  final CollectionReference collectionReference = Firestore.instance
      .collection("wallpapers");

  StreamSubscription<QuerySnapshot> subscription;


  @override
  void initState() {
    super.initState();
    subscription = collectionReference.snapshots().listen((dataSnapShot) {

      setState(() {
        wallpapersList = dataSnapShot.documents;
      });
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Walify"),
      ),
      body: wallpapersList != null ? StaggeredGridView.countBuilder(
        padding: EdgeInsets.all(8.0),
          crossAxisCount: 4,
          itemCount: wallpapersList.length,
          itemBuilder: (context, i){
          String imgPath = wallpapersList[i].data["url"];

          return Material(
            elevation: 8.0,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            child: InkWell(
              onTap: ()=> Navigator.push(context, MaterialPageRoute(
                builder: (c)=> FullScreenImagePage(imgPath)
              )),
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
          staggeredTileBuilder: (i)=> StaggeredTile.count(2, i.isEven?2:3),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ) : Center(
        child: CircularProgressIndicator(),
      )
    );
  }
}
