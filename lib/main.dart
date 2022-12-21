import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_battle/pages/GoogleSignInProvider.dart';
import 'package:sudoku_battle/pages/battlepage.dart';
import 'package:sudoku_battle/pages/homepage.dart';
import 'package:sudoku_battle/pages/neu.dart';
import 'package:sudoku_battle/pages/profilepage.dart';
import 'package:sudoku_battle/pages/sudoku.dart';
import 'package:sudoku_battle/pages/loginRegisterPage.dart';
import 'package:sudoku_battle/pages/profilepage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'Authentication Page';
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => GoogleSignInProvider(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(primarySwatch: Colors.cyan),
      home: loginRegisterPage(),
    ),
  );
}

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  var fontStyleS = GoogleFonts.pressStart2p(
      textStyle: TextStyle(color: Colors.white, fontSize: 10));
  var fontStyle = GoogleFonts.pressStart2p(
      textStyle: TextStyle(color: Colors.white, fontSize: 25));
  var fontStyleXl = GoogleFonts.pressStart2p(
      textStyle: TextStyle(color: Colors.white, fontSize: 40));
  var fontStyleBlack = GoogleFonts.pressStart2p(
      textStyle: TextStyle(color: Colors.black, fontSize: 20));

  int _selectedIndex = 1;
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Search Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Profile Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BattlePage()),
      );

    if (index == 2)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Widget inner = Icon(
      Icons.filter_1,
      semanticLabel: "label",
      textDirection: TextDirection.ltr,
      size: 100,
      // Changing icon color on
      // the basis of it's elevation
      color: Color.fromARGB(255, 255, 255, 255),
    );
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.grey[900],
            body: Navigator(
              onGenerateRoute: (settings) {

                Widget page = BattlePage();

                // switch (_selectedIndex) {
                //   case 0:
                //     page = BattlePage();
                //     break;
                //   case 1:
                //     page = MyHomePage();
                //     break;
                //   case 2:
                //     page = ProfilePage();
                //     break;
                // }
                return MaterialPageRoute(builder: (_) => page);
              },
            )));
  }
}
