import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          home: SafeArea(
            child: Container(
              child: Column(
                children: [
                  Flexible(
                      flex: 1,
                      child: Image.asset(
                        "assets/images/logo.png",
                        width: 150,
                        height: 150,
                      )),
                ],
              ),
            ),
          ),
        );
  }
}
