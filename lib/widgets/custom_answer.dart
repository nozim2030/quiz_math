import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnswerOptionButton extends StatefulWidget {
  final String option;
  final String correctAnswer;
  final String? selectedAnswer; // tanlangan variant
  final bool isAnswered;
  final bool isEnabled;
  final void Function() onTap;

  const AnswerOptionButton({
    Key? key,
    required this.option,
    required this.correctAnswer,
    required this.selectedAnswer,
    required this.isAnswered,
    required this.isEnabled,
    required this.onTap,
  }) : super(key: key);

  @override
  State<AnswerOptionButton> createState() => _AnswerOptionButtonState();
}

class _AnswerOptionButtonState extends State<AnswerOptionButton> {
  double _scale = 1.0;
  Color _backgroundColor = Colors.white;

  void _handleTap() async {
    final isTappedCorrect = widget.option == widget.correctAnswer;

    setState(() {
      _scale = 0.95;
      _backgroundColor = isTappedCorrect
          ? Colors.green.shade700
          : Colors.red.shade700; // 🔁 Bosish effekti
    });

    await Future.delayed(const Duration(milliseconds: 100));

    setState(() {
      _scale = 1.0;
      _backgroundColor = Colors.white;
    });

    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final isCorrect =
        widget.isAnswered && widget.option == widget.correctAnswer;
    final isWrong = widget.isAnswered &&
        widget.option == widget.selectedAnswer &&
        widget.option != widget.correctAnswer;

    Color finalColor = _backgroundColor;
    if (widget.isAnswered) {
      if (isCorrect) finalColor = Colors.green;
      if (isWrong) finalColor = Colors.red;
    }

    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 100),
      child: GestureDetector(
        onTap: widget.isEnabled ? _handleTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: finalColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 3),
                blurRadius: 4,
                spreadRadius: 2,
                blurStyle: BlurStyle.inner,
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.option,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
