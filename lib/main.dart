import 'package:flutter/material.dart';
import 'package:newsapp/Pages/MainPage.dart';

void main(){
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: mode?Colors.white:Colors.black,
      ), debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
