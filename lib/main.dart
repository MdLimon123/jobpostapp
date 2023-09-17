import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp( MyApp());
}

class MyApp extends StatelessWidget {

final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text('Job Post app is being initialization ',
                  style: TextStyle(
                    color: Colors.cyan,
                    fontSize: width * 0.045,
                    fontWeight: FontWeight.bold
                  ),),
                ),
              ),
            );
          }else if(snapshot.hasError){

            MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text('An error has been occurred ',
                    style: TextStyle(
                        color: Colors.cyan,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold
                    ),),
                ),
              ),
            );

          }
          return MaterialApp(
            title: "Job Post App",
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.black,

              primaryColor: Colors.blue
            ),
            home: Scaffold(
              appBar: AppBar(
                title: const Text('Job Partial App'),
              ),
            ),
          );
        });
  }
}


