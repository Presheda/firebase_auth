import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebaseauth/main.dart';
import 'package:firebaseauth/ml/ml_face.dart';
import 'package:firebaseauth/ml/ml_home.dart';
import 'package:firebaseauth/wall_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;


  HomeScreen({this.analytics, this.observer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Playlist"),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[



            RaisedButton(
              child: Text("Firebase Crud", style: TextStyle(color: Colors.white),),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (c)=> MyHomePage()
                ));
              },
              color: Colors.red,
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              child: Text("Firebase Mlkit", style: TextStyle(color: Colors.white),),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (c)=> MlHome()
                ));
              },
              color: Colors.blue,
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              child: Text("Wallfy", style: TextStyle(color: Colors.white),),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (c)=> WallScreen(analytics: analytics, observer: observer)
                ));
              },
              color: Colors.green,
            ),

          ],
        ),
      ),
    );
  }
}
