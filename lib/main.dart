import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:RuneoDriverFlutter/bloc/authentication/index.dart';
import 'package:RuneoDriverFlutter/bloc/login/index.dart';
import 'package:RuneoDriverFlutter/repository/user_repository.dart';
import 'package:RuneoDriverFlutter/views/login/login_form.dart';

import 'package:RuneoDriverFlutter/views/runs/runs_page.dart';
import 'package:RuneoDriverFlutter/bloc/runs/index.dart';
import 'package:RuneoDriverFlutter/repository/run_repository.dart';
import 'package:RuneoDriverFlutter/bloc/connectivity/index.dart';

import 'package:RuneoDriverFlutter/views/shared/loading_indicator.dart';
import 'package:RuneoDriverFlutter/views/shared/splash_screen.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  initializeDateFormatting("fr_CH");
  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (context) {
        return AuthenticationBloc(userRepository: UserRepositoryImpl())
          ..add(AppLoaded());
      },
      child: MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<RunBloc>(
                  create: (context) => RunBloc(runRepository: RunRepositoryImpl()),
                ),
                BlocProvider<ConnectivityBloc>(
                  create: (context) => ConnectivityBloc(runBloc: BlocProvider.of<RunBloc>(context) )
                ),
              ], 
              child: RunsPage(),
            );
          }
          if (state is AuthenticationUnauthenticated) {
            return BlocProvider(
              create: (context) => LoginBloc(authenticationBloc: BlocProvider.of<AuthenticationBloc>(context), userRepository: UserRepositoryImpl()),
              child: LoginForm(),
            );
          }
          if (state is AuthenticationLoading) {
            return LoadingIndicator();
          }
          return SplashPage();
        }
      ),
    );
  }
}
