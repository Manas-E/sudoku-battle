import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudoku_battle/pages/homepage.dart';
import 'package:sudoku_battle/pages/profilepage.dart';
import 'package:sudoku_battle/pages/sudoku.dart';

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
      textStyle: TextStyle(height: 1.5, color: Colors.black, fontSize: 20));

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

  TextEditingController _textFieldController = TextEditingController();
  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Join a Room',
              style: fontStyleBlack,
            ),
            content: TextField(
              onChanged: (value) {
                setState(() {});
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Enter Room Code"),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 103, 101),
      resizeToAvoidBottomInset: false,
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
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              Container(
                  child: Image.asset("lib/public/battle3.gif",
                      width: screenWidth * 0.4, height: screenHeight * 0.5)),
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
                      child: GestureDetector(
                        onTap: () {
                          _displayTextInputDialog(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 80,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Text(
                            'Join a Room',
                            style: fontStyleBlack,
                            textAlign: TextAlign.center,
                          ),
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
                  child: Container(
                    padding: EdgeInsets.all(5),
                    color: Colors.white,
                    child: Center(
                      child: Container(
                        alignment: Alignment.center,
                        height: 80,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Text(
                          'Create a Room',
                          style: fontStyleBlack,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
