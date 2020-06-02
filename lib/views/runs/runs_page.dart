import 'dart:async';
import 'dart:io';

import 'package:RuneoDriverFlutter/services/firebase_messaging_service.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart'as timeago;
import 'package:time/time.dart';

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
  Color backgroundColor;
  bool loading = true;
  Completer<void> _refreshCompleter;
  Stopwatch _stopwatch;
  Timer timer;
  DateTime lastRefreshTimer = 0.minutes.fromNow;
  Duration lastRefreshTimeElapse;
  String showLastRefreshTime;

  @override
  void initState() {
    super.initState();
    _runBloc = BlocProvider.of<RunBloc>(context);
    _connectivityBloc = BlocProvider.of<ConnectivityBloc>(context);
    _refreshCompleter = Completer<void>();
    _stopwatch = new Stopwatch();
    timer = Timer.periodic(Duration(milliseconds: 100), (Timer t) => updateTime(lastRefreshTimer));

    /// Listen to connectivity change
    _subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Got a new connectivity status!
      _connectivityBloc.add(GetStatusInfo(result: result));
    });

    /// Listen to push notifications
    FirebaseMessagingService.instance.firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        // add message to event
       _runBloc.add(PushNotificationEvent(message));
      },
    );
  }

  /// Update display text
  void updateTime(DateTime lastRefreshTimer) {
    if (_stopwatch.isRunning) {
      setState(() {
        showLastRefreshTime = timeago.format(lastRefreshTimer, locale: 'fr_short');
      });
    } else {
      setState(() {
        showLastRefreshTime = timeago.format(lastRefreshTimer, locale: 'fr_short');
      });
    }
  }

  /// Start stopwatch and set timer.
  void startWatch() {
    _stopwatch.start();
    setState(() {
      lastRefreshTimeElapse = _stopwatch.elapsed;
      lastRefreshTimer = lastRefreshTimeElapse.fromNow;
    });
    timer = Timer.periodic(Duration(milliseconds: 100), (Timer t) => updateTime(lastRefreshTimer));
  }

  /// Stop and reset stopwatch. Then start a new stopwatch.
  void resetWatch() {
    timer?.cancel();
    timer = null;
    _stopwatch.stop();
    _stopwatch.reset();
    setState(() {
      lastRefreshTimeElapse = Duration.zero;
      showLastRefreshTime = "";
    });
    startWatch();
  }

  @override
  dispose() {
    super.dispose();
    _runBloc.close();
    _connectivityBloc.close();
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
                child: (showLastRefreshTime != null) ? Text(showLastRefreshTime.padLeft(50)) : Text("".padLeft(50)),
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
                if (state is OnMessageState) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 10),
                      action: SnackBarAction(
                        label: "Close",
                        textColor: Colors.redAccent,
                        onPressed: () => Scaffold.of(context).hideCurrentSnackBar(),
                      ),
                      content: Padding(
                        padding: const EdgeInsets.only(bottom: 25.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: < Widget > [
                              Text(state.message['notification']["title"]),
                              Text(state.message['notification']["body"]),
                            ],
                          ),
                      ),
                    )
                  );
                }
              },
              buildWhen: (previous, current) {
                if (current is OfflineState && previous is RunLoadedState) {
                  return false;
                }
                if (current is AddRunnerSuccessState) {
                  return false;
                }
                if (current is OnMessageState) {
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
                          if (_stopwatch.isRunning) {
                            resetWatch();
                          } else {
                            startWatch();
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
  key: PageStorageKey(runs.length),
  itemCount: runs.length,
  itemBuilder: (context, index) => RunListItem(
    run: runs[index],
  )
);
