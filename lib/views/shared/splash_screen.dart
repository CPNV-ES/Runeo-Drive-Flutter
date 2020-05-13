import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 100.0),
            Text('Runeo Drive', style: TextStyle(fontSize: 40.0)),
            Image.asset(
              'assets/logo.png', 
              height: 150,
              width: 100,
              fit: BoxFit.fitWidth
            ),
          ],
        ),
      ),
    );
  }
}