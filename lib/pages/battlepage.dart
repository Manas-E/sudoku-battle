import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudoku_battle/pages/homepage.dart';
import 'package:sudoku_battle/pages/profilepage.dart';

class BattlePage extends StatefulWidget {
  const BattlePage({super.key});

  @override
  State<BattlePage> createState() => _BattlePageState();
}

class _BattlePageState extends State<BattlePage> {
  List<String> displayVal = ['', '', '', '', '', '', '', '', ''];
  bool xTurn = false;
  var scoreStyle = TextStyle(color: Colors.white, fontSize: 30);
  int xScore = 0, oScore = 0;
  int filledBoxes = 0;
  bool isDraw = true;

  var fontStyleS = GoogleFonts.permanentMarker(
      textStyle: TextStyle(color: Colors.white, fontSize: 10));
  var fontStyle = GoogleFonts.permanentMarker(
      textStyle: TextStyle(color: Colors.white, fontSize: 30));
  var fontStyleXl = GoogleFonts.permanentMarker(
      textStyle: TextStyle(color: Colors.white, fontSize: 40));
  var fontStyleBlack = GoogleFonts.pressStart2p(
      textStyle: TextStyle(color: Colors.black, fontSize: 20));

  int _selectedIndex = 0;
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
    if (index == 1)
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
            return MyHomePage();
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
      backgroundColor: Color.fromARGB(255, 243, 103, 101),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.sports_mma),
                label: 'Battle',
                backgroundColor: Color.fromARGB(255, 243, 103, 101)),
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
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
            Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.2,
                  right: screenWidth * 0.2,
                  bottom: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.all(5),
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      'Join a Room',
                      style: fontStyleBlack,
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
                child: Container(
                  padding: EdgeInsets.all(5),
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      'Create a Room',
                      style: fontStyleBlack,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _tapped(int index) {
    setState(() {
      if (xTurn && displayVal[index] == "") {
        displayVal[index] = 'X';
        filledBoxes++;
      } else if (!xTurn && displayVal[index] == "") {
        displayVal[index] = 'O';
        filledBoxes++;
      }
      xTurn = !xTurn;
      _checkWinner();
    });
  }

  void _checkWinner() {
    // check rows

    if (displayVal[0] != '' &&
        displayVal[0] == displayVal[1] &&
        displayVal[0] == displayVal[2]) _winDialog(displayVal[0]);

    if (displayVal[3] != '' &&
        displayVal[3] == displayVal[4] &&
        displayVal[3] == displayVal[5]) _winDialog(displayVal[3]);

    if (displayVal[6] != '' &&
        displayVal[6] == displayVal[7] &&
        displayVal[6] == displayVal[8]) _winDialog(displayVal[6]);

    // check columns

    if (displayVal[0] != '' &&
        displayVal[0] == displayVal[3] &&
        displayVal[0] == displayVal[6]) _winDialog(displayVal[0]);

    if (displayVal[1] != '' &&
        displayVal[1] == displayVal[4] &&
        displayVal[1] == displayVal[7]) _winDialog(displayVal[1]);

    if (displayVal[2] != '' &&
        displayVal[2] == displayVal[5] &&
        displayVal[2] == displayVal[8]) _winDialog(displayVal[2]);

    // check diagonals

    if (displayVal[0] != '' &&
        displayVal[0] == displayVal[4] &&
        displayVal[0] == displayVal[8]) _winDialog(displayVal[0]);

    if (displayVal[2] != '' &&
        displayVal[2] == displayVal[4] &&
        displayVal[2] == displayVal[6]) _winDialog(displayVal[2]);

    if (filledBoxes >= 9 && isDraw) showDrawDialog();
  }

  void _winDialog(String winner) {
    winner == 'O' ? oScore++ : xScore++;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                  child: Text('Play Again'),
                  onPressed: () {
                    resetBoard();
                    Navigator.of(context).pop();
                  })
            ],
            title: Text("Winner is " + winner),
          );
        });
    isDraw = false;
  }

  void showDrawDialog() {
    filledBoxes = 0;

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                  child: Text('Play Again'),
                  onPressed: () {
                    resetBoard();
                    Navigator.of(context).pop();
                  })
            ],
            title: Text("It's a Draw!!"),
          );
        });
  }

  void resetBoard() {
    filledBoxes = 0;

    setState(() {
      displayVal = ['', '', '', '', '', '', '', '', ''];
    });
  }
}
