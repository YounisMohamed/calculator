import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:nice_buttons/nice_buttons.dart';

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _evaluateExpression(String expression) {
    try {
      if (expression == "696969") return "Nice <3";
      if (expression == "682003") return "Thats my birthday <3";
      if (expression == "6-8-2003") return "Thats my birthday <3";

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

  void setTheme(int themeInt) {
    theme = themeInt;
  }

  static String name = "YONES";
  List<String> functionalButtons = name.split("");
  void PRINT() {
    print(functionalButtons);
  }

  String _expression = "";
  // ${name.substring(0, 1)}${name.substring(1).toLowerCase()}
  String _result = "Hello Younis";
  String _savedResult = "";

  final Color backgroundColor = const Color(0xFF1A1A2E);
  final Color displayBackgroundColor = const Color(0xFF16213E);
  final Color operatorColor = Colors.indigo;
  final Color deleteColor = Colors.pink;
  final Color functionColor = Colors.deepPurple;
  final Color numberColor = Colors.white;
  int theme = 0;
  final List<Map<String, Color>> themes = [
    {
      "displayBackground": const Color(0xFF16213E),
      "divider": Colors.white70,
      "expressionText": Colors.white,
      "resultText": Colors.lightBlueAccent,
    },
    {
      "displayBackground": Colors.greenAccent,
      "divider": Colors.black87,
      "expressionText": Colors.black,
      "resultText": Colors.deepPurple,
    },
  ];
  void _toggleTheme() {
    setState(() {
      theme = (theme + 1) % themes.length;
    });
  }

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

  get currentTheme => themes[theme];

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
    } else if (functionalButtons.contains(button)) {
      return functionColor;
    }
    return numberColor;
  }

  bool _isSpecialButton(String button) {
    return !buttons.contains(button);
  }

  void showSnackbar(context, String text) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(),
        ),
        backgroundColor: Colors.black,
        duration: const Duration(milliseconds: 1000),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> buttons = [
      "C",
      "(",
      ")",
      "%",
      "e",
      "!",
      "√",
      "-",
      "+",
      "π",
      "^",
      "÷",
      "<",
      "x",
      ".",
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
      "<<",
      "?",
      "|",
      "&",
      ">>",
      ...functionalButtons
    ];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Display for Expression and Result
            Container(
              decoration: BoxDecoration(
                color: currentTheme["displayBackground"],
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
                          color: currentTheme["expressionText"],
                        ),
                      ),
                    ),
                  ),
                  Divider(thickness: 1, color: currentTheme["divider"]),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 80,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        _result,
                        style: GoogleFonts.roboto(
                          fontSize: (48 - (_result.length))
                              .clamp(24.0, 48.0)
                              .toDouble(),
                          fontWeight: FontWeight.bold,
                          color: currentTheme["resultText"],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.black87,
                child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 7,
                      mainAxisSpacing: 7,
                    ),
                    itemCount: buttons.length,
                    itemBuilder: (context, index) {
                      String button = buttons[index];
                      return button.isEmpty
                          ? const SizedBox.shrink()
                          : NiceButtons(
                              onTap: (finish) {
                                setState(() {
                                  if (button == "C") {
                                    _expression = "";
                                    _result = "0";
                                  } else if (button == "<") {
                                    if (_expression.isNotEmpty) {
                                      _expression = _expression.substring(
                                          0, _expression.length - 1);
                                    }
                                  } else if (button == functionalButtons[0]) {
                                    _toggleTheme();
                                    showSnackbar(context, "Theme Changed!");
                                  } else if (button == functionalButtons[1]) {
                                    if (RegExp(r'^[0-9.]+$')
                                        .hasMatch(_result)) {
                                      _savedResult = _result;
                                      showSnackbar(context, "Result Saved!");
                                    }
                                  } else if (button == functionalButtons[2]) {
                                    _expression += _savedResult;
                                  } else if (button == functionalButtons[3]) {
                                    if (RegExp(r'^[0-9.]+$')
                                        .hasMatch(_result)) {
                                      double number = double.parse(_result);
                                      int flooredNumber = number.round();
                                      _result = flooredNumber.toString();
                                      if (_expression != _result) {
                                        showSnackbar(
                                            context, "Number Rounded!");
                                        _expression = _result;
                                      }
                                    }
                                  } else if (button == functionalButtons[4]) {
                                    _expression += button;
                                    RegExp regex = RegExp(r'(\d+)(D)$');
                                    Match? match =
                                        regex.firstMatch(_expression);
                                    if (match != null) {
                                      int maxNumber =
                                          int.parse(match.group(1)!);
                                      if (maxNumber > 0) {
                                        int randomNumber =
                                            math.Random().nextInt(maxNumber) +
                                                1;
                                        _expression = _expression.replaceFirst(
                                            regex, randomNumber.toString());
                                        _result =
                                            _evaluateExpression(_expression);
                                        showSnackbar(
                                            context, "Random number picked!");
                                      }
                                    }
                                  } else {
                                    _expression += button;
                                  }
                                  _result = _evaluateExpression(_expression);
                                });
                              },
                              startColor: _getButtonColor(button),
                              borderColor:
                                  _getButtonColor(button).withOpacity(0.5),
                              endColor:
                                  _getButtonColor(button).withOpacity(0.8),
                              borderRadius: 30,
                              child: Text(
                                button,
                                style: GoogleFonts.onest(
                                  fontWeight: FontWeight.bold,
                                  fontSize: button != "<<" && button != ">>"
                                      ? 32
                                      : 16,
                                  color: _isSpecialButton(button)
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
