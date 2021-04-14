import 'package:flutter/material.dart';


class Loguin extends StatefulWidget {
  @override
  _LoguinState createState() => _LoguinState();
}

class _LoguinState extends State<Loguin> {




  @override
  Widget build(BuildContext context) {
    double w = MediaQuery. of(context). size. width;
    double h = MediaQuery. of(context). size. height;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: h*0.08,
            width: w*1.0,
            color: Colors.black,
            child:Row(
              children: [
                Container(
                  color: Colors.white,
                  width: w*0.1,
                  height: h*0.05,
                  child: Center(
                    child: Text("Home",style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.w500,),),
                  ),
                ),
                Container(
                  color: Colors.white,
                  width: w*0.1,
                  height: h*0.05,
                  child: Center(
                    child: Text("Home",style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.w500,),),
                  ),
                ),
                Container(
                  color: Colors.white,
                  width: w*0.1,
                  height: h*0.05,
                  child: Center(
                    child: Text("Home",style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.w500,),),
                  ),
                ),
                Container(
                  color: Colors.white,
                  width: w*0.1,
                  height: h*0.05,
                  child: Center(
                    child: Text("Home",style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.w500,),),
                  ),
                ),
              ],
            )
          ),

        ],
      ),
    );
  }
}
