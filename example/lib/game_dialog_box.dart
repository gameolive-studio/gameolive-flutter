import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gameolive/GameOliveWindow.dart';
import 'package:gameolive/models/launchConfig.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constants.dart';

class GameDialogBox extends StatefulWidget {
  final LaunchConfig? gameLaunchConfig;

  const GameDialogBox({Key? key, this.gameLaunchConfig}) : super(key: key);

  @override
  _GameDialogBoxState createState() => _GameDialogBoxState();
}

class _GameDialogBoxState extends State<GameDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
            height: 200,
            // padding: EdgeInsets.only(left: Constants.padding,top: Constants.avatarRadius
            //     + Constants.padding, right: Constants.padding,bottom: Constants.padding
            // ),
            // margin: EdgeInsets.only(top: Constants.avatarRadius),
            // decoration: BoxDecoration(
            //     shape: BoxShape.rectangle,
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(Constants.padding),
            //     boxShadow: [
            //       BoxShadow(color: Colors.black,offset: Offset(0,10),
            //           blurRadius: 10
            //       ),
            //     ]
            // ),
            child: GameOliveWindow(
              gameLaunchConfig: widget.gameLaunchConfig,
            )
            // Column(
            //   mainAxisSize: MainAxisSize.min,
            //   children: <Widget>[
            //     Text(widget.title,style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
            //     SizedBox(height: 15,),
            //   GestureDetector(
            //       onTap: () async {
            //         var url = widget.descriptions;
            //         if (await canLaunch(url)){
            //           await launch(url);
            //         }
            //         else
            //           // can't launch url, there is some error
            //           throw "Could not launch $url";
            //       },
            //       child: Text("Click here to launch the game",style: TextStyle(fontSize: 18),)),
            //    // Text(widget.descriptions,style: TextStyle(fontSize: 14),textAlign: TextAlign.center,),
            //     SizedBox(height: 22,),
            //     Align(
            //       alignment: Alignment.bottomRight,
            //       child: FlatButton(
            //           onPressed: (){
            //             Navigator.of(context).pop();
            //           },
            //           child: Text(widget.text,style: TextStyle(fontSize: 18),)),
            //     ),
            //   ],
            // ),
            ),
        // Positioned(
        //   left: Constants.padding,
        //   right: Constants.padding,
        //   child: CircleAvatar(
        //     backgroundColor: Colors.transparent,
        //     radius: Constants.avatarRadius,
        //     child: ClipRRect(
        //         borderRadius: BorderRadius.all(Radius.circular(Constants.avatarRadius)),
        //         child: Image.asset("assets/model.jpeg")
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
