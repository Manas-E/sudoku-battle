import 'package:Sudoku_Battle/utils/utils.dart';
import 'package:flutter/material.dart';

class NumberButton extends StatefulWidget {
  final double iconSize, height, width;
  final Widget inner;
  const NumberButton(
      {Key? key,
      this.iconSize = 20,
      this.height = 100,
      this.width = 100,
      required this.inner})
      : super(key: key);

  @override
  State<NumberButton> createState() => _NumberButtonState();
}

class _NumberButtonState extends State<NumberButton> with Util {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
      },
      child: AnimatedContainer(
        height: 50,
        margin: EdgeInsets.only(left: 15),
        duration: Duration(seconds: 1),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.blue,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16.0),
                textStyle: const TextStyle(fontSize: 20),
                backgroundColor:
                    _isSelected ? Colors.blue : Colors.grey.shade900),
            child: Text(
              "1",
            ),
          ),
        ),
      ),
    );
  }
}
