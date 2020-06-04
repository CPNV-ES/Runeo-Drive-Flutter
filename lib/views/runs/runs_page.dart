import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:RuneoDriverFlutter/bloc/authentication/index.dart';
import 'package:RuneoDriverFlutter/bloc/runs/index.dart';
import 'package:RuneoDriverFlutter/bloc/firebase/index.dart';
import 'package:RuneoDriverFlutter/bloc/connectivity/index.dart';
import 'package:RuneoDriverFlutter/bloc/stopwatch/index.dart';

import 'package:RuneoDriverFlutter/models/index.dart';

import 'package:RuneoDriverFlutter/views/runs/widgets/filter_button.dart';
import 'package:RuneoDriverFlutter/views/shared/loading_indicator.dart';
import 'package:RuneoDriverFlutter/views/runs/widgets/run_list_item.dart';

import 'package:RuneoDriverFlutter/services/firebase_messaging_service.dart';

class RunsPage extends StatefulWidget {
  @override
  _RunsPageState createState() => _RunsPageState();
}

class _RunsPageState extends State<RunsPage> {
  RunBloc _runBloc;
  ConnectivityBloc _connectivityBloc;
  FirebaseMessagingBloc _firebaseMessagingBloc;
  StopwatchBloc _stopwatchBloc;
  StreamSubscription<ConnectivityResult> _subscription;
  Color backgroundColor;
  bool loading = true;
  Completer<void> _refreshCompleter;
  Timer timer;

  @override
  void initState() {
    super.initState();
    _runBloc = BlocProvider.of<RunBloc>(context);
    _connectivityBloc = BlocProvider.of<ConnectivityBloc>(context);
    _firebaseMessagingBloc = BlocProvider.of<FirebaseMessagingBloc>(context);
    _stopwatchBloc = BlocProvider.of<StopwatchBloc>(context);
    _refreshCompleter = Completer<void>();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _stopwatchBloc.add(RunningTimer()));

    /// Listen to connectivity change
    _subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Got a new connectivity status!
      _connectivityBloc.add(GetStatusInfo(result: result));
    });

    /// Listen to push notifications
    FirebaseMessagingService.instance.firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        _firebaseMessagingBloc.add(OnMessageEvent(message));
       //_showNotificationSnackBar(message);
      },
    );
  }

  @override
  dispose() {
    super.dispose();
    _runBloc.close();
    _connectivityBloc.close();
    _stopwatchBloc.close();
    _subscription.cancel();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Runéo"),
            backgroundColor: backgroundColor,
            actions: [
              Container(
                padding: EdgeInsets.only(top: 20),
                child: BlocBuilder<StopwatchBloc, StopwatchState>(
                  bloc: _stopwatchBloc,
                  builder: (context, state) {
                    return Text(state.displayTimer.padLeft(5));
                  }
                )
              ),
              FilterButton(visible: true),
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                },
              ),
            ]
          ),
          body: Container(
            child: BlocConsumer<RunBloc, RunState> (
              listener: (context, state) {
                if (state is RunErrorState) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    )
                  );
                }
                if (state is RunLoadedState) {
                  _refreshCompleter?.complete();
                  _refreshCompleter = Completer();
                }
                if (state is OfflineState) {
                  setState(() {
                    loading = false;
                    backgroundColor = Colors.red;
                  });
                }
                if (state is OnlineState) {
                  setState(() {
                    loading = true;
                    backgroundColor = Colors.blue;
                  });
                }
              },
              buildWhen: (previous, current) {
                if (current is OfflineState && previous is RunLoadedState) {
                  return false;
                }
                if (previous is RunLoadedState && current is OfflineState) {
                  return false;
                }
                if (current is AddRunnerSuccessState) {
                  return false;
                }
              },
              builder: (context, state) {
                if (state is RunInitalState) {
                  return LoadingIndicator();
                }
                if (state is RunLoadingState) {
                  return LoadingIndicator();
                }
                if (state is RunLoadedState) {
                  if (state.runs != null && state.runs.isNotEmpty) {
                    if (loading) {
                      return RefreshIndicator(
                        child: _buildRunList(state.runs),
                        onRefresh: () {
                          if (_stopwatchBloc.watch.isRunning) {
                            _stopwatchBloc.add(Start());
                          } else {
                            _stopwatchBloc.add(Reset());
                          }
                          _runBloc.add(GetRunsEvent());
                          return _refreshCompleter.future;
                        }
                      );
                    } else {
                      return _buildRunList(state.runs);
                    }
                  } else {
                    return _buildNoDataView(context);
                  }
                }
                if (state is RunErrorState) {
                  return _buildErrorUi(state.message);
                } else {
                  return Container();
                }
              }
            ),
          )
        )
      ),
    );
  }

  void _showNotificationSnackBar(Map<String, dynamic> message) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 5),
        action: SnackBarAction(
          label: "Fermer",
          textColor: Colors.redAccent,
          onPressed: () => Scaffold.of(context).hideCurrentSnackBar(),
        ),
        content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message['notification']["title"]),
                Text(message['notification']["body"]),
              ],
        ),
      ),
    );
  }
}

Widget _buildNoDataView(BuildContext context) => Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "No runs yet.",
        style: TextStyle(
          fontSize: 30.0,
        ),
      ),
    ],
  ),
);

Widget _buildErrorUi(String message) => Center(
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      message,
      style: TextStyle(color: Colors.red),
    ),
  ),
);

Widget _buildRunList(List<Run> runs) => ListView.builder(
  key: PageStorageKey(runs.length),
  itemCount: runs.length,
  itemBuilder: (context, index) => RunListItem(
    run: runs[index],
  )
);
