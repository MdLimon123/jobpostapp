

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:job_post_app/LoginPage/login_screen.dart';

import '../Services/global_veriables.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> with TickerProviderStateMixin{

  late Animation<double> _animation;
  late AnimationController _animationController;

  final TextEditingController _forgetPassController = TextEditingController(text: '');

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20));
    _animation =
    CurvedAnimation(parent: _animationController, curve: Curves.linear)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((animationStatus) {
        if (animationStatus == AnimationStatus.completed) {
          _animationController.reset();
          _animationController.forward();
        }
      });
    _animationController.forward();

    super.initState();
  }

  void _forgetPassSubmitForm()async{

    try{
      await _auth.sendPasswordResetEmail(email: _forgetPassController.text);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> LoginScreen()));
    }catch(error){
      Fluttertoast.showToast(msg: error.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(imageUrl: forgetUrlImage ,
          placeholder: (context, url)=> Image.asset(
            'assets/images/wallpaper.jpg',
            fit: BoxFit.fill,
          ),
            errorWidget: (context, url, error)=> const Icon(Icons.error),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
          ),

          Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.026),
            child: ListView(
              children: [
                SizedBox(
                  height: height * 0.1,
                ),

                Text('Forget Password',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.080,
                  fontFamily: "Signatra"
                ),),
                SizedBox(height: height * 0.016,),
                Text('Email Address',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.040,
                      fontStyle: FontStyle.italic
                  ),),
                SizedBox(height: height * 0.020,),
                TextField(
                  controller: _forgetPassController,

                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white54,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)
                    )
                  ),
                ),
                SizedBox(height: height * 0.030,),

                MaterialButton(
                  onPressed: (){

                    // Create ForgetPassSubmitForm
                    _forgetPassSubmitForm();

                  },
                  color: Colors.cyan,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(width * 0.016)
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: width * 0.014 ),
                    child:  Text('Reset now',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.045,
                      fontStyle: FontStyle.italic
                    ),),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
