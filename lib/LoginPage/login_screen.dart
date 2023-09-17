// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:job_post_app/ForgetPassword/forget_password_screen.dart';
import 'package:job_post_app/Services/global_methods.dart';
import 'package:job_post_app/Services/global_veriables.dart';
import 'package:job_post_app/SignupPage/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  final _loginFormKey = GlobalKey<FormState>();
  final FocusNode _passFocusNode = FocusNode();
  final TextEditingController _emailTextController =
      TextEditingController(text: '');
  final TextEditingController _passwordTextController =
      TextEditingController(text: '');
  bool _obscureText = true;
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _animationController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _passFocusNode.dispose();
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

  void _submitFormOnLogin() async {
    final isValid = _loginFormKey.currentState!.validate();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _auth.signInWithEmailAndPassword(
            email: _emailTextController.text.trim().toLowerCase(),
            password: _passwordTextController.text.trim());

        Navigator.canPop(context) ? Navigator.pop(context) : null;
        print('success');
      } catch (error) {
        setState(() {
          _isLoading = false;
        });

        GlobalMethod.showErrorDialog(err: error.toString(), ctx: context);

        print("error occurred $error");
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: loginUrlImage,
            placeholder: (context, url) => Image.asset(
              "assets/images/wallpaper.jpg",
              fit: BoxFit.fill,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Container(
            color: Colors.black54,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.016, vertical: height * 0.040),
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: width * 0.040, right: height * 0.040),
                    child: Image.asset('assets/images/login.png'),
                  ),
                  SizedBox(
                    height: height * 0.030,
                  ),
                  Form(
                      key: _loginFormKey,
                      child: Column(
                        children: [
                          // email
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_passFocusNode),
                            keyboardType: TextInputType.emailAddress,
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
                            height: height * 0.04,
                          ),
                          // password
                          TextFormField(
                              textInputAction: TextInputAction.next,
                              focusNode: _passFocusNode,
                              controller: _passwordTextController,
                              obscureText:
                                  !_obscureText, // it's dynmically chnage it
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
                            height: height * 0.015,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              ForgetPasswordScreen()));
                                },
                                child: Text(
                                  "Forget password?",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                      fontSize: width * 0.040),
                                )),
                          ),
                          SizedBox(
                            height: height * 0.010,
                          ),
                          MaterialButton(
                            onPressed: () {
                              _submitFormOnLogin();
                              // GlobalMethod.showErrorDialog(
                              //     err: '', ctx: context);
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
                                    'Login',
                                    style: TextStyle(
                                        fontSize: width * 0.045,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),

                          SizedBox(
                            height: height * 0.040),
                          Center(
                            child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: 'Do not have an account?',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: width * 0.040
                                        )
                                    ),
                                    const TextSpan(text: '    '),

                                    TextSpan(
                                      recognizer: TapGestureRecognizer()
                                          ..onTap = ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> SignUpScreen())),
                                      text: 'Signup',
                                      style: TextStyle(
                                        color: Colors.cyan,
                                        fontSize: width * 0.040,
                                        fontWeight: FontWeight.bold
                                      )
                                    )
                                  ]
                                ),

                            ),
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
