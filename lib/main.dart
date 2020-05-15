import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String myText;
  StreamSubscription<DocumentSnapshot> subscription;

  final DocumentReference documentReference =
      Firestore.instance.collection("myData").document("dummy");

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<FirebaseUser> _signIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;

    final AuthCredential credential = await GoogleAuthProvider.getCredential(
        idToken: gSA.idToken, accessToken: gSA.accessToken);

    await _auth.signInWithCredential(credential);

    return await _auth.currentUser();
  }

  _signOut() async {
    if (_auth == null) {
      return;
    }

    await _auth.signOut();
  }

  void _add() {
    Map<String, String> data = <String, String>{
      "name": "Edafe",
      "desc": "Flutter Developer"
    };

    documentReference
        .setData(data)
        .then((value) => print("Result completed"))
        .catchError((e) => print("Error occured  $e"));
  }

  void _delete() {
    documentReference.delete();
  }

  void _update() {
    Map<String, String> data = <String, String>{
      "name": "Preciou",
      "desc": "Flutter Developer|Android"
    };

    documentReference
        .updateData(data)
        .then((value) => print("Update complete"))
        .catchError((e) => print("Error occured  $e"));
  }

  void _fetch() {
//    documentReference.snapshots().listen((event) {
//      if (event.exists) {
//        setState(() {
//          myText = event.data["desc"];
//        });
//      } else {
//        setState(() {
//          myText = null;
//        });
//      }
//    });
  }

  @override
  void initState() {
    super.initState();

    subscription = documentReference.snapshots().listen((event) {
      if (event.exists) {
        setState(() {
          myText = event.data["desc"];
        });
      } else {
        setState(() {
          myText = null;
        });
      }
    });

  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Auth"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: _signIn,
              child: Text("Sign In"),
              color: Colors.green,
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              onPressed: _signOut,
              child: Text("Sign Out"),
              color: Colors.red,
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              onPressed: _add,
              child: Text("Add"),
              color: Colors.cyan,
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              onPressed: _update,
              child: Text("Update"),
              color: Colors.lightBlue,
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              onPressed: _delete,
              child: Text("Delete"),
              color: Colors.orange,
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              onPressed: _fetch,
              child: Text("Fetch"),
              color: Colors.lime,
            ),
            myText == null
                ? Container()
                : Text(myText, style: TextStyle(fontSize: 20))
          ],
        ),
      ),
    );
  }
}
