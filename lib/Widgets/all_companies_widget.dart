// ignore_for_file: prefer_if_null_operators

import 'package:flutter/material.dart';
import 'package:job_post_app/Search/profile_company.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AllWorkersWidget extends StatefulWidget {

  final String userID;
  final String userName;
  final String userEmail;
  final String phoneNumber;
  final String userImageUrl;

  const AllWorkersWidget({
    required this.userID,
    required this.userName,
    required this.userEmail,
    required this.phoneNumber,
    required this.userImageUrl
});



  @override
  State<AllWorkersWidget> createState() => _AllWorkersWidgetState();
}

class _AllWorkersWidgetState extends State<AllWorkersWidget> {


  void _mailTo()async{
    var mailUrl = 'mailto: ${widget.userEmail}';
    print('widget.userEmail ${widget.userEmail}');

    if(await canLaunchUrlString(mailUrl)){
      await launchUrlString(mailUrl);
    }else{
      print('Error');
      throw 'Error Occurred';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: Colors.white10,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        onTap: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> ProfileScreen(userID: widget.userID)));

        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(width: 1)
            )
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,

           radius: 20,
            child: Image.network(
              widget.userImageUrl == null?
                'data:image/png;base64,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'
                  :
                  widget.userImageUrl
            ),
          ),
        ),
        title: Text(widget.userName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),),
        subtitle: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Visit Profile',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey
            ),)
          ],
        ),
        trailing: IconButton(
          onPressed: (){
            _mailTo();
          },
          icon: const Icon(Icons.mail_outline,size: 30,
          color: Colors.grey,),
        ),
      ),
    );
  }
}
