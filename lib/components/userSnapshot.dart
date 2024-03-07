import 'package:Sudoku_Battle/components/userScore.dart';

class UserSnapshot {
  String? id;
  int matches;

  UserScore? playerA, playerB;

  UserSnapshot({this.id, this.matches = 0, this.playerA, this.playerB}) {}
}
