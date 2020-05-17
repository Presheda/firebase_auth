
import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextRecognition extends StatefulWidget {
  @override
  _TextRecognitionState createState() => _TextRecognitionState();
}

class _TextRecognitionState extends State<TextRecognition> {


  String text = "";
  File pickedImage;

  Future pickImage() async{
    var tempStore = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      pickedImage = tempStore;
    });

  }

  Future readText() async{


    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();

    VisionText readText = await recognizeText.processImage(ourImage);

    setState(() {
      text = readText.text;
    });


    for(TextBlock block in readText.blocks){
      for(TextLine line in block.lines){
        print(line.text);
//        for(TextElement word in line.elements){
//          print(word.text);
//        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text Recognition"),
      ),

      body: Column(
        children: <Widget>[
         pickedImage != null ? Center(
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:FileImage(pickedImage),
                  fit: BoxFit.cover
                )
              ),
            ),
          ) : Container(),

          SizedBox(
            height: 10.0,
          ),

          RaisedButton(
            child: Text("Pick an Image"),
            onPressed: pickImage,
          ),

          SizedBox(
            height: 10.0,
          ),
          RaisedButton(
            child: Text("Read Text"),
            onPressed: readText,
          ),
          SizedBox(
            height: 25.0,
          ),
          Text(text)

        ],
      ),
    );
  }
}
