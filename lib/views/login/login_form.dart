import 'package:RuneoDriverFlutter/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:RuneoDriverFlutter/bloc/login/index.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final UserRepositoryImpl userRepository = UserRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    _onLoginButtonPressed() {
      //final barcodeToken = userRepository.barcodeScanning();
      //print(barcodeToken);
      BlocProvider.of<LoginBloc>(context).add(
        LoginInButtonPressed(
          token: "VA5PuxHGSYy5FnqX5enz1HUa9DtuQCQNyIl5LTxk5oViPEmGnQIo0Ef3qB1B",
        ),
      );
    }
    return Center(
      child: Scaffold(
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
                      FlatButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.black,
                        padding: EdgeInsets.all(20.0),
                        splashColor: Colors.blueAccent,
                        onPressed:
                            state is! LoginLoading ? _onLoginButtonPressed : null,
                        child: Text('Login', style: TextStyle(fontSize: 30.0)),
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