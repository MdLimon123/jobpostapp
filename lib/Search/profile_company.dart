

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Widgets/bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {

  final String userID;

  const ProfileScreen({super.key, required this.userID});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? name;
  String email = '';
  String phoneNumber = '';
  String imageUrl = '';
  String joinedAt = '';
  bool _isLoading = false;
  bool _isSameUser = false;

  void getUserData()async{

    try{

      _isLoading = true;

      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
      .collection('users')
      .doc(widget.userID)
      .get();

      if(userDoc == null){
        return;
      }else{
        setState(() {
          
          name = userDoc.get('name');
          email = userDoc.get('email');
          phoneNumber = userDoc.get('phoneNumber');
          imageUrl = userDoc.get('userImage');
          Timestamp joinedAtTimeStamp = userDoc.get('createdAt');
          var joinedDate = joinedAtTimeStamp.toDate();
          joinedAt = '${joinedDate.year} - ${joinedDate.month} - ${joinedDate.day}';

        });

        User? user = _auth.currentUser;
        final _uid = user!.uid;
        setState(() {
          _isSameUser = _uid == widget.userID;
        });

      }

    }catch(error){

    }finally{
      _isLoading = false;
    }
  }

  @override
  void initState() {

    super.initState();

    getUserData();

  }


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
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
        backgroundColor: Colors.transparent,
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 3),
        body: _isLoading?const Center(child: CircularProgressIndicator(),)
        :SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Stack(
              children: [
                Card(
                  color: Colors.white10,
                  margin: const EdgeInsets.all(30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 100,),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            name == null?
                                'Name here'
                                : name!,
                            style: TextStyle(

                              fontSize: width * 0.045,
                              color: Colors.white
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.015,),
                        const Divider(
                          thickness: 1,
                          color: Colors.white,
                        ),
                        SizedBox(height: height * 0.030,),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('Account Information :',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: width * 0.045
                          ),),
                        )
                      ],
                    ),
                  ),

                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
