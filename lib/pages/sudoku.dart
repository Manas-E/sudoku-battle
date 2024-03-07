import 'dart:async';
import 'dart:math';

import 'package:Sudoku_Battle/components/blokChar.dart';
import 'package:Sudoku_Battle/components/boxInner.dart';
import 'package:Sudoku_Battle/components/focusClass.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiver/iterables.dart';
import 'package:sudoku_solver_generator/sudoku_solver_generator.dart';

class SudokuPage extends StatefulWidget {
  final String difficulty;

  const SudokuPage({super.key, required this.difficulty});

  @override
  State<SudokuPage> createState() => _SudokuPageState();
}

class _SudokuPageState extends State<SudokuPage> {
  List<String> displayVal = ['', '', '', '', '', '', '', '', ''];
  bool xTurn = false;
  var scoreStyle = TextStyle(color: Colors.white, fontSize: 30);
  int xScore = 0, oScore = 0;
  int filledBoxes = 0;
  bool isDraw = true;
  var levels = ["Easy", "Medium", "Hard"];
  var levelMatrix = {
    "Easy": 30,
    "Medium": 39,
    "Hard": 43,
  };
  int emptySquares = 3;
  int mistakeCounter = 0, totalMistakes = 3;
  int hintCounter = 10;
  int scoreCounter = 0;
  int score = 0;
  int tilesToSolve = 0;
  late Timer timer;
  String defeatTitleMessage = "You Lost bro";
  String winTitleMessage = "Woo hoo you won!!";

  bool _isSelected = false;
  bool hintPopup = false;

  var fontStyleS = GoogleFonts.pressStart2p(
      textStyle: TextStyle(color: Colors.white, fontSize: 13));
  var fontStyle = GoogleFonts.pressStart2p(
      textStyle: TextStyle(color: Colors.white, fontSize: 30));
  var fontStyleXl = GoogleFonts.pressStart2p(
      textStyle: TextStyle(color: Colors.white, fontSize: 40));

  var fontStyleHeader = GoogleFonts.roboto(
      textStyle: TextStyle(color: Colors.grey[700], fontSize: 20));

  var fontStyleActions = GoogleFonts.roboto(
      textStyle: TextStyle(color: Colors.grey[700], fontSize: 15));

  var fontStyleBlack = GoogleFonts.anton(
      textStyle: TextStyle(color: Colors.black, fontSize: 20));

  var fontStyleNumber = GoogleFonts.roboto(
      textStyle: TextStyle(color: Colors.white, fontSize: 20));

  var fontStyleTabs = GoogleFonts.pressStart2p(
      textStyle: TextStyle(color: Colors.white, fontSize: 15));

  int seconds = 0, minutes = 0, hours = 0;

  List<BoxInner> boxInners = [];
  FocusClass focusClass = FocusClass();
  bool isFinish = false;
  String? tapBoxIndex;

  @override
  void initState() {
    switch (widget.difficulty) {
      case "Easy":
        setState(() {
          emptySquares = 30;
        });
        break;

      case "Medium":
        setState(() {
          emptySquares = 39;
        });
        break;

      case "Hard":
        setState(() {
          emptySquares = 43;
        });
        break;
    }
    generateSudoku();

    // TODO: implement initState
    super.initState();
  }

