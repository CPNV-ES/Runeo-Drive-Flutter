import 'package:RuneoDriverFlutter/models/index.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class RunListItem extends StatelessWidget {
  final Run run;
  final Function onTap;
  const RunListItem({this.run, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [
              BoxShadow(
                  blurRadius: 3.0,
                  offset: Offset(0.0, 2.0),
                  color: Color.fromARGB(80, 0, 0, 0))
            ]),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    run.title,
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w900),
                  ),
                  (run.waypoints.length > 0) ?
                  Text(
                    run.waypoints[0].nickname,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ) : '',
                  (run.recentlyUpdated != null) ?
                    Text(
                      "Maj",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w900),
                    ) : Text(""),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    DateFormat('EEE HH:mm', 'fr_CH').format(DateTime.parse(run.beginAt)),
                  ),
                  Text(
                    "Admin"
                  )
                ]
                
              ) 
            ],
          )
      ),
    );
  }
}