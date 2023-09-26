import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_post_app/Jobs/jobs_screen.dart';

class JobDetailsScreen extends StatefulWidget {

final String uploadedBy;
final String jobID;

const JobDetailsScreen({super.key, required this.uploadedBy, required this.jobID});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {

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
        isDeadlineAvailable = date.isAfter(DateTime.now());
      }
    }
  }



  @override
  initState(){
    getJobData();
    super.initState();


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
                    padding: EdgeInsets.all(width*0.008),
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
                        )
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