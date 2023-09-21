import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_post_app/Search/search_job.dart';
import 'package:job_post_app/Widgets/bottom_nav_bar.dart';

import '../Persistent/persistent.dart';


class JobsScreen extends StatefulWidget {

  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? jobCategoryFilter;


  _showTaskCategoriesDialog({required Size size}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: const Text(
              'Job Category',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            content: Container(
              width: size.width * 0.12,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: Persistent.jobCategoryList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        jobCategoryFilter =
                        Persistent.jobCategoryList[index];
                      });
                      Navigator.canPop(context) ? Navigator.pop(context) : null;
                      print('jobCategoryList[index], ${ Persistent.jobCategoryList[index]}');
                    },
                    child:  Row(
                      children: [
                        const Icon(Icons.arrow_right_alt_outlined,
                          color: Colors.grey,),
                        Padding(padding: const EdgeInsets.all(5.0),
                          child: Text(
                            Persistent.jobCategoryList[index],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,

                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: const Text('Close',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                    ),)),
              TextButton(
                  onPressed: (){
                    setState(() {
                      jobCategoryFilter = null;
                    });
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: const Text('Cancel Filter',
                  style: TextStyle(color: Colors.white),))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepOrange.shade300,
            Colors.blueAccent
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.2, 0.9]
        )
      ),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 0),
        backgroundColor: Colors.transparent,
        appBar: AppBar(

          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepOrange.shade300, Colors.blueAccent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.2, 0.9]
              )
            ),

          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: (){
                _showTaskCategoriesDialog(size: size);
              },
              icon: const Icon(Icons.filter_list_rounded,color: Colors.black,)),

          actions: [
            IconButton(
                onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> SearchScreen()));
                },
                icon: const Icon(Icons.search_outlined,color: Colors.black,))
          ],
        ),

      ),
    );
  }
}
