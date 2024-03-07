import 'package:Sudoku_Battle/pages/homepage.dart';
import 'package:Sudoku_Battle/pages/profilepage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  List<String> displayVal = ['', '', '', '', '', '', '', '', ''];
  bool xTurn = false;
  var scoreStyle = TextStyle(color: Colors.white, fontSize: 30);
  int xScore = 0, oScore = 0;
  int filledBoxes = 0;
  bool isDraw = true;

  var fontStyleS = GoogleFonts.permanentMarker(
      textStyle: TextStyle(color: Colors.white, fontSize: 20));
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
      backgroundColor: Color.fromARGB(255, 91, 173, 240),
      resizeToAvoidBottomInset: false,
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
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 40),
                child: Container(child: Text("Stats", style: fontStyleXl)),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(child: Text("Total Wins : 11", style: fontStyleS)),
                  Container(child: Text("Total Losses : 1", style: fontStyleS)),
                  Container(
                      child: Text("Total Matches : 12", style: fontStyleS)),
                ],
              ),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text("Training Stats", style: fontStyle)),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(child: Text("Easy : 1:10", style: fontStyleS)),
                  Container(child: Text("Medium : 2:10", style: fontStyleS)),
                  Container(child: Text("Hard : 3:10", style: fontStyleS)),
                ],
              ),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text("Battle Stats", style: fontStyle)),
              Container(child: Text("Best time : ", style: fontStyleS)),
              Column(
                children: [
                  Container(
                      padding: EdgeInsets.only(
                          left: screenWidth * 0.15,
                          top: screenHeight * 0.1,
                          right: screenWidth * 0.15,
                          bottom: 10),
                      child: Text("You are in the top 1% of all the players",
                          textAlign: TextAlign.center, style: fontStyleS)),
                  Icon(Icons.share, color: Colors.white),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
