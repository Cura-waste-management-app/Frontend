 import '../../profile/screens/view_profile.dart';
import 'package:flutter/material.dart';
 

class ConversationAppBar extends StatefulWidget {
  final String imageURL;
  final String userName;
  const ConversationAppBar({Key? key, required this.imageURL, required this.userName}) : super(key: key);

  @override
  State<ConversationAppBar> createState() => _ConversationAppBarState();
}

class _ConversationAppBarState extends State<ConversationAppBar> {

  void selectPerson(BuildContext ctx){
    Navigator.of(ctx).pushNamed(ViewProfile.routeName,
    arguments: {
      'name': widget.userName,
      
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.only(right: 16),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back,color: Colors.black,),
          ),
          SizedBox(width: 2,),
          InkWell(
            onTap: () => selectPerson(context),
            child: CircleAvatar(
              backgroundImage: AssetImage(widget.imageURL),
              maxRadius: 20,
            ),
          ),
          SizedBox(width: 12,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(widget.userName,style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600),),

              ],
            ),
          ),
          Icon(Icons.report,color: Colors.black54,),
        ],
      ),
    );
  }
}



