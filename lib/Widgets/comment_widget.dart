import 'package:flutter/material.dart';
import 'package:job_post_app/Search/profile_company.dart';

class CommentWidget extends StatefulWidget {

  final String commentId;
  final String commenterId;
  final String commenterName;
  final String commentBody;
  final String commenterImageUrl;

  const CommentWidget({
    required this.commentId,
    required this.commenterId,
    required this.commenterName,
    required this.commentBody,
    required this.commenterImageUrl
});


  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {

 final List<Color> _colors = [
    Colors.amber,
    Colors.orange,
    Colors.pink.shade200,
    Colors.brown,
    Colors.cyan,
    Colors.blueAccent,
    Colors.deepOrange
  ];

  @override
  Widget build(BuildContext context) {
    _colors.shuffle();
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ProfileScreen(userID: widget.commenterId)));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
              child:Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: _colors[1]
                  ),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(widget.commenterImageUrl, scale: 1.0),
                  fit: BoxFit.fill)
                ),
              ) ),
          SizedBox(width: width * 0.06,),
          Flexible(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.commenterName,
                style: TextStyle(
                  fontStyle: FontStyle.normal,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.040
                ),),
                SizedBox(height: height * 0.005,),
                Text(widget.commentBody,
                maxLines: 5,
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                        fontSize: width * 0.035,
                      fontWeight: FontWeight.normal
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
