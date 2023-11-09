import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_post_app/user_state.dart';

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

  void getUserData() async {
    try {
      _isLoading = true;

      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userID)
          .get();

      if (userDoc == null) {
        return;
      } else {
        setState(() {
          name = userDoc.get('name');
          email = userDoc.get('email');
          phoneNumber = userDoc.get('phoneNumber');
          imageUrl = userDoc.get('userImage');
          Timestamp joinedAtTimeStamp = userDoc.get('createdAt');
          var joinedDate = joinedAtTimeStamp.toDate();
          joinedAt =
              '${joinedDate.year} - ${joinedDate.month} - ${joinedDate.day}';
        });

        User? user = _auth.currentUser;
        final _uid = user!.uid;
        setState(() {
          _isSameUser = _uid == widget.userID;
        });
      }
    } catch (error) {
    } finally {
      _isLoading = false;
    }
  }

  @override
  void initState() {
    super.initState();

    getUserData();
  }

  Widget userInfo({required IconData icon, required String content}) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            content,
            style: const TextStyle(color: Colors.white54),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.deepOrange.shade300, Colors.blueAccent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.2, 0.9])),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          bottomNavigationBar: BottomNavigationBarForApp(indexNum: 3),
          body: Center(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Stack(
                        children: [
                          Card(
                            color: Colors.white10,
                            margin: const EdgeInsets.all(30),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 150,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      name == null ? 'Name here' : name!,
                                      style: TextStyle(
                                          fontSize: width * 0.045,
                                          color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.015,
                                  ),
                                  const Divider(
                                    thickness: 1,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    height: height * 0.030,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'Account Information :',
                                      style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: width * 0.045),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.015,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: width * 0.010),
                                    child: userInfo(
                                        icon: Icons.email, content: email),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: width * 0.010),
                                    child: userInfo(
                                        icon: Icons.phone,
                                        content: phoneNumber),
                                  ),
                                  SizedBox(
                                    height: height * 0.030,
                                  ),
                                  const Divider(
                                    thickness: 1,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    height: height * 0.025,
                                  ),
                                  !_isSameUser
                                      ? Container()
                                      : Center(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                bottom: width * 0.030),
                                            child: MaterialButton(
                                              onPressed: () {
                                                _auth.signOut();
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            UserState()));
                                              },
                                              color: Colors.black,
                                              elevation: 8,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          width * 0.013)),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: height * 0.014),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Logout',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              height * 0.040,
                                                          fontFamily:
                                                              'Signatra'),
                                                    ),
                                                    SizedBox(
                                                      width: width * 0.04,
                                                    ),
                                                    const Icon(
                                                      Icons.logout,
                                                      color: Colors.white,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: size.width * 0.26,
                                height: size.height * 0.26,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 8,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor),
                                    image: DecorationImage(

                                        // ignore: prefer_if_null_operators
                                        image: NetworkImage(imageUrl == null
                                            ? 'data:image/png;base64,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'
                                            : imageUrl),
                                        fit: BoxFit.fill)),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
          )),
    );
  }
}
