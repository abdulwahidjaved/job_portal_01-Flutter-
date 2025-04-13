import 'package:flutter/material.dart';
import 'package:job_portal_01/home_pagePC.dart';
import 'package:job_portal_01/homepage_mobile.dart';

void main() {
  runApp(const MainPage());
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 1200) {
            //Laptop
            return HomePagePC();
          } else if (constraints.maxWidth > 800) {
            //Tablet
            return HomePagePC();
          } else {
            //Mobile
            return HomePageMobile();
          }
        },
      ),
    );
  }
}
