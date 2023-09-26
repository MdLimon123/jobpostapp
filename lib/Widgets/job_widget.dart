




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:job_post_app/Jobs/job_details.dart';
import 'package:job_post_app/Services/global_methods.dart';

class JobWidget extends StatefulWidget {
  final String jobTitle;
  final String jobDescription;
  final String jobId;
  final String uploadedBy;
  final String userImage;
  final String name;
  final String email;
  final bool recruitment;
  final String loaction;

  const JobWidget(
      {required this.jobTitle,
      required this.jobDescription,
      required this.jobId,
      required this.uploadedBy,
      required this.userImage,
      required this.email,
      required this.recruitment,
      required this.name,
      required this.loaction});

  @override
  State<JobWidget> createState() => _JobWidgetState();
}

class _JobWidgetState extends State<JobWidget> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  _deleteDialog(){

    User? user = _auth.currentUser;
    final _uid = user!.uid;
    showDialog(
        context: context,
        builder:(ctx){
          return AlertDialog(
            actions: [
              TextButton(
                  onPressed: ()async{
                    try{
                      if(widget.uploadedBy == _uid){
                        await FirebaseFirestore.instance.collection('jobs')
                            .doc(widget.jobId)
                            .delete();

                        await Fluttertoast.showToast(msg: 'Job has been deleted',
                        toastLength: Toast.LENGTH_LONG,
                        backgroundColor: Colors.grey,
                        fontSize: 18.0);

                        // ignore: use_build_context_synchronously
                        Navigator.canPop(context)? Navigator.pop(context) : null;
                      }else{
                        print(widget.jobId);
                        GlobalMethod.showErrorDialog(err: 'You cannot perform this action', ctx: ctx);
                      }
                    }catch (error){
                      // ignore: use_build_context_synchronously
                      GlobalMethod.showErrorDialog(err: 'This task cannot be deleted', ctx: ctx);

                    }finally{}
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete,
                      color: Colors.red,),
                      Text('Delete',
                      style: TextStyle(color: Colors.red),)
                    ],
                  ))
            ],
          );
        });

  }


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Card(
      color: Colors.white24,
      elevation: 5,
      margin: EdgeInsets.symmetric(
          horizontal: width * 0.010, vertical: height * 0.01),
      child: ListTile(
        onTap: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> JobDetailsScreen(
            uploadedBy: widget.uploadedBy,
            jobID: widget.jobId,
          )));

        },
        onLongPress: () {
          _deleteDialog();
        },
        contentPadding: EdgeInsets.symmetric(
            horizontal: width * 0.020, vertical: height * 0.010),
        leading: Container(
          padding: EdgeInsets.only(right: width * 0.012),
          decoration: BoxDecoration(border: Border.all(width: 1)),
          child: Image.network(widget.userImage),
        ),
        title: Text(
          widget.jobTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              fontSize: width * 0.045),
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.040)),
            SizedBox(
              height: height * 0.008,
            ),
            Text(widget.jobDescription,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: width * 0.035,
                    fontWeight: FontWeight.w600)),
          ],
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          size: width * 0.060,
          color: Colors.black,
        ),
      ),
    );
  }
}
