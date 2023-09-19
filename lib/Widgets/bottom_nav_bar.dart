import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:job_post_app/Jobs/jobs_screen.dart';
import 'package:job_post_app/Search/search_companies.dart';

class BottomNavigationBarForApp extends StatelessWidget {

  BottomNavigationBarForApp({required this.indexNum});

 int indexNum = 0;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return CurvedNavigationBar(
      color: Colors.deepOrange.shade400,
      backgroundColor: Colors.blueAccent,
      buttonBackgroundColor: Colors.deepOrange.shade300,
      height: height * 0.080,
      index: indexNum,
        animationCurve: Curves.bounceInOut,
        animationDuration: const Duration(
          milliseconds: 300
        ),
        items:[
          Icon(Icons.list, size: width * 0.060, color: Colors.black,),
          Icon(Icons.search, size: width * 0.060, color: Colors.black,)
        ] ,
      onTap: (index){
        if(index == 0){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> JobsScreen()));
        }else if(index ==1){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> AllWorkersScreen()));
        }
      },
    );
  }
}
