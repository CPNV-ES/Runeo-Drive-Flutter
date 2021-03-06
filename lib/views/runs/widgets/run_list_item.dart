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
              color: _statusRun(run),
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

  Color _statusRun(Run run) {
    switch (run.status) {
      case "drafting":
        return Colors.pink[100];
        break;
      case "unpublished":
        return Colors.black;
        break;
      case "needs_filling":
        return Colors.amber;
        break;
      case "almost_ready":
        return Colors.green[300];
        break;
      case "error":
        return Colors.red;
        break;
      case "ready":
        return Colors.green[800];
        break;
      case "starting":
        return Colors.blue[100];
        break;
      case "ending":
        return Colors.blue[100];
        break;
      case "gone":
        return Colors.blue[400];
        break;
      case "finished":
        return Colors.blueGrey[100];
        break;
      case "cancelled":
        return Colors.grey[800];
        break;
      default:
    }
  }
}