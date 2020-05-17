import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MLFace extends StatefulWidget {
  MLFace({Key key}) : super(key: key);

  @override
  _MLFaceState createState() => _MLFaceState();
}

class _MLFaceState extends State<MLFace> {
  File _imageFile;
  List<Face> _faces;

  void _getImageAndDetectFaces() async {
    final imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    final image = FirebaseVisionImage.fromFile(imageFile);
    final faceDetector = FirebaseVision.instance
        .faceDetector(FaceDetectorOptions(mode: FaceDetectorMode.accurate));

    List<Face> faces = await faceDetector.processImage(image);
    if (mounted) {
      setState(() {
        _imageFile = imageFile;
        _faces = faces;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ml Home"),
      ),
      body: _imageFile == null || _faces == null ? Center() :
      ImageAndFaces(imageFile: _imageFile, faces: _faces,),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_a_photo),
        onPressed: _getImageAndDetectFaces,
      ),
    );
  }

}

class ImageAndFaces extends StatelessWidget {

  final File imageFile;
  final List<Face> faces;


  ImageAndFaces({this.imageFile, this.faces});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          flex: 2,
          child: Container(
            constraints: BoxConstraints.expand(),
              child: Image.file(imageFile, fit: BoxFit.cover,)
          ),
        ),

        Flexible(
          flex: 1,
          child: ListView(
            children: faces.map((e) => FaceCoordinates(e)).toList(),
          ),
        )

      ],
    );
  }
}

class FaceCoordinates extends StatelessWidget {

  final Face face;
  FaceCoordinates(this.face);



  @override
  Widget build(BuildContext context) {

    final pos = face.boundingBox;
    return ListTile(
      title: Text("(${pos.top}, ${pos.left}), (${pos.bottom}, ${pos.right}"),
    );
  }
}


