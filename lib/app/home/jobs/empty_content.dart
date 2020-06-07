import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  final String title;
  final String message;
  EmptyContent({
    Key key,
    this.title = 'Nothing Here',
    this.message = 'Add a new item to get started',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(title, style: TextStyle(fontSize: 32.0, color: Colors.black54),),
          SizedBox(
            height: 10,
          ),
          Text(message, style: TextStyle(fontSize: 20.0, color: Colors.black54),),
        ],
      ),
    );
  }
}
