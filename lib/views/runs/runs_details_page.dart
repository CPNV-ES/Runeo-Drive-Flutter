import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:RuneoDriverFlutter/models/index.dart';

class RunsDetailPage extends StatelessWidget {
  final Run run;
  RunsDetailPage({
    Key key,
    this.run
  }): super(key: key);
  @override
  Widget build(BuildContext context) {
    final levelIndicator = Container(
      child: Container(
        child: Icon(
          Icons.people,
          color: Colors.greenAccent,
          size: 30.0,
        ),
      ),
    );

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget> [
        SizedBox(height: 60.0),
        Icon(
          Icons.directions_car,
          color: Colors.white,
          size: 30.0,
        ),
        Container(
          width: 100.0,
          child: new Divider(color: Colors.green),
        ),
        SizedBox(height: 20.0),
        Text(
          run.title,
          style: TextStyle(color: Colors.white, fontSize: 35.0),
        ),
        SizedBox(height: 23.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget> [
            Expanded(flex: 1, child: levelIndicator),
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  run.nbPassenger.toString(),
                  style: TextStyle(color: Colors.white),
                ))),
          ],
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget> [
        Container(
          padding: EdgeInsets.only(left: 50.0),
          height: MediaQuery.of(context).size.height * 0.5,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
          child: Center(
            child: topContentText,
          ),
        ),
        Positioned(
          left: 8.0,
          top: 40.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        )
      ],
    );

    final bottomContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget> [
        Row(
          children: [
            Icon(
              Icons.access_time,
              color: Colors.black,
              size: 30.0,
            ),
            SizedBox(width: 10.0),
            Text(
              (run.beginAt != null) ? DateFormat('EEEE à HH:mm', 'fr_CH').format(DateTime.parse(run.beginAt)) : '-',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(width: 20.0),
            Icon(
              Icons.access_time,
              color: Colors.black,
              size: 30.0,
            ),
            SizedBox(width: 10.0),
            Text(
              (run.endAt != null) ? DateFormat('EEEE à HH:mm', 'fr_CH').format(DateTime.parse(run.endAt)) : "-",
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child : Icon(
                Icons.info,
                color: Colors.black,
                size: 30.0,
              ),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 20.0),
                child : Text(
                  run.runinfo,
                  style: TextStyle(fontSize: 18.0),
                ),
              )
            ),
          ],
        ),
      ],
    );   
    final readButton = Container(
      margin: EdgeInsets.only(top: 100.0),
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        onPressed: () => {},
        color: Color.fromRGBO(58, 66, 86, 1.0),
        child:
        Text("TAKE THIS RUN", style: TextStyle(color: Colors.white)),
      ));
    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: <Widget> [bottomContentText, readButton],
        ),
      ),
    );

    return Scaffold(
      body: ListView(
        children: <Widget> [topContent, bottomContent],
      ),
    );
  }
}