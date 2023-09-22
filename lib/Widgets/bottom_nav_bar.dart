import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_post_app/Jobs/jobs_screen.dart';
import 'package:job_post_app/Jobs/upload_job.dart';
import 'package:job_post_app/Search/profile_company.dart';
import 'package:job_post_app/Search/search_companies.dart';
import 'package:job_post_app/user_state.dart';

class BottomNavigationBarForApp extends StatelessWidget {
  BottomNavigationBarForApp({super.key, required this.indexNum});

  int indexNum = 0;

  void _logout(context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.logout, color: Colors.white, size: 36),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.white, fontSize: 28),
                  ),
                )
              ],
            ),
            content: const Text(
              'Do you want to Log Out?',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(color: Colors.green, fontSize: 18),
                  )),
              TextButton(
                  onPressed: () {
                    _auth.signOut();
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => UserState()));
                  },
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: Colors.green, fontSize: 18),
                  )),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return CurvedNavigationBar(
      color: Colors.deepOrange.shade400,
      backgroundColor: Colors.transparent,
      buttonBackgroundColor: Colors.deepOrange.shade300,
      height: height * 0.080,
      index: indexNum,
      animationCurve: Curves.bounceInOut,
      animationDuration: const Duration(milliseconds: 300),
      items: [
        Icon(
          Icons.list,
          size: width * 0.060,
          color: Colors.black,
        ),
        Icon(
          Icons.search,
          size: width * 0.060,
          color: Colors.black,
        ),
        Icon(
          Icons.add,
          size: width * 0.060,
          color: Colors.black,
        ),
        Icon(
          Icons.person_pin,
          size: width * 0.060,
          color: Colors.black,
        ),
        Icon(
          Icons.exit_to_app,
          size: width * 0.060,
          color: Colors.black,
        )
      ],
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => JobsScreen()));
        } else if (index == 1) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => AllWorkersScreen()));
        } else if (index == 2) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => UploadJobNow()));
        } else if (index == 3) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => ProfileScreen()));
        } else if (index == 4) {
          _logout(context);
        }
      },
    );
  }
}
