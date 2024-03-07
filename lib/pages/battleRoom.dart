import 'dart:convert';

import 'package:Sudoku_Battle/components/userScore.dart';
import 'package:Sudoku_Battle/pages/gameRoom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_string/random_string.dart';
import 'package:Sudoku_Battle/components/userScore.dart';
import 'package:Sudoku_Battle/pages/battleRoom.dart';
import 'package:Sudoku_Battle/pages/homepage.dart';
import 'package:Sudoku_Battle/pages/profilepage.dart';

class BattleRoom extends StatefulWidget {
  BattleRoom({super.key, required this.newPlayer, this.roomCode: ""});
  UserScore newPlayer;
  String roomCode;
  @override
  State<BattleRoom> createState() => _BattleRoomState();
}

class _BattleRoomState extends State<BattleRoom> {
  FirebaseDatabase database = FirebaseDatabase.instance;

  String code = "", playerName = "playerA";
  var fontStyleS = GoogleFonts.permanentMarker(
      textStyle: TextStyle(color: Colors.white, fontSize: 18));
  var fontStyle = GoogleFonts.permanentMarker(
      textStyle: TextStyle(color: Colors.white, fontSize: 30));
  var fontStyleXl = GoogleFonts.permanentMarker(
      textStyle: TextStyle(color: Colors.white, fontSize: 40));
  var fontStyleScore = GoogleFonts.pressStart2p(
      textStyle: TextStyle(height: 1.5, color: Colors.white, fontSize: 40));

  static const READY_TEXT = "Ready";
  static const NOT_READY_TEXT = "Not Ready ";
  static const STATUS_ACTIVE = "Active 🟢";
  static const STATUS_NOT_ACTIVE = "Inactive 🔴";
  bool isReady = false, gameReady = false, gameStarted = false;

  List playerList = [];
  @override
  void initState() {
    print(widget.roomCode);

    if (widget.roomCode != "" && widget.newPlayer.name != null) {
      print("====================");
      print(widget.newPlayer.name);
      joinRoom(widget.roomCode, widget.newPlayer);
      listener(widget.roomCode);
    }

    if (widget.roomCode == "" || widget.roomCode == null) {
      print(widget.newPlayer.name);
      createRoom(widget.newPlayer);
    }
    super.initState();
  }

  TextEditingController _textFieldController = TextEditingController();
  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Join a Room',
              style: fontStyle,
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

