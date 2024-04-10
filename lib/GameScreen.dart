import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class GameSreen extends StatefulWidget {
  String player1;
  String player2;

  GameSreen({required this.player1, required this.player2});
  @override
  State<GameSreen> createState() => _GameSreenState();
}

class _GameSreenState extends State<GameSreen> {
  late List<List<String>> _board;
  late String _currentPlayer;
  late String _winner;
  late bool _gameOver;

  void initState() {
    super.initState();
    _board = List.generate(3, (_) => List.filled(3, ''));
    _currentPlayer = 'X';
    _winner = '';
    _gameOver = false;
  }

  // Reset the game
  void _resetGame() {
    setState(() {
      _board = List.generate(3, (_) => List.filled(3, ''));
      _currentPlayer = 'X';
      _winner = '';
      _gameOver = false;
    });
  }

  void _makeMove(int row, int col) {
    if (_board[row][col] != '' || _gameOver) {
      return;
    }

    setState(() {
      _board[row][col] = _currentPlayer;

      if (_board[row][0] == _currentPlayer &&
          _board[row][1] == _currentPlayer &&
          _board[row][2] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      } else if (_board[0][col] == _currentPlayer &&
          _board[1][col] == _currentPlayer &&
          _board[2][col] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      } else if (_board[0][0] == _currentPlayer &&
          _board[1][1] == _currentPlayer &&
          _board[2][2] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      } else if (_board[0][2] == _currentPlayer &&
          _board[1][1] == _currentPlayer &&
          _board[2][0] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      }

      // switch Player
      _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';

      if (_board.every((row) => row.every((value) => value != ''))) {
        _gameOver = true;
        _winner = 'Draw';
      }
      if (_winner != '') {
        AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.rightSlide,
            btnOkText: "Play Again",
            title: _winner == 'X'
                ? widget.player1 + 'Win'
                : _winner == 'O'
                    ? widget.player2 + 'Win'
                    : 'Draw',
            btnOkOnPress: () {
              _resetGame();
            }).show();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 70),
            SizedBox(
              height: 120,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Turn : ",
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _currentPlayer == 'X'
                            ? widget.player1 + "($_currentPlayer)"
                            : widget.player2 + "($_currentPlayer)",
                        style: TextStyle(
                            fontSize: 30,
                            color: _currentPlayer == 'X'
                                ? Colors.blue
                                : Colors.red,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.all(5),
              child: GridView.builder(
                  itemCount: 9,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    int row = index ~/ 3;
                    int col = index % 3;
                    return GestureDetector(
                        onTap: () => _makeMove(row, col),
                        child: Container(
                            margin: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                _board[row][col],
                                style: TextStyle(
                                  color: _currentPlayer == 'X'
                                      ? Colors.blue
                                      : Colors.red,
                                  fontSize: 120,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )));
                  }),
            )
          ],
        ),
      ),
    );
  }
}
