import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flushbar/flushbar.dart';

import 'package:RuneoDriverFlutter/bloc/authentication/index.dart';
import 'package:RuneoDriverFlutter/views/runs/widgets/filter_button.dart';
import 'package:RuneoDriverFlutter/views/shared/loading_indicator.dart';
import 'package:RuneoDriverFlutter/bloc/runs/index.dart';
import 'package:RuneoDriverFlutter/models/index.dart';
import 'package:RuneoDriverFlutter/views/runs/widgets/run_list_item.dart';
import 'package:RuneoDriverFlutter/bloc/connectivity/connectivity_bloc.dart';
import 'package:RuneoDriverFlutter/bloc/connectivity/index.dart';

class RunsPage extends StatefulWidget {
  @override
  _RunsPageState createState() => _RunsPageState();
}

class _RunsPageState extends State<RunsPage> {
  RunBloc _runBloc;
  ConnectivityBloc _connectivityBloc;
  StreamSubscription<ConnectivityResult> _subscription;

  @override
  void initState() {
    super.initState();
    _runBloc = BlocProvider.of<RunBloc>(context);
    _connectivityBloc = BlocProvider.of<ConnectivityBloc>(context);    
    _subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Got a new connectivity status!
      _connectivityBloc.add(GetStatusInfo(result: result));
    });
  }

  @override
  dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          return Material(
            child: Scaffold(
              appBar: AppBar(
                title: Text("Runéo"),
                actions: <Widget>[
                  FilterButton(visible: true),
                  IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: ()  {
                      BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                    },
                  ),
                ]
              ),
              body: Container(
                child: BlocConsumer<RunBloc, RunState>(
                  listener: (context, state) {
                    if (state is RunErrorState) {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                        )
                      );
                    } else if (state is OfflineState) {
                      _showFlushBar(context, "Offline", Colors.grey, Colors.redAccent, false, true);
                    } else if (state is OnlineState) {
                      _showFlushBar(context, "Online", Colors.grey, Colors.green, true, false);
                    }
                  },
                  builder: (context, state) {
                    if (state is RunInitalState) {
                      return LoadingIndicator();
                    } else if (state is RunLoadingState) {
                      return LoadingIndicator();
                    } else if (state is RunLoadedState) {
                      if (state.runs != null && state.runs.isNotEmpty) {
                        return _buildRunList(state.runs);
                      } else {
                        return _buildNoDataView(context);
                      }
                    } else {
                      return Container();
                    }                    
                  }
                )
              )
            )
          );
        }
      )
    );
  }
}

Widget _buildNoDataView(BuildContext context) => Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        "No runs yet.",
        style: TextStyle(
          fontSize: 30.0,
        ),
      ),
    ],
  ),
);

Widget _buildErrorUi(String message) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        message,
        style: TextStyle(color: Colors.red),
      ),
    ),
  );
}

Widget _buildRunList(List<Run> runs) => ListView.builder(
  itemCount: runs.length,
     itemBuilder: (context, index) => RunListItem(
      run: runs[index],
     )
  );

Widget _showFlushBar(BuildContext context, String message, Color progressColor, Color backgroundColor, bool isDismissible, bool showProgress) {
  return Flushbar(
    message: message,
    isDismissible: isDismissible,
    backgroundColor: backgroundColor,
    showProgressIndicator: showProgress,
    progressIndicatorBackgroundColor: progressColor,
    duration: Duration(seconds: 3),
  )..show(context);
}