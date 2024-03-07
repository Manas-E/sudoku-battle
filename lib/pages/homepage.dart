import 'package:Sudoku_Battle/pages/battlepage.dart';
import 'package:Sudoku_Battle/pages/profilepage.dart';
import 'package:Sudoku_Battle/pages/sudoku.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'loggedInWidget.dart';
import 'loginRegisterPage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
        PageRouteBuilder(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return Align(
              child: SizeTransition(
                sizeFactor: animation,
                child: child,
                axisAlignment: 0.0,
              ),
            );
          },
          transitionDuration: Duration(seconds: 1),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return BattlePage();
          },
        ),
      );

    if (index == 2)
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return Align(
              child: SizeTransition(
                sizeFactor: animation,
                child: child,
                axisAlignment: 0.0,
              ),
            );
          },
          transitionDuration: Duration(seconds: 1),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return ProfilePage();
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.grey[900],
        bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.sports_mma),
                  label: 'Battle',
                  backgroundColor: Color.fromARGB(255, 243, 103, 101)),
              BottomNavigationBarItem(
                  icon: Icon(Icons.fitness_center),
                  label: 'Train',
                  backgroundColor: Color.fromARGB(255, 48, 48, 48)),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
                backgroundColor: Color.fromARGB(255, 91, 173, 240),
              ),
            ],
            type: BottomNavigationBarType.shifting,
            currentIndex: _selectedIndex,
            selectedItemColor: Color.fromARGB(255, 255, 255, 255),
            selectedFontSize: 15,
            iconSize: 40,
            onTap: _onItemTapped,
            elevation: 5),
        body: Center(
            child: Column(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Text("Sudoku\n\nBattle", style: fontStyle),
            )),
            Expanded(
              flex: 2,
              child: Container(
                  child: Image.asset("lib/public/train.gif",
                      width: screenWidth * 0.7, height: screenHeight * 0.7)),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return Align(
                        child: SizeTransition(
                          sizeFactor: animation,
                          child: child,
                          axisAlignment: 0.0,
                        ),
                      );
                    },
                    transitionDuration: Duration(seconds: 1),
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return ProfilePage();
                    },
                  ),
                );
              },
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: screenWidth * 0.2,
                        right: screenWidth * 0.2,
                        bottom: 15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: GestureDetector(
                        onTap: () {
                          navigateToSudoku("Easy");
                        },
                        child: Container(
                          padding: EdgeInsets.all(20),
                          color: Colors.white,
                          child: Center(
                            child: Text(
                              'Easy',
                              style: fontStyleBlack,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: screenWidth * 0.2,
                        right: screenWidth * 0.2,
                        bottom: 15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: GestureDetector(
                        onTap: () {
                          navigateToSudoku("Medium");
                        },
                        child: Container(
                          padding: EdgeInsets.all(20),
                          color: Colors.white,
                          child: Center(
                            child: Text(
                              'Medium',
                              style: fontStyleBlack,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: screenWidth * 0.2,
                        right: screenWidth * 0.2,
                        bottom: 30),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: GestureDetector(
                        onTap: () {
                          navigateToSudoku("Hard");
                        },
                        child: Container(
                          padding: EdgeInsets.all(20),
                          color: Colors.white,
                          child: Center(
                            child: Text(
                              'Hard',
                              style: fontStyleBlack,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )));
  }

  navigateToSudoku(difficulty) {
    return Navigator.push(
      context,
      PageRouteBuilder(
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return Align(
            child: SizeTransition(
              sizeFactor: animation,
              child: child,
              axisAlignment: 0.0,
            ),
          );
        },
        transitionDuration: Duration(seconds: 2),
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return SudokuPage(difficulty: difficulty);
        },
      ),
    );
  }
}
