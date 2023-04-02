import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _createSplash(context),
    );
  }

  Widget _createSplash(BuildContext context) {
    _quitSplash().then((value) {
      Navigator.popAndPushNamed(context, 'music_home');
    });

    return Container(
      color: const Color.fromRGBO(112, 169, 161, 1)
    );

  }

  Future<bool> _quitSplash() async {
    return Future.delayed(const Duration(milliseconds: 3000))
        .then((onValue) => true);
  }

}