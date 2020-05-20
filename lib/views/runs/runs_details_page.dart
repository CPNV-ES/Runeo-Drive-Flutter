import 'package:RuneoDriverFlutter/views/runs/runs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:RuneoDriverFlutter/models/index.dart';
import 'package:RuneoDriverFlutter/bloc/runs/index.dart';

class RunsDetailPage extends StatelessWidget {
  Run run;

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

    Widget topContentText(Run run) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget> [
        SizedBox(height: 60.0),
        Icon(
          Icons.directions_car,
          color: Colors.white,
          size: 30.0,
        ),
        Container(
          width: 200.0,
          child: new Divider(color: Colors.green),
        ),
        SizedBox(height: 20.0),
        Expanded(flex: 3,child: 
        Text(
          run.title,
          style: TextStyle(color: Colors.white, fontSize: 30.0),
        ),
        ),        
        SizedBox(height: 13.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget> [
            Expanded(flex: 1, child: levelIndicator),
            Expanded(
              flex: 8,
              child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: (run.nbPassenger != null) ? Text(run.nbPassenger.toString(), style: TextStyle(color: Colors.white)) : Text("0", style: TextStyle(color: Colors.white)),
              )
            )
          ],
        ),
      ],
    );

    Widget topContent(Run run) => Stack(
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
            child: topContentText(run),
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

    Widget bottomContentText(Run run) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget> [
        Container(
          width: 350.0,
          child: Row(
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
              Expanded(
                child: Text(
                (run.endAt != null) ? DateFormat('EEEE à HH:mm', 'fr_CH').format(DateTime.parse(run.endAt)) : "-",
                style: TextStyle(fontSize: 18.0),
                ),
              )
            ],
          ),
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
                child : (run.runinfo != null) ? Text(run.runinfo, style: TextStyle(fontSize: 18.0)) : Text("-", style: TextStyle(fontSize: 18.0)),
              )
            ),
          ],
        ),
      ],
    );

    Widget readButton(Run run) => Container(
      margin: EdgeInsets.only(top: 100.0),
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        onPressed: (run.isBelongingToSomeone(run)) ? null : () => { BlocProvider.of<RunBloc>(context).add(TakeARun(run, run.runners, DateFormat('y-MM-ddTHH:mm:ss', 'fr_CH').format(DateTime.parse("2020-05-19 09:54:50")))) },
        color: Color.fromRGBO(58, 66, 86, 1.0),
        child: (run.isBelongingToSomeone(run)) ? Text("ALREADY TAKEN", style: TextStyle(color: Colors.white)) : Text("TAKE THIS RUN", style: TextStyle(color: Colors.white)),
      )
    );

    Widget bottomContent(Run run) => Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: <Widget> [bottomContentText(run), readButton(run)],
        ),
      ),
    );

    return Scaffold(
      body: BlocConsumer<RunBloc, RunState>(
        listener: (context, state) {
          if (state is AddRunnerSuccessState) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              )
            );
          } else if (state is RunErrorState) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              )
            );
          }
        },
        builder: (context, state) {
          if (state is AddRunnerSuccessState) {
            return ListView(
              children: <Widget> [topContent(state.run), bottomContent(state.run)],
            );
          }
          return ListView(
            children: <Widget> [topContent(run), bottomContent(run)],
          );
        }
      )
    );
  }
}