  void generateSudoku() {
    isFinish = false;
    focusClass = new FocusClass();
    tapBoxIndex = null;
    generatePuzzle();
    checkFinish();

    setState(() {
      mistakeCounter = 0;
    });

    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      int localSec = seconds + 1;
      int localMin = minutes;
      int localHours = hours;

      if (localSec > 59) {
        if (localMin > 59) {
          localMin = 0;
          localHours++;
        }
        localMin++;
        localSec = 0;
      }

      setState(() {
        seconds = localSec;
        minutes = localMin;
        hours = localHours;
      });
    });
  }

  void resetTimer() {
    timer!.cancel();

    setState(() {
      seconds = 0;
      minutes = 0;
    });
  }

  String _simpleDialogResult = "";
  String _alertDialogResult = "";
  String _cupertinoAlertDialogResult = "";
  String _dialogResult = "";
  String _overlayResult = "";
  String _toastResult = "";

  final TextStyle _defaultTextStyle = const TextStyle(
      decoration: TextDecoration.none,
      color: Colors.white,
      fontSize: 14,
      fontFamily: "Roboto",
      fontVariations: [],
      fontStyle: FontStyle.normal);

  void _showToast() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.horizontal,
        duration: const Duration(seconds: 3),
        onVisible: () {
          setState(() {
            _toastResult = "Toast is visible!";
          });
        },
        padding: const EdgeInsets.all(16),
        content: Row(children: [
          Text("You don't have any hints", style: _defaultTextStyle),
          const Spacer(),
        ])));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    var _difficultyMode = widget.difficulty;
    // if (hintPopup)
    //   return AlertDialog(
    //     title: Text("Hint got",
    //         textAlign: TextAlign.center, style: fontStyleBlack),
    //     contentPadding: EdgeInsets.all(0),
    //     titlePadding: EdgeInsets.all(10),
    //     actionsPadding: EdgeInsets.all(0),
    //     buttonPadding: EdgeInsets.all(0),
    //     content: Container(
    //         padding: EdgeInsets.all(0),
    //         child: Image.asset("lib/public/defeat.gif",
    //             width: screenWidth * 0.5, height: screenHeight * 0.25)),
    //     actions: <Widget>[
    //       TextButton(
    //         child: const Text('Try again', style: TextStyle(fontSize: 20)),
    //         onPressed: () {
    //           generateSudoku();
    //         },
    //       ),
    //     ],
    //   );

    if (mistakeCounter >= totalMistakes) {
      return AlertDialog(
        title: Text(defeatTitleMessage,
            textAlign: TextAlign.center, style: fontStyleBlack),
        contentPadding: EdgeInsets.all(0),
        titlePadding: EdgeInsets.all(10),
        actionsPadding: EdgeInsets.all(0),
        buttonPadding: EdgeInsets.all(0),
        content: Container(
            padding: EdgeInsets.all(0),
            child: Image.asset("lib/public/defeat.gif",
                width: screenWidth * 0.5, height: screenHeight * 0.25)),
        actions: <Widget>[
          TextButton(
            child: const Text('Try again', style: TextStyle(fontSize: 20)),
            onPressed: () {
              resetTimer();
              generateSudoku();
            },
          ),
        ],
      );
    }

    if (isFinish)
      return AlertDialog(
        title: Text(winTitleMessage,
            textAlign: TextAlign.center, style: fontStyleBlack),
        contentPadding: EdgeInsets.all(0),
        titlePadding: EdgeInsets.all(10),
        actionsPadding: EdgeInsets.all(10),
        buttonPadding: EdgeInsets.all(0),
        content: Container(
            padding: EdgeInsets.all(0),
            child: Image.asset("lib/public/victory.gif",
                width: screenWidth * 0.5, height: screenHeight * 0.25)),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: <Widget>[
          TextButton(
            child: const Text('Restart', style: TextStyle(fontSize: 20)),
            onPressed: () {
              resetTimer();
              generateSudoku();
            },
          ),
          TextButton(
            child:
                const Text('Raise difficulty', style: TextStyle(fontSize: 20)),
            onPressed: () {
              generateSudoku();
            },
          ),
        ],
      );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Container(child: Text("Sudoku", style: fontStyle)),
          ),
          Container(
            height: 80,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: GridView.count(
                crossAxisCount: 4,
                primary: false,
                padding: const EdgeInsets.only(left: 30),
                childAspectRatio: 2.5,
                crossAxisSpacing: 10,
                shrinkWrap: true,
                mainAxisSpacing: 5,
                children: [
                  Container(
                      alignment: Alignment.topCenter,
                      child: Text('Difficulty', style: fontStyleHeader)),
                  Container(
                      alignment: Alignment.topCenter,
                      child: Text('Mistakes', style: fontStyleHeader)),
                  Container(
                      alignment: Alignment.topCenter,
                      child: Text('Score', style: fontStyleHeader)),
                  Container(
                      alignment: Alignment.topCenter,
                      child: Text('Time', style: fontStyleHeader)),
                  Container(
                      alignment: Alignment.topCenter,
                      child: Text(_difficultyMode, style: fontStyleS)),
                  Container(
                    alignment: Alignment.topCenter,
                    child: Text(
                        (mistakeCounter.toString() +
                            "/" +
                            totalMistakes.toString()),
                        style: fontStyleTabs),
                  ),
                  Container(
                      alignment: Alignment.topCenter,
                      child: Text((scoreCounter * 100).toString(),
                          style: fontStyleTabs)),
                  Container(
                      alignment: Alignment.topCenter,
                      child: (hours > 0
                          ? Text('${hours}:${minutes}:${seconds}',
                              style: fontStyleTabs)
                          : Text('${minutes}:${seconds}',
                              style: fontStyleTabs))),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.black,
            padding: EdgeInsets.only(top: 0),
            child: GridView.builder(
              itemCount: boxInners.length,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.9,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (buildContext, index) {
                BoxInner boxInner = boxInners[index];

                return Container(
                  color: Colors.grey.shade700,
                  alignment: Alignment.center,
                  child: GridView.builder(
                    itemCount: boxInner.blokChars.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.9,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (buildContext, indexChar) {
                      BlokChar blokChar = boxInner.blokChars[indexChar];
                      Color color = Colors.grey.shade900;
                      Color colorText = Colors.white;

                      // change color base condition
                      if (isFinish)
                        color = Colors.green;
                      else if (blokChar.isFocus && blokChar.text != "")
                        color = Colors.grey.shade800;
                      else if (blokChar.isDefault) color = Colors.grey.shade900;

                      if (tapBoxIndex == "${index}-${indexChar}" && !isFinish)
                        color = Colors.grey.shade600;

                      if (this.isFinish)
                        colorText = Colors.white;
                      else if (blokChar.isExist) {
                        colorText = Colors.red;
                      }

                      return Container(
                        color: color,
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: blokChar.isDefault
                              ? null
                              : () => setFocus(index, indexChar),
                          child: Text(
                            "${blokChar.text}",
                            style: TextStyle(color: colorText, fontSize: 30),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    height: 60,
                    child: InkWell(
                        onTap: () {
                          resetTimer();
                          generateSudoku();
                        },
                        radius: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.refresh, color: Colors.white),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text("Restart", style: fontStyleActions),
                            )
                          ],
                        )),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 60,
                    child: InkWell(
                        onTap: () {
                          setInput(null);
                        },
                        radius: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.auto_fix_normal, color: Colors.white),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text("Erase", style: fontStyleActions),
                            )
                          ],
                        )),
                  ),
                ),
                // Expanded(
                //   child: Container(
                //     height: 60,
                //     child: InkWell(
                //         onTap: () {},
                //         radius: 150,
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //           children: [
                //             Icon(Icons.edit_note, color: Colors.white),
                //             Padding(
                //               padding: const EdgeInsets.only(top: 5),
                //               child: Text("Note", style: fontStyleActions),
                //             )
                //           ],
                //         )),
                //   ),
                // ),
                Expanded(
                  child: Container(
                      height: 60,
                      child: InkWell(
                          onTap: () {
                            if (hintCounter > 0) {
                              int a = int.parse(getHint());
                              setInput(a);
                              setState(() {
                                hintCounter -= 1;
                              });
                            } else {
                              _showToast();
                            }
                          },
                          radius: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.tungsten, color: Colors.white),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text("Hint", style: fontStyleActions),
                              )
                            ],
                          ))),
                ),
              ],
            ),
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (var i = 1; i < 10; i++)
                InkWell(
                  onTap: () {
                    setInput(i);
                  },
                  radius: 30,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  highlightColor: Colors.blue,
                  child: AnimatedContainer(
                    duration: Duration(seconds: 2),
                    padding: EdgeInsets.only(left: 0, right: 0),
                    child: Text('${i}',
                        style: GoogleFonts.pressStart2p(
                            textStyle: TextStyle(
                                color: _isSelected ? Colors.blue : Colors.white,
                                fontSize: 30))),
                    curve: Curves.easeInOutCirc,
                  ),
                ),
            ],
          )),
        ],
      ),
    );
  }

  generatePuzzle() {
    // install plugins sudoku generator to generate one
    boxInners.clear();
    var sudokuGenerator = SudokuGenerator(emptySquares: emptySquares); //54
    // then we populate to get a possible cmbination
    // Quiver for easy populate collection using partition
    List<List<List<int>>> completes = partition(sudokuGenerator.newSudokuSolved,
            sqrt(sudokuGenerator.newSudoku.length).toInt())
        .toList();
    partition(sudokuGenerator.newSudoku,
            sqrt(sudokuGenerator.newSudoku.length).toInt())
        .toList()
        .asMap()
        .entries
        .forEach(
      (entry) {
        List<int> tempListCompletes =
            completes[entry.key].expand((element) => element).toList();
        List<int> tempList = entry.value.expand((element) => element).toList();

        tempList.asMap().entries.forEach((entryIn) {
          int index =
              entry.key * sqrt(sudokuGenerator.newSudoku.length).toInt() +
                  (entryIn.key % 9).toInt() ~/ 3;

          if (boxInners.where((element) => element.index == index).length ==
              0) {
            boxInners.add(BoxInner(index, []));
          }

          BoxInner boxInner =
              boxInners.where((element) => element.index == index).first;

          boxInner.blokChars.add(BlokChar(
            entryIn.value == 0 ? "" : entryIn.value.toString(),
            index: boxInner.blokChars.length,
            isDefault: entryIn.value != 0,
            isCorrect: entryIn.value != 0,
            correctText: tempListCompletes[entryIn.key].toString(),
          ));

          print(boxInners);
        });
      },
    );

    // complte generate puzzle sudoku
  }

  setFocus(int index, int indexChar) {
    tapBoxIndex = "$index-$indexChar";
    focusClass.setData(index, indexChar);
    showFocusCenterLine();
    setState(() {});
  }

  void showFocusCenterLine() {
    // set focus color for line vertical & horizontal
    int rowNoBox = focusClass.indexBox! ~/ 3;
    int colNoBox = focusClass.indexBox! % 3;

    this.boxInners.forEach((element) => element.clearFocus());

    boxInners.where((element) => element.index ~/ 3 == rowNoBox).forEach(
        (e) => e.setFocus(focusClass.indexChar!, Direction.Horizontal));

    boxInners
        .where((element) => element.index % 3 == colNoBox)
        .forEach((e) => e.setFocus(focusClass.indexChar!, Direction.Vertical));
  }

  setInput(int? number) {
    // set input data based grid
    // or clear out data
    if (focusClass.indexBox == null) return;
    if (boxInners[focusClass.indexBox!].blokChars[focusClass.indexChar!].text ==
            number.toString() ||
        number == null) {
      boxInners.forEach((element) {
        element.clearFocus();
        element.clearExist();
      });
      boxInners[focusClass.indexBox!]
          .blokChars[focusClass.indexChar!]
          .setEmpty();
      tapBoxIndex = null;
      isFinish = false;
      showSameInputOnSameLine();
    } else {
      boxInners[focusClass.indexBox!]
          .blokChars[focusClass.indexChar!]
          .setText("$number");

      showSameInputOnSameLine();

      checkFinish();

      if (!boxInners[focusClass.indexBox!]
          .blokChars[focusClass.indexChar!]
          .isCorrectPos)
        setState(() {
          mistakeCounter = mistakeCounter + 1;
        });
      else
        setState(() {
          scoreCounter += 1;
        });
    }

    setState(() {});
  }

  void showSameInputOnSameLine() {
    // show duplicate number on same line vertical & horizontal so player know he or she put a wrong value on somewhere

    int rowNoBox = focusClass.indexBox! ~/ 3;
    int colNoBox = focusClass.indexBox! % 3;

    String textInput =
        boxInners[focusClass.indexBox!].blokChars[focusClass.indexChar!].text!;

    boxInners.forEach((element) => element.clearExist());

    boxInners.where((element) => element.index ~/ 3 == rowNoBox).forEach((e) =>
        e.setExistValue(focusClass.indexChar!, focusClass.indexBox!, textInput,
            Direction.Horizontal));

    boxInners.where((element) => element.index % 3 == colNoBox).forEach((e) =>
        e.setExistValue(focusClass.indexChar!, focusClass.indexBox!, textInput,
            Direction.Vertical));

    List<BlokChar> exists = boxInners
        .map((element) => element.blokChars)
        .expand((element) => element)
        .where((element) => element.isExist)
        .toList();

    if (exists.length == 1) exists[0].isExist = false;
  }

  void checkFinish() {
    int totalUnfinish = boxInners
        .map((e) => e.blokChars)
        .expand((element) => element)
        .where((element) => !element.isCorrect)
        .length;

    isFinish = totalUnfinish == 0;
  }

  getHint() {
    var hint = boxInners[focusClass.indexBox!]
        .blokChars[focusClass.indexChar!]
        .correctText;
    return hint;
  }
}
