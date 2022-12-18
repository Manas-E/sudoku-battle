import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectableButton extends StatefulWidget {
  const SelectableButton({
    super.key,
    required this.selected,
    this.style,
    required this.onPressed,
    required this.child,
  });

  final bool selected;
  final ButtonStyle? style;
  final VoidCallback? onPressed;
  final Widget child;

  @override
  State<SelectableButton> createState() => _SelectableButtonState();
}

class _SelectableButtonState extends State<SelectableButton> {
  late final MaterialStatesController statesController;

  @override
  void initState() {
    super.initState();
    statesController = MaterialStatesController(
        <MaterialState>{if (widget.selected) MaterialState.selected});
  }

  @override
  void didUpdateWidget(SelectableButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected != oldWidget.selected) {
      statesController.update(MaterialState.selected, widget.selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      statesController: statesController,
      style: widget.style,
      onPressed: widget.onPressed,
      child: widget.child,
    );
  }
}

class Button extends StatefulWidget {
  final String text;

  const Button({super.key, this.text = ""});

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool selected = false;
  var fontStyle = GoogleFonts.roboto(
      textStyle: TextStyle(color: Colors.white, fontSize: 30));
  @override
  Widget build(BuildContext context) {
    return SelectableButton(
      selected: selected,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.white;
            }
            return Colors.white; // defer to the defaults
          },
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(2)),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.blue;
            }
            return Colors.grey.shade900; // defer to the defaults
          },
        ),
      ),
      onPressed: () {
        setState(() {
          selected = !selected;
        });
      },
      child: Text(
        widget.text,
        style: fontStyle,
      ),
    );
  }
}