  Widget getData({type, index}) {
    if (playerList != null && playerList.length > index)
      switch (type) {
        case 'name':
          if (playerList[index]['name'] != null)
            return Text(
              playerList[index]['name'].toString(),
              style: fontStyle,
              textAlign: TextAlign.center,
            );
          break;
        case 'status':
          if (playerList[index]['active'] != null)
            return Text(
              playerList[index]['active'] == true
                  ? STATUS_ACTIVE
                  : STATUS_NOT_ACTIVE,
              style: fontStyleS,
              textAlign: TextAlign.center,
            );
          break;
        case 'wins':
          if (playerList[index]['wins'] != null)
            return Text(
              playerList[index]['wins'].toString(),
              style: fontStyleScore,
              textAlign: TextAlign.center,
            );
          break;
        default:
          return Text(
            '',
            style: fontStyle,
            textAlign: TextAlign.center,
          );
      }

    return Text(
      '',
      style: fontStyle,
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return gameStarted
        ? GameRoom(
            playerList: playerList,
            code: widget.roomCode != "" ? widget.roomCode : code,
            name: playerName)
        : Scaffold(
            backgroundColor: Color.fromARGB(255, 243, 103, 101),
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: screenHeight * 0.3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.only(bottom: screenHeight * 0.1),
                            child: Text("Lobby Area", style: fontStyleXl)),
                        Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: code == ''
                                  ? []
                                  : [
                                      Text("Code : ${code} ", style: fontStyle),
                                      GestureDetector(
                                          onTap: () {
                                            _shareLink(code);
                                          },
                                          child: Icon(
                                            Icons.share,
                                            color: Colors.white,
                                          ))
                                    ],
                            )),
                        GridView.count(
                          crossAxisCount: 2,
                          primary: false,
                          padding: const EdgeInsets.only(left: 30, top: 30),
                          childAspectRatio: 2.5,
                          crossAxisSpacing: 10,
                          shrinkWrap: true,
                          mainAxisSpacing: 5,
                          children: [
                            getData(type: 'name', index: 0),
                            getData(type: 'name', index: 1),
                            getData(type: 'status', index: 0),
                            getData(type: 'status', index: 1),
                            getData(type: 'wins', index: 0),
                            getData(type: 'wins', index: 1),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (gameReady)
                        setState(() {
                          gameStarted = true;
                          print('//// ${code}');
                        });
                      else
                        setState(() {
                          isReady = !isReady;
                          toggleStatus(code, playerName, isReady);
                        });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: screenWidth * 0.2,
                          right: screenWidth * 0.2,
                          bottom: 15),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          color: isReady
                              ? Colors.grey.shade900
                              : Color.fromARGB(255, 65, 252, 72),
                          child: Center(
                            child: Container(
                              alignment: Alignment.center,
                              height: 80,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Text(
                                isReady
                                    ? gameReady
                                        ? 'Start Game'
                                        : NOT_READY_TEXT
                                    : READY_TEXT,
                                style: fontStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
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

  _shareLink(String link) {
    FlutterShare.share(title: 'Share Room Code', text: '${link}');
  }

  createRoom(UserScore playerA) async {
    String _id = randomAlpha(6);
    print("logged: ${_id}");
    DatabaseReference room = FirebaseDatabase.instance.ref("rooms/${_id}");

    await room.set({
      "id": "${_id}",
      "playerA": {
        "name": playerA.name,
        "score": playerA.score,
        "wins": playerA.wins,
        "active": playerA.status,
        "mistakes": playerA.mistakes,
      },
      "matches": 0,
      "gameStarted": false,
    }).then((value) {
      print("created");
      listener(_id);
      setState(() {
        code = _id;
        playerName = "playerA";
      });
    });
  }

  joinRoom(code, UserScore playerB) async {
    DatabaseReference room =
        FirebaseDatabase.instance.ref("rooms/${code}/playerB");
    print(code);
    print("***********");
    setState(() {
      playerName = "playerB";
      code = code;
    });
    await room.update({
      "name": playerB.name,
      "score": playerB.score,
      "wins": playerB.wins,
      "active": playerB.status,
      "mistakes": playerB.mistakes,
    }).then((value) => print("login"));
  }

  toggleStatus(String code, String name, state) async {
    DatabaseReference room = name == 'playerB'
        ? FirebaseDatabase.instance.ref("rooms/${widget.roomCode}/${name}")
        : FirebaseDatabase.instance.ref("rooms/${code}/${name}");

    await room.update({"active": state}).then((value) => print("toggle"));
  }

  update(String code, String name, String type, int value) async {
    DatabaseReference room =
        FirebaseDatabase.instance.ref("rooms/${code}/${name}");
    switch (type) {
      case 'mistakes':
        await room.update({"mistakes": value}).then(
            (value) => print("mistakes updated"));
        break;
      case 'score':
        await room
            .update({"score": value}).then((value) => print("score updated"));
        break;
    }
  }

  listener(code) {
    print("==");
    print(code);
    DatabaseReference roomRef = FirebaseDatabase.instance.ref('rooms/${code}');
    roomRef.onValue.listen((DatabaseEvent event) {
      var a = [];
      var data = event.snapshot.children.forEach((element) {
        a.add(element.value);
      });

      setState(() {
        if (a.length < 5) {
          playerList = [a[3]];
        } else {
          playerList = [a[3], a[4]];
          if (a[3]['active'] && a[4]['active']) gameReady = true;
        }
      });
      print(">>");
      print(a);
      print(a[1]);
    });
  }
}
