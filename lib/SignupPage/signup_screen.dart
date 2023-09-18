// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_post_app/Services/global_veriables.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with TickerProviderStateMixin{

  late Animation<double> _animation;
  late AnimationController _animationController;
  File? imageFile;

  final TextEditingController _emailTextController =
  TextEditingController(text: '');
  final TextEditingController _passwordTextController =
  TextEditingController(text: '');
 final TextEditingController _fullNameController = TextEditingController(text: '');
 final TextEditingController _phoneNumberController = TextEditingController(text: '');
  final TextEditingController _locationController = TextEditingController(text: '');

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _positionCPFocusNode = FocusNode();

  bool _obscureText = true;

  final _signUpFormKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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

  void _showImageDialog(){

    showDialog(
      context: context,
      builder:(context){
        return AlertDialog(
          title: const Text('Please choose an option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: (){
                  // create getFromCamera
                  _getFromCamera();

                },
                child: const Row(
                  children: [
                    Padding(padding: EdgeInsets.all(4.0),
                      child: Icon(Icons.camera,
                      color: Colors.purple,),
                    ),
                    Text('Camera',
                    style: TextStyle(color: Colors.purple),)
                  ],
                ),
              ),
              InkWell(
                onTap: (){
                  // create getFormGallery
                  _getFromGallery();
                },
                child: const Row(
                  children: [
                    Padding(padding: EdgeInsets.all(4.0),
                      child: Icon(Icons.image,
                        color: Colors.purple,),
                    ),
                    Text('Gallery',
                      style: TextStyle(color: Colors.purple),)
                  ],
                ),
              ),

            ],
          ),
        );
      }
    );
  }


  void _getFromCamera()async{
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);

  }

  void _getFromGallery()async{
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _cropImage(filePath)async{
    CroppedFile? croppedImage = await ImageCropper().cropImage(sourcePath: filePath,
    maxHeight: 1080,
    maxWidth: 1080);

    if(croppedImage != null){
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }

  }


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          // cached image
          CachedNetworkImage(
            imageUrl: signupUrlImage,
            placeholder: (context, url)=>
                Image.asset('assets/images/wallpaper.jpg',
                fit: BoxFit.fill,),
            errorWidget: (context, url, error)=> const Icon(Icons.error,

            ),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Container(
            color: Colors.black54,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.016, vertical: height * 0.080),
              child: ListView(
                children: [
                  Form(
                    key: _signUpFormKey,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: (){
                              // Create ShowImageDialog
                              _showImageDialog();
                            },
                            child: Padding(
                              padding: EdgeInsets.all(width * 0.04),
                              child: Container(
                                height: width * 0.24,
                                width: width * 0.24,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: Colors.cyanAccent),
                                  borderRadius: BorderRadius.circular(width * 0.025)
                                  
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(width * 0.030,
                                ),
                                  child: imageFile == null? Icon(Icons.camera_enhance_sharp,
                                  color: Colors.cyan,
                                  size: width * 0.070,):Image.file(imageFile!,
                                  fit: BoxFit.fill,),
                              ),
                            ),
                            ) ),

                          SizedBox(height: height * 0.020,),
                          // full name
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_emailFocusNode),
                            keyboardType: TextInputType.name,
                            controller: _fullNameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "This Field is missing";
                              } else {
                                return null;
                              }
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                hintText: "Full name / Company name",
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.white)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.white)),
                                errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red))),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          // email
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_passFocusNode),
                            keyboardType: TextInputType.name,
                            controller: _emailTextController,
                            validator: (value) {
                              if (value!.isEmpty || !value.contains("@")) {
                                return "Please enter a valid Email address";
                              } else {
                                return null;
                              }
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.white)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.white)),
                                errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red))),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          // password
                          TextFormField(
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => FocusScope.of(context)
                                  .requestFocus(_phoneFocusNode),
                              controller: _passwordTextController,
                              obscureText:
                              !_obscureText, // it's dynamically change it
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {
                                if (value!.isEmpty || value.length > 7) {
                                  return "Please enter a valid password";
                                } else {
                                  return null;
                                }
                              },
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                    child: Icon(
                                      _obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.white,
                                    ),
                                  ),
                                  hintText: "Password",
                                  hintStyle:
                                  const TextStyle(color: Colors.white),
                                  enabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.white)),
                                  focusedBorder: const UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.white)),
                                  errorBorder: const UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.red)))),

                          SizedBox(
                            height: height * 0.02,
                          ),

                          // phone number
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_positionCPFocusNode),
                            keyboardType: TextInputType.phone,
                            controller: _phoneNumberController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "This Field is missing";
                              } else {
                                return null;
                              }
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                hintText: "Phone Number",
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.white)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.white)),
                                errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red))),
                          ),

                          SizedBox(
                            height: height * 0.02,
                          ),

                          // company address
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_positionCPFocusNode),
                            keyboardType: TextInputType.text,
                            controller: _locationController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "This Field is missing";
                              } else {
                                return null;
                              }
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                hintText: "Company Address",
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.white)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.white)),
                                errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red))),
                          ),

                          SizedBox(height: height * 0.025,),

                          _isLoading?
                              Center(
                                child: Container(
                                  height: width * 0.070,
                                  width: width * 0.070,
                                  child: const CircularProgressIndicator(),
                                ),
                              ):  MaterialButton(
                            onPressed: () {

                              // Create submit Form On Signup
                            },
                            color: Colors.cyan,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(width * 0.013)),
                            child: Padding(
                              padding:
                              EdgeInsets.symmetric(vertical: width * 0.010),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'SignUp',
                                    style: TextStyle(
                                        fontSize: width * 0.045,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: height * 0.040,),
                          Center(
                            child: RichText(text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Already have an account?",
                                    style: TextStyle(
                                        fontSize: width * 0.045,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)
                                ),
                                const TextSpan(text: '    '),
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                      ..onTap = ()=> Navigator.canPop(context)?
                                          Navigator.pop(context)
                                          :null,
                                  text: "Login",
                                    style: TextStyle(
                                        fontSize: width * 0.045,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.cyan)

                                )

                              ]
                            )),
                          )

                        ],
                      ))
                ],
              ),
            ),
          )

        ],
      ),
    );
  }
}
