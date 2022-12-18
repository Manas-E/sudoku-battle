import 'package:flutter/material.dart';

class NeuMorphismButton extends StatefulWidget {
  final double iconSize, height, width;
  final Widget inner;
  const NeuMorphismButton(
      {Key? key,
      this.iconSize = 20,
      this.height = 100,
      this.width = 100,
      required this.inner})
      : super(key: key);

  @override
  State<NeuMorphismButton> createState() => _NeuMorphismButtonState();
}

class _NeuMorphismButtonState extends State<NeuMorphismButton> {
  bool _isElevated = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isElevated = !_isElevated;
        });
      },
      child: AnimatedContainer(
        child: widget.inner,
        // Providing duration parameter
        // to create animation
        duration: const Duration(
          milliseconds: 200,
        ),
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
            // when _isElevated is false, value
            // of inset parameter will be true
            // that will create depth effect.
            boxShadow: _isElevated
                ?
                // Elevated Effect
                [
                    const BoxShadow(
                      color: Color(0xFFBEBEBE),
                      // Shadow for bottom right corner
                      offset: Offset(10, 10),
                      blurRadius: 30,
                      spreadRadius: 1,
                    ),
                    const BoxShadow(
                      color: Colors.white,
                      // Shadow for top left corner
                      offset: Offset(-10, -10),
                      blurRadius: 30,
                      spreadRadius: 1,
                    ),
                  ]
                :
                // Depth Effect
                null,
            gradient: _isElevated
                ? null
                : LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                        Colors.grey.shade200,
                        Colors.grey.shade200,
                        Colors.grey.shade300,
                        Colors.grey.shade400,
                      ],
                    stops: [
                        0,
                        0.1,
                        0.3,
                        1
                      ])),
      ),
    );
  }
}
