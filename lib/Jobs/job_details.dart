import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:job_post_app/Jobs/jobs_screen.dart';
import 'package:job_post_app/Services/global_methods.dart';
import 'package:job_post_app/Services/global_veriables.dart';
import 'package:job_post_app/Widgets/comment_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:uuid/uuid.dart';

class JobDetailsScreen extends StatefulWidget {
  final String uploadedBy;
  final String jobID;

  const JobDetailsScreen(
      {super.key, required this.uploadedBy, required this.jobID});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isCommenting = false;
  final TextEditingController _commentController = TextEditingController();
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
  bool showComment = false;

  void getJobData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uploadedBy)
        .get();

    if (userDoc == null) {
      return;
    } else {
      setState(() {
        authorName = userDoc.get('name');
        userImageUrl = userDoc.get('userImage');
      });

      final DocumentSnapshot jobDatabase = await FirebaseFirestore.instance
          .collection('jobs')
          .doc(widget.jobID)
          .get();

      if (jobDatabase == null) {
        return;
      } else {
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
  initState() {
    getJobData();
    super.initState();
  }

  Widget dividerWidget() {
    return const Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Divider(
          thickness: 1,
          color: Colors.grey,
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  applyForJob() {
    final Uri params = Uri(
      scheme: 'mailto',
      path: emailCompany,
      query:
          'subject=Applying for $jobTitle&body=Hello, please attach Resume CV file',
    );

    final url = params.toString();
    launchUrlString(url);
    addNewApplicant();
  }

  void addNewApplicant() async {
    var docRef =
        FirebaseFirestore.instance.collection('jobs').doc(widget.jobID);

    docRef.update({'applicants': applicants + 1});

    Navigator.pop(context);
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
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => JobsScreen()));
              },
              icon: Icon(
                Icons.close,
                size: width * 0.080,
                color: Colors.white,
              )),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(width * 0.004),
                child: Card(
                  color: Colors.black54,
                  child: Padding(
                    padding: EdgeInsets.all(width * 0.010),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: width * 0.004),
                          child: Text(
                            jobTitle == null ? '' : jobTitle!,
                            maxLines: 3,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.060),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.020,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 3, color: Colors.grey),
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                      image: NetworkImage(userImageUrl == null
                                          ? 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/User-avatar.svg/800px-User-avatar.svg.png'
                                          : userImageUrl!),
                                      fit: BoxFit.fill)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: height * 0.010),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    authorName == null ? "" : authorName!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: width * 0.035,
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: height * 0.008,
                                  ),
                                  Text(
                                    locationCompany!,
                                    style: const TextStyle(color: Colors.grey),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        dividerWidget(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              applicants.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: width * 0.040),
                            ),
                            SizedBox(
                              width: width * 0.02,
                            ),
                            const Text(
                              'Applicants',
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              width: width * 0.03,
                            ),
                            const Icon(
                              Icons.how_to_reg_sharp,
                              color: Colors.grey,
                            )
                          ],
                        ),
                        FirebaseAuth.instance.currentUser!.uid !=
                                widget.uploadedBy
                            ? Container()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  dividerWidget(),
                                  Text(
                                    'Recruitment',
                                    style: TextStyle(
                                        fontSize: width * 0.040,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: height * 0.005,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            User? user = _auth.currentUser;
                                            final _uid = user!.uid;
                                            if (_uid == widget.uploadedBy) {
                                              try {
                                                FirebaseFirestore.instance
                                                    .collection('jobs')
                                                    .doc(widget.jobID)
                                                    .update(
                                                        {'recruitment': true});
                                              } catch (error) {
                                                GlobalMethod.showErrorDialog(
                                                    err:
                                                        'Action cannot be performed',
                                                    ctx: context);
                                              }
                                            } else {
                                              GlobalMethod.showErrorDialog(
                                                  err:
                                                      'You cannot perform this action',
                                                  ctx: context);
                                            }
                                            getJobData();
                                          },
                                          child: Text(
                                            'ON',
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                                fontSize: width * 0.045,
                                                fontWeight: FontWeight.normal),
                                          )),
                                      Opacity(
                                        opacity: recruitment == true ? 1 : 0,
                                        child: const Icon(
                                          Icons.check_box,
                                          color: Colors.green,
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.0040,
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            User? user = _auth.currentUser;
                                            final _uid = user!.uid;
                                            if (_uid == widget.uploadedBy) {
                                              try {
                                                FirebaseFirestore.instance
                                                    .collection('jobs')
                                                    .doc(widget.jobID)
                                                    .update(
                                                        {'recruitment': false});
                                              } catch (error) {
                                                GlobalMethod.showErrorDialog(
                                                    err:
                                                        'Action cannot be performed',
                                                    ctx: context);
                                              }
                                            } else {
                                              GlobalMethod.showErrorDialog(
                                                  err:
                                                      'You cannot perform this action',
                                                  ctx: context);
                                            }
                                            getJobData();
                                          },
                                          child: Text(
                                            'OFF',
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                                fontSize: width * 0.045,
                                                fontWeight: FontWeight.normal),
                                          )),
                                      Opacity(
                                        opacity: recruitment == false ? 1 : 0,
                                        child: const Icon(
                                          Icons.check_box,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                        dividerWidget(),
                        Text(
                          'Job Description',
                          style: TextStyle(
                              fontSize: width * 0.038,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: height * 0.010,
                        ),
                        Text(
                          jobDescription == null ? '' : jobDescription!,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontSize: width * 0.030, color: Colors.grey),
                        ),
                        dividerWidget(),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(width * 0.004),
                child: Card(
                  color: Colors.black54,
                  child: Padding(
                    padding: EdgeInsets.all(width * 0.008),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height * 0.010,
                        ),
                        Center(
                          child: Text(
                            isDeadlineAvailable
                                ? 'Actively Recruiting, Send CD/Resume:'
                                : 'Deadline Passed away.',
                            style: TextStyle(
                                color: isDeadlineAvailable
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: width * 0.040,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.006,
                        ),
                        Center(
                          child: MaterialButton(
                            onPressed: () {
                              applyForJob();
                            },
                            color: Colors.blueAccent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(width * 0.030),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: height * 0.014),
                              child: Text(
                                'Easy Apply Now',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: width * 0.030),
                              ),
                            ),
                          ),
                        ),
                        dividerWidget(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Uploaded on:',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              postedDate == null ? '' : postedDate!,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: width * 0.035),
                            )
                          ],
                        ),
                        SizedBox(
                          height: height * 0.012,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Deadline date:',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              deadlineDate == null ? '' : deadlineDate!,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: width * 0.035),
                            )
                          ],
                        ),
                        dividerWidget()
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(width * 0.004),
                child: Card(
                  color: Colors.black54,
                  child: Padding(
                    padding: EdgeInsets.all(width * 0.008),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: _isCommenting
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Flexible(
                                          flex: 3,
                                          child: TextField(
                                            controller: _commentController,
                                            style: const TextStyle(
                                                color: Colors.white),
                                            maxLength: 200,
                                            keyboardType: TextInputType.text,
                                            maxLines: 6,
                                            decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.white)),
                                                focusedBorder:
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.pink),
                                                )),
                                          )),
                                      Flexible(
                                          child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: width * 0.008),
                                            child: MaterialButton(
                                              onPressed: () async {
                                                if (_commentController
                                                        .text.length <
                                                    7) {
                                                  GlobalMethod.showErrorDialog(
                                                      err:
                                                          'Comment cannot be less the 7 characters',
                                                      ctx: context);
                                                } else {
                                                  final _generatedId =
                                                      const Uuid().v4();
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('jobs')
                                                      .doc(widget.jobID)
                                                      .update({
                                                    'jobComment':
                                                        FieldValue.arrayUnion([
                                                      {
                                                        'userId': FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid,
                                                        'commentId':
                                                            _generatedId,
                                                        'name': name,
                                                        'userImageUrl':
                                                            userImage,
                                                        'commentBody':
                                                            _commentController
                                                                .text,
                                                        'time': Timestamp.now()
                                                      }
                                                    ])
                                                  });
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'Your comment has been added',
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      backgroundColor:
                                                          Colors.grey,
                                                      fontSize: width * 0.040);

                                                  _commentController.clear();
                                                }

                                                setState(() {
                                                  showComment = true;
                                                });
                                              },
                                              color: Colors.blueAccent,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        width * 0.02),
                                              ),
                                              child: Text(
                                                'Post',
                                                style: TextStyle(
                                                    fontSize: width * 0.030,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  _isCommenting =
                                                      !_isCommenting;
                                                  showComment = false;
                                                });
                                              },
                                              child: const Text(
                                                'Cancel',
                                              ))
                                        ],
                                      ))
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _isCommenting = !_isCommenting;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.add_comment,
                                            color: Colors.blue,
                                            size: width * 0.080,
                                          )),
                                      SizedBox(
                                        width: width * 0.005,
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              showComment = true;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.arrow_drop_down_circle,
                                            color: Colors.blue,
                                            size: width * 0.080,
                                          )),
                                    ],
                                  )),
                        showComment == false
                            ? Container()
                            : Padding(
                                padding: EdgeInsets.all(width * 0.016),
                                child: FutureBuilder<DocumentSnapshot>(
                                  future: FirebaseFirestore.instance
                                      .collection('jobs')
                                      .doc(widget.jobID)
                                      .get(),
                                  builder: (context,AsyncSnapshot<DocumentSnapshot> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      if (snapshot.data == null) {
                                        const Center(
                                          child:
                                              Text('No Comment for this job'),
                                        );
                                      }
                                    }
                                    return ListView.separated(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return CommentWidget(
                                              commentId:
                                                  snapshot.data!['jobComment']
                                                      [index]['commentId'],
                                              commenterId:
                                                  snapshot.data!['jobComment']
                                                      [index]['userId'],
                                              commenterName:
                                                  snapshot.data!['jobComment']
                                                      [index]['name'],
                                              commentBody:
                                                  snapshot.data!['jobComment']
                                                      [index]['commentBody'],
                                              commenterImageUrl:
                                                  snapshot.data!['jobComment']
                                                      [index]['userImageUrl']);
                                        },
                                        separatorBuilder: (context, index) {
                                          return const Divider(
                                            thickness: 1,
                                            color: Colors.grey,
                                          );
                                        },
                                        itemCount: snapshot
                                            .data!['jobComment'].length);
                                  },
                                ),
                              )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.050,
              )
            ],
          ),
        ),
      ),
    );
  }
}
