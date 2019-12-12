import 'package:flutter/material.dart';


import 'example2.dart';

class Example extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Example"),
          actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Example2()));
            },
            child: Icon(Icons.arrow_forward, color: Colors.white),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
           Center(
             child:  Text("Example"),
           )
           
          ],
        )
      ),
    );
  }
}