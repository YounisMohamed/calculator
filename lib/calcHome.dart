import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _expression = "";
  String _result = "Hello Younis";

  String _evaluateExpression(String expression) {
    try {
      if (expression == "696969") return "Nice <3";
      expression = expression
          .replaceAll('√', "sqrt")
          .replaceAll('π', Number(math.pi).toString())
          .replaceAll('e', "2.71828")
          .replaceAll("÷", "/")
          .replaceAll("x", "*");
      expression = _handleFactorial(expression);
      expression = _handleSqrt(expression);
      expression = _handleXor(expression);
      expression = _handleOr(expression);
      expression = _handleLeftShift(expression);
      expression = _handleRightShift(expression);
      Parser parser = Parser();
      Expression exp = parser.parse(expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      if (eval == eval.toInt()) {
        return eval.toInt().toString();
      } else {
        String evalStr = eval.toStringAsPrecision(6);
        // Remove unnecessary trailing zeros for rational numbers
        if (evalStr.contains('.')) {
          evalStr = evalStr.replaceAll(RegExp(r'0*$'), '');
          evalStr = evalStr.replaceAll(RegExp(r'\.$'), '');
        }
        return evalStr;
      }
    } catch (e) {
      return _expression;
    }
  }

  String _handleFactorial(String expression) {
    while (expression.contains('!')) {
      int idx = expression.indexOf('!');
      int start = idx - 1;
      while (start >= 0 &&
          (expression[start].contains(RegExp(r'[0-9]')) ||
              expression[start] == '.')) {
        start--;
      }
      start++;
      String number = expression.substring(start, idx);
      double num = double.parse(number);
      double result = _factorial(num);
      expression = expression.replaceRange(start, idx + 1, result.toString());
    }
    return expression;
  }

  double _factorial(double num) {
    if (num == 0) return 1;
    double fact = 1;
    for (int i = 1; i <= num; i++) {
      fact *= i;
    }
    return fact;
  }

  String _handleXor(String expression) {
    while (expression.contains('?')) {
      int idx = expression.indexOf('?');
      int leftEnd = idx - 1;
      int leftStart = leftEnd;
      while (leftStart >= 0 &&
          (expression[leftStart].contains(RegExp(r'[0-9]')) ||
              expression[leftStart] == '.')) {
        leftStart--;
      }
      leftStart++;
      int rightStart = idx + 1;
      int rightEnd = rightStart;
      while (rightEnd < expression.length &&
          (expression[rightEnd].contains(RegExp(r'[0-9]')) ||
              expression[rightEnd] == '.')) {
        rightEnd++;
      }
      String leftStr = expression.substring(leftStart, leftEnd + 1);
      String rightStr = expression.substring(rightStart, rightEnd);
      int left = int.parse(leftStr);
      int right = int.parse(rightStr);
      int result = left ^ right;
      expression =
          expression.replaceRange(leftStart, rightEnd, result.toString());
    }
    return expression;
  }

  String _handleOr(String expression) {
    while (expression.contains('|')) {
      int idx = expression.indexOf('|');
      int leftEnd = idx - 1;
      int leftStart = leftEnd;
      while (leftStart >= 0 &&
          (expression[leftStart].contains(RegExp(r'[0-9]')) ||
              expression[leftStart] == '.')) {
        leftStart--;
      }
      leftStart++;
      int rightStart = idx + 1;
      int rightEnd = rightStart;
      while (rightEnd < expression.length &&
          (expression[rightEnd].contains(RegExp(r'[0-9]')) ||
              expression[rightEnd] == '.')) {
        rightEnd++;
      }
      String leftStr = expression.substring(leftStart, leftEnd + 1);
      String rightStr = expression.substring(rightStart, rightEnd);
      int left = int.parse(leftStr);
      int right = int.parse(rightStr);
      int result = left | right;
      expression =
          expression.replaceRange(leftStart, rightEnd, result.toString());
    }
    return expression;
  }

  String _handleLeftShift(String expression) {
    while (expression.contains('<<')) {
      int idx = expression.indexOf('<<');
      int leftEnd = idx - 1;
      int leftStart = leftEnd;
      while (leftStart >= 0 &&
          (expression[leftStart].contains(RegExp(r'[0-9]')) ||
              expression[leftStart] == '.')) {
        leftStart--;
      }
      leftStart++;
      int rightStart = idx + 2;
      int rightEnd = rightStart;
      while (rightEnd < expression.length &&
          (expression[rightEnd].contains(RegExp(r'[0-9]')) ||
              expression[rightEnd] == '.')) {
        rightEnd++;
      }
      String leftStr = expression.substring(leftStart, leftEnd + 1);
      String rightStr = expression.substring(rightStart, rightEnd);
      int left = int.parse(leftStr);
      int right = int.parse(rightStr);
      int result = left << right;
      expression =
          expression.replaceRange(leftStart, rightEnd, result.toString());
    }
    return expression;
  }

  String _handleRightShift(String expression) {
    while (expression.contains('>>')) {
      int idx = expression.indexOf('>>');
      int leftEnd = idx - 1;
      int leftStart = leftEnd;
      while (leftStart >= 0 &&
          (expression[leftStart].contains(RegExp(r'[0-9]')) ||
              expression[leftStart] == '.')) {
        leftStart--;
      }
      leftStart++;
      int rightStart = idx + 2;
      int rightEnd = rightStart;
      while (rightEnd < expression.length &&
          (expression[rightEnd].contains(RegExp(r'[0-9]')) ||
              expression[rightEnd] == '.')) {
        rightEnd++;
      }
      String leftStr = expression.substring(leftStart, leftEnd + 1);
      String rightStr = expression.substring(rightStart, rightEnd);
      int left = int.parse(leftStr);
      int right = int.parse(rightStr);
      int result = left >> right;
      expression =
          expression.replaceRange(leftStart, rightEnd, result.toString());
    }
    return expression;
  }

  String _handleSqrt(String expression) {
    while (expression.contains('sqrt')) {
      int idx = expression.indexOf('sqrt');
      int start = idx + 4;
      int end = start;
      while (end < expression.length &&
          (expression[end].contains(RegExp(r'[0-9]')) ||
              expression[end] == '.')) {
        end++;
      }
      String number = expression.substring(start, end);
      double num = double.parse(number);
      double result = math.sqrt(num);

      // Check for a number preceding 'sqrt'
      int precedingNumberEnd = idx - 1;
      int precedingNumberStart = precedingNumberEnd;
      while (precedingNumberStart >= 0 &&
          expression[precedingNumberStart].contains(RegExp(r'[0-9]'))) {
        precedingNumberStart--;
      }
      precedingNumberStart++;

      if (precedingNumberStart < idx) {
        String precedingNumber =
            expression.substring(precedingNumberStart, idx);
        expression = expression.replaceRange(precedingNumberStart, end,
            (double.parse(precedingNumber) * result).toString());
      } else {
        expression = expression.replaceRange(idx, end, result.toString());
      }
    }
    return expression;
  }

  final Color backgroundColor = const Color(0xFF1A1A2E);
  final Color displayBackgroundColor = const Color(0xFF16213E);
  final Color operatorColor = Colors.indigo;
  final Color deleteColor = const Color(0xFFE94560);
  final Color functionColor = const Color(0xFF533483);
  final Color numberColor = Colors.white;
  final Color resultColor = const Color(0xFF00FFA3);

  List<String> buttons = [
    "7",
    "8",
    "9",
    "4",
    "5",
    "6",
    "1",
    "2",
    "3",
    "0",
  ];

  Color _getButtonColor(String button) {
    if (button == "C" || button == "<") {
      return deleteColor;
    } else if ([
      "+",
      "-",
      "×",
      "÷",
      "^",
      "%",
      "(",
      ")",
      "?",
      "|",
      "<<",
      ">>",
      "x",
      "&",
      "√",
      "π",
      "e",
      "!",
      ".",
    ].contains(button)) {
      return operatorColor;
    } else if ([
      "D",
      "F",
      "R",
      "U",
    ].contains(button)) {
      return functionColor;
    }
    return numberColor;
  }

  bool _isSpecialButton(String button) {
    return !buttons.contains(button);
  }

  @override
  Widget build(BuildContext context) {
    List<String> buttons = [
      "C",
      "(",
      ")",
      "÷",
      "%",
      "1",
      "3",
      "5",
      "7",
      "9",
      "2",
      "4",
      "6",
      "8",
      "0",
      "x",
      "√",
      "-",
      "+",
      "π",
      "^",
      ".",
      "<",
      "!",
      "&",
      "<<",
      "?",
      "|",
      "e",
      ">>",
      "F",
      "R",
      "U",
      "D"
    ];

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Column(
          children: [
            // Display for Expression and Result
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 60,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        _expression,
                        style: GoogleFonts.roboto(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Divider(thickness: 1, color: Colors.white30),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 80,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        _result,
                        style: GoogleFonts.roboto(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.pinkAccent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Buttons Grid
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.grey[900],
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 7,
                    mainAxisSpacing: 7,
                  ),
                  itemCount: buttons.length,
                  itemBuilder: (context, index) {
                    String button = buttons[index];
                    return button.isEmpty
                        ? const SizedBox.shrink()
                        : ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (button == "C") {
                                  _expression = "";
                                  _result = "0";
                                } else if (button == "<") {
                                  if (_expression.isNotEmpty) {
                                    _expression = _expression.substring(
                                        0, _expression.length - 1);
                                  }
                                } else if (button == "F") {
                                  if (RegExp(r'^[0-9.]+$').hasMatch(_result)) {
                                    double number = double.parse(_result);
                                    int flooredNumber = number.floor();
                                    _result = flooredNumber.toString();
                                    _expression = _result;
                                  }
                                } else if (button == "R") {
                                  if (RegExp(r'^[0-9.]+$').hasMatch(_result)) {
                                    double number = double.parse(_result);
                                    int flooredNumber = number.round();
                                    _result = flooredNumber.toString();
                                    _expression = _result;
                                  }
                                } else if (button == "U") {
                                  if (RegExp(r'^[0-9.]+$').hasMatch(_result)) {
                                    double number = double.parse(_result);
                                    int flooredNumber = number.ceil();
                                    _result = flooredNumber.toString();
                                    _expression = _result;
                                  }
                                } else if (button == "D") {
                                  // Regular expression to match a number followed by 'D' at the end
                                  _expression += button;
                                  RegExp regex = RegExp(r'(\d+)(D)$');
                                  Match? match = regex.firstMatch(_expression);
                                  if (match != null) {
                                    int maxNumber = int.parse(match.group(
                                        1)!); // Extract the number before 'D'
                                    if (maxNumber > 0) {
                                      int randomNumber = math.Random()
                                              .nextInt(maxNumber) +
                                          1; // Generate random number between 1 and maxNumber
                                      // Replace 'numberD' with the generated random number
                                      _expression = _expression.replaceFirst(
                                          regex, randomNumber.toString());
                                      _result = _evaluateExpression(
                                          _expression); // Evaluate the updated expression
                                    }
                                  }
                                } else {
                                  _expression += button;
                                }
                                _result = _evaluateExpression(_expression);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _getButtonColor(button),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 5,
                            ),
                            child: Text(
                              button,
                              style: GoogleFonts.roboto(
                                fontSize:
                                    button != "<<" && button != ">>" ? 32 : 18,
                                color: _isSpecialButton(button)
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                          );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
