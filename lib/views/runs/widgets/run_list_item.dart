import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:RuneoDriverFlutter/models/index.dart';
import 'package:RuneoDriverFlutter/views/runs/runs_details_page.dart';

class RunListItem extends StatelessWidget {
  final Run run;
  final Function onTap;
  const RunListItem({
    this.run,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    User user = User();
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RunsDetailPage(run: run)
          )
        );
      },
      child : Card(
        child: ListTile(
          leading: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: (user.isBelongingToSomeone(run)) ? Colors.red : Colors.green,
            ),
            child: Padding(
              padding: EdgeInsets.all(15.0),
            ),
          ),
          title: Text(
            run.title,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w900),
          ),
          subtitle: 
          (run.waypoints.length > 0) ?
          Text(
            run.waypoints[0].nickname,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ) : '',
          trailing: Text(
            DateFormat('EEE HH:mm', 'fr_CH').format(DateTime.parse(run.beginAt)),
          ),
        )
      ),
    );
  }
}