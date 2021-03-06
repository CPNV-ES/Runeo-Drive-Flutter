import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:RuneoDriverFlutter/bloc/login/index.dart';
import 'package:RuneoDriverFlutter/repository/user_repository.dart';
import 'package:RuneoDriverFlutter/services/firebase_messaging_service.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final UserRepositoryImpl userRepository = UserRepositoryImpl();

  Future<void> _onLoginButtonPressed() async {
    var firebaseToken = await FirebaseMessagingService.instance.getToken();
    if (Platform.isIOS) { FirebaseMessagingService.instance.getIOSPermission(); }
    /// Differentiate between notifications and update runs
    FirebaseMessagingService.instance.firebaseSubscribe("message_to_all");
    FirebaseMessagingService.instance.firebaseSubscribe("update_runs");

    // Scan the QR code
    userRepository.barcodeScanning().then((value) =>
      BlocProvider.of<LoginBloc>(context).add(
        LoginInButtonPressed(
          token: value,
          firebaseToken: firebaseToken
        ),
      ),
    );     
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Authentification"),
        ),
        body: Container(
          child: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginFailure) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                return Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10.0),
                      Column(
                        children: <Widget>[
                          Text('Runeo Drive', style: TextStyle(fontSize: 40.0)),
                          Image.asset(
                            'assets/logo.png', 
                            height: 150,
                            width: 100,
                            fit: BoxFit.fitWidth
                          ),
                          SizedBox(height: 100.0),
                        ],
                      ),
                      FlatButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.black,
                        padding: EdgeInsets.all(20.0),
                        splashColor: Colors.blueAccent,
                        onPressed:
                            state is! LoginLoading ? _onLoginButtonPressed : null,
                        child: Text('Connexion', style: TextStyle(fontSize: 30.0)),
                      ),
                      Container(
                        child: state is LoginLoading
                            ? CircularProgressIndicator()
                            : null,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}