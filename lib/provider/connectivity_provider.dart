import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:RuneoDriverFlutter/enums/connectivity_status.dart';
import 'package:RuneoDriverFlutter/bloc/connectivity/connectivity_bloc.dart';
import 'package:RuneoDriverFlutter/bloc/connectivity/connectivity_event.dart';

class ConnectivityProvider {
  ConnectivityBloc _connectivityBloc;

  ConnectivityProvider(context) {
    // Subscribe to the connectivity Chanaged Steam
    _connectivityBloc = BlocProvider.of<ConnectivityBloc>(context);
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _connectivityBloc.add(GetStatusInfo(result: _getStatusFromResult(result)));
    });
  }

  // Convert from the third part enum to our own enum
  ConnectivityStatus _getStatusFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        return ConnectivityStatus.Cellular;
      case ConnectivityResult.wifi:
        return ConnectivityStatus.WiFi;
      case ConnectivityResult.none:
        return ConnectivityStatus.Offline;
      default:
        return ConnectivityStatus.Offline;
    }
  }
}