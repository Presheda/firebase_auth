import 'package:firebaseauth/ml/ml_text_recognition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebaseauth/ml/ml_face.dart';

class MlHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ml Home"),
      ),

      body: Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
             child: Text("Text Recognition"),
             onPressed: (){
               Navigator.push(context, MaterialPageRoute(
                   builder: (c)=> TextRecognition()
               ));
             },
             color: Colors.orange,
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              child: Text("Face Detection"),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (c)=> MLFace()
                ));
              },
              color: Colors.cyan,
            ),
          ],
        ),
      ),
    );
  }
}
