

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FullScreenImagePage extends StatelessWidget {
  final String imgPath;


  FullScreenImagePage(this.imgPath);


  final LinearGradient backgroundGradient =  LinearGradient(
    colors: [Color(0X10000000), Color(0X30000000)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(gradient: backgroundGradient),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Hero(
                  tag: imgPath,
                  child: Image.network(imgPath),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AppBar(
                      elevation: 0.0,
                      backgroundColor: Colors.transparent,
                      leading: IconButton(
                        icon: Icon(Icons.close, color: Colors.black,),
                        onPressed: ()=> Navigator.pop(context),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
