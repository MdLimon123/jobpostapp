

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_post_app/Jobs/jobs_screen.dart';
import 'package:job_post_app/Services/global_methods.dart';

class JobDetailsScreen extends StatefulWidget {

final String uploadedBy;
final String jobID;

const JobDetailsScreen({super.key, required this.uploadedBy, required this.jobID});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? authorName;
  String? userImageUrl;
  String? jobCategory;
  String? jobDescription;
  String? jobTitle;
  bool? recruitment;
  Timestamp? postedDateTimeStamp;
  Timestamp? deadlineDateTimeStamp;
  String? postedDate;
  String? deadlineDate;
  String? locationCompany = '';
  String? emailCompany = '';
  int applicants = 0;
  bool isDeadlineAvailable = false;

  void getJobData()async{

    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uploadedBy)
        .get();

    if(userDoc == null){
      return;

    }else{
      setState(() {

       authorName = userDoc.get('name');
       userImageUrl = userDoc.get('userImage');

      });

      final DocumentSnapshot jobDatabase = await FirebaseFirestore.instance
      .collection('jobs')
      .doc(widget.jobID)
      .get();

      if(jobDatabase == null){
        return;
      }else{

        setState(() {
          
          jobTitle = jobDatabase.get('jobTitle');
          jobDescription = jobDatabase.get('jobDescription');
          recruitment = jobDatabase.get('recruitment');
          emailCompany = jobDatabase.get('email');
          locationCompany = jobDatabase.get('location');
          applicants = jobDatabase.get('applicants');
          postedDateTimeStamp = jobDatabase.get('createdAt');
          deadlineDateTimeStamp = jobDatabase.get('deadlineDateTimeStamp');
          deadlineDate = jobDatabase.get('deadlineDate');
          jobDescription = jobDatabase.get('jobDescription');

          var postDate = postedDateTimeStamp!.toDate();
          postedDate = '${postDate.year}-${postDate.month}-${postDate.day}';

          
        });

        var date = deadlineDateTimeStamp!.toDate();
        isDeadlineAvailable = date.isBefore(DateTime.now());
      }
    }
  }



  @override
  initState(){
    getJobData();
    super.initState();


  }

  Widget dividerWidget(){
    return const Column(
      children: [
        SizedBox(height: 10,),
        Divider(
          thickness: 1,
          color: Colors.grey,
        ),
        SizedBox(height: 10,)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.deepOrange.shade300, Colors.blueAccent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.2, 0.9])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.deepOrange.shade300, Colors.blueAccent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: const [0.2, 0.9])),
            ),
          leading: IconButton(
              onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> JobsScreen()));
              },
              icon: Icon(Icons.close, size: width * 0.080,color: Colors.white,)),
        ),

        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(width * 0.004),
                child: Card(
                  color: Colors.black54,
                  child:Padding(
                    padding: EdgeInsets.all(width*0.010),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding:EdgeInsets.only(left: width * 0.004),
                          child: Text(
                            jobTitle == null
                                ?
                                ''
                                :
                                jobTitle!,
                            maxLines: 3,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.060
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.020,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: Colors.grey
                                ),
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                    image: NetworkImage(
                                      userImageUrl == null
                                          ?
                                          'https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/User-avatar.svg/800px-User-avatar.svg.png'
                                          :
                                          userImageUrl!
                                    ),
                                  fit: BoxFit.fill
                                )
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: height * 0.010),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    authorName == null
                                        ?
                                        ""
                                        :
                                        authorName!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: width * 0.035,
                                      color: Colors.white
                                    ),
                                  ),
                                  SizedBox(height: height * 0.008,),
                                  Text(locationCompany!,
                                  style: const TextStyle(color: Colors.grey),)
                                ],
                              ),
                            )
                          ],
                        ),
                        dividerWidget(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(applicants.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.040
                            ),),
                            SizedBox(
                              width: width * 0.02,
                            ),
                            const Text('Applicants',
                            style: TextStyle(color: Colors.grey),),
                            SizedBox(width: width * 0.03,),
                            const Icon(Icons.how_to_reg_sharp,
                            color: Colors.grey,)
                          ],
                        ),

                        FirebaseAuth.instance.currentUser!.uid != widget.uploadedBy
                        ?
                            Container()
                            :
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                dividerWidget(),
                                Text('Recruitment',
                                style: TextStyle(
                                  fontSize: width * 0.040,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                ),),
                                SizedBox(height: height * 0.005,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    TextButton(
                                        onPressed: (){
                                          User? user = _auth.currentUser;
                                          final _uid = user!.uid;
                                          if(_uid == widget.uploadedBy){
                                            
                                            try{
                                              FirebaseFirestore.instance.collection('jobs')
                                                  .doc(widget.jobID)
                                                  .update({'recruitment': true});
                                            }catch(error){
                                              GlobalMethod.showErrorDialog(
                                                  err: 'Action cannot be performed',
                                                  ctx: context);
                                            }
                                          }else{
                                            GlobalMethod.showErrorDialog(
                                                err: 'You cannot perform this action',
                                                ctx: context);
                                          }
                                          getJobData();
                                        },
                                        child: Text('ON',
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.black,
                                          fontSize: width * 0.045,
                                          fontWeight: FontWeight.normal
                                        ),)),
                                    Opacity(opacity: recruitment == true ? 1 :0,
                                    child: const Icon(Icons.check_box,
                                    color: Colors.green,),),

                                    SizedBox(width: width * 0.0040,),

                                    TextButton(
                                        onPressed: (){
                                          User? user = _auth.currentUser;
                                          final _uid = user!.uid;
                                          if(_uid == widget.uploadedBy){

                                            try{
                                              FirebaseFirestore.instance.collection('jobs')
                                                  .doc(widget.jobID)
                                                  .update({'recruitment': false});
                                            }catch(error){
                                              GlobalMethod.showErrorDialog(
                                                  err: 'Action cannot be performed',
                                                  ctx: context);
                                            }
                                          }else{
                                            GlobalMethod.showErrorDialog(
                                                err: 'You cannot perform this action',
                                                ctx: context);
                                          }
                                          getJobData();
                                        },
                                        child: Text('OFF',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: Colors.black,
                                              fontSize: width * 0.045,
                                              fontWeight: FontWeight.normal
                                          ),)),

                                    Opacity(opacity: recruitment == false ? 1 :0,
                                      child: const Icon(Icons.check_box,
                                        color: Colors.red,),),

                                  ],
                                )
                              ],
                            ),
                        dividerWidget(),
                        Text('Job Description',
                        style: TextStyle(
                          fontSize: width * 0.038,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),),
                        SizedBox(height: height * 0.010,),
                        Text(
                          jobDescription == null
                              ?
                              ''
                              :
                              jobDescription!,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: width * 0.030,
                            color: Colors.grey
                          ),
                        ),
                        dividerWidget(),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                  padding:EdgeInsets.all(width * 0.004),
                child: Card(
                  color: Colors.black54,
                  child: Padding(
                    padding: EdgeInsets.all(width * 0.008),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.010,),
                        Center(
                          child: Text(
                              isDeadlineAvailable ?
                                'Actively Recruiting, Send CD/Resume:'
                                :
                                'Deadline Passed away.',
                            style: TextStyle(
                              color: isDeadlineAvailable
                                  ?
                                  Colors.green
                                  :
                                  Colors.red,
                              fontSize: width * 0.040,
                              fontWeight: FontWeight.normal
                            ),
                          ),
                        ),

                        SizedBox(height: height * 0.006,),
                        Center(
                          child: MaterialButton(
                            onPressed: (){},
                            color: Colors.blueAccent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(width * 0.030),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: height * 0.014),
                              child: Text('Easy Apply Now',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.030
                              ),),
                            ),
                          ),
                        ),

                        dividerWidget(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Uploaded on:',
                            style: TextStyle(
                              color: Colors.white
                            ),),
                             Text(
                               postedDate == null
                                   ?
                                   ''
                                   :
                                   postedDate!,
                               style: TextStyle(
                                 color: Colors.grey,
                                 fontWeight: FontWeight.bold,
                                 fontSize: width * 0.035
                               ),
                             )
                          ],
                        ),

                        SizedBox(
                          height: height * 0.012,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Deadline date:',
                              style: TextStyle(
                                  color: Colors.white
                              ),),
                            Text(
                              deadlineDate == null
                                  ?
                              ''
                                  :
                              deadlineDate!,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: width * 0.035
                              ),
                            )
                          ],
                        ),

                        dividerWidget()

                      ],
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
