import 'package:flutter/material.dart';
import 'package:job_post_app/Persistent/persistent.dart';

import '../Widgets/bottom_nav_bar.dart';

class UploadJobNow extends StatefulWidget {
  const UploadJobNow({super.key});

  @override
  State<UploadJobNow> createState() => _UploadJobNowState();
}

class _UploadJobNowState extends State<UploadJobNow> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _jobCategoryController =
      TextEditingController(text: 'Select Job Category');
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDescriptionController =
      TextEditingController();
  final TextEditingController _deadlineDateController = TextEditingController();

  bool _isLoading = false;

  Widget _textTitles({required String label}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        label,
        style: const TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _textFormFields(
      {required String valueKey,
      required TextEditingController controller,
      required bool enabled,
      required Function fct,
      required int maxLength}) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: InkWell(
          onTap: () {
            fct();
          },
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Value is missing';
              }
              return null;
            },
            controller: controller,
            enabled: enabled,
            key: ValueKey(valueKey),
            style: const TextStyle(color: Colors.white),
            maxLines: valueKey == 'JobDescription' ? 3 : 1,
            maxLength: maxLength,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.black54,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red))),
          ),
        ));
  }

  _showTaskCategoriesDialog({required Size size}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: const Text(
              'Job Category',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: Persistent.jobCategoryList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _jobCategoryController.text =
                            Persistent.jobCategoryList[index];
                      });
                      Navigator.pop(context);
                    },
                    child:  Row(
                      children: [
                        const Icon(Icons.arrow_right_alt_outlined,
                        color: Colors.grey,),
                      Padding(padding: const EdgeInsets.all(8.0),
                      child: Text(
                        Persistent.jobCategoryList[index],
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,

                        ),
                      ),
                      )
                      ],
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: const Text('Cancel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                  ),))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.deepOrange.shade300, Colors.blueAccent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.2, 0.9])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 2),
        // appBar: AppBar(
        //   title: const Text('Upload Job Now'),
        //   centerTitle: true,
        //   flexibleSpace: Container(
        //     decoration: BoxDecoration(
        //         gradient: LinearGradient(
        //             colors: [Colors.deepOrange.shade300, Colors.blueAccent],
        //             begin: Alignment.centerLeft,
        //             end: Alignment.centerRight,
        //             stops: const [0.2, 0.9])),
        //   ),
        // ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(width * 0.07),
            child: Card(
              color: Colors.white10,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.010,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(width * 0.08),
                        child: Text(
                          'Please fill all fields',
                          style: TextStyle(
                              fontSize: width * 0.080,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Signatra'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.0010,
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Padding(
                      padding: EdgeInsets.all(width * 0.008),
                      child: Form(
                          key: _formKey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _textTitles(label: 'Job Category :'),
                                _textFormFields(
                                    valueKey: "JobCategory",
                                    controller: _jobCategoryController,
                                    enabled: false,
                                    fct: () {
                                      _showTaskCategoriesDialog(size: size );
                                    },
                                    maxLength: 100),
                                _textTitles(label: 'Job Title :'),
                                _textFormFields(
                                    valueKey: 'JobTitle',
                                    controller: _jobTitleController,
                                    enabled: true,
                                    fct: () {},
                                    maxLength: 100),
                                _textTitles(label: 'Job Description :'),
                                _textFormFields(
                                    valueKey: 'JobDescription',
                                    controller: _jobDescriptionController,
                                    enabled: true,
                                    fct: () {},
                                    maxLength: 100),
                                _textTitles(label: 'Job Deadline Date :'),
                                _textFormFields(
                                    valueKey: 'Deadline',
                                    controller: _deadlineDateController,
                                    enabled: true,
                                    fct: () {},
                                    maxLength: 100),
                              ])),
                    ),
                    Center(
                      child: Padding(
                          padding: EdgeInsets.only(bottom: width * 0.030),
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : MaterialButton(
                                  onPressed: () {},
                                  color: Colors.black,
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(width * 0.020)),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: height * 0.014),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Post Now',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: width * 0.060,
                                              fontFamily: 'Signatra'),
                                        ),
                                        SizedBox(
                                          width: width * 0.009,
                                        ),
                                        const Icon(
                                          Icons.upload_file,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
