import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:nice_buttons/nice_buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

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

  late SharedPreferences _prefs;
  int theme = 0;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  void _initialize() {
    setState(() {
      theme = sp?.getInt("theme") ?? 0;
    });
  }

  void _toggleTheme() {
    setState(() {
      theme = (theme + 1) % themes.length;
      sp?.setInt("theme", theme);
    });
  }

  static String name = "REMAN";
  List<String> functionalButtons = name.split("");
  void PRINT() {
    print(functionalButtons);
  }

  String _expression = "";
  // ${name.substring(0, 1)}${name.substring(1).toLowerCase()}
  String _result = "Hello Reman";
  String _savedResult = "";

  final Color backgroundColor = const Color(0xFF1A1A2E);
  final Color displayBackgroundColor = const Color(0xFF16213E);
  final Color operatorColor = Colors.indigo;
  final Color deleteColor = Colors.pink;
  final Color functionColor = Colors.deepPurple;
  final Color numberColor = Colors.white;
  final List<Map<String, dynamic>> themes = [
    {
      // DARK THEME
      "backGroundColorGradientBottom": Colors.indigo,
      "backGroundColorGradientTop": Colors.black87,
      "displayBackground": const Color(0xFF16213E),
      "divider": Colors.white70,
      "expressionText": Colors.white,
      "resultText": Colors.lightBlueAccent,
      "numberColors": Colors.white,
      "numberTextColors": Colors.black87,
    },
    {
      // NEON CYBERPUNK THEME
      "backGroundColorGradientBottom": Colors.black87,
      "backGroundColorGradientTop": Colors.purple.shade900,
      "displayBackground": Colors.black,
      "divider": Colors.cyanAccent,
      "expressionText": Colors.pinkAccent,
      "resultText": Colors.greenAccent,
      "numberColors": Colors.cyanAccent,
      "numberTextColors": Colors.black87,
    },
    {
      // BLUE-TURQUOISE THEME
      "backGroundColorGradientBottom": Colors.cyan.shade800,
      "backGroundColorGradientTop": Colors.teal.shade600,
      "displayBackground": Colors.teal,
      "divider": Colors.white,
      "expressionText": Colors.white,
      "resultText": Colors.cyanAccent,
      "numberColors": Colors.cyan,
      "numberTextColors": Colors.white,
    },
    {
      // WHITE THEME
      "backGroundColorGradientBottom": Colors.white24,
      "backGroundColorGradientTop": Colors.orangeAccent.shade200,
      "displayBackground": Colors.orange,
      "divider": Colors.black87,
      "expressionText": Colors.white,
      "resultText": Colors.black87,
      "numberColors": Colors.black87,
      "numberTextColors": Colors.white,
    },
    {
      // PURPLE-ORANGE THEME
      "backGroundColorGradientBottom": Colors.deepPurple,
      "backGroundColorGradientTop": Colors.orangeAccent,
      "displayBackground": Colors.deepPurple.shade400,
      "divider": Colors.orange,
      "expressionText": Colors.black54,
      "resultText": Colors.deepPurple.shade50,
      "numberColors": Colors.deepPurple.shade100,
      "numberTextColors": Colors.black87,
    },
    {
      // GREEN-LIME THEME
      "backGroundColorGradientBottom": Colors.green.shade900,
      "backGroundColorGradientTop": Colors.limeAccent.shade200,
      "displayBackground": Colors.green.shade600,
      "divider": Colors.lime,
      "expressionText": Colors.lime.shade50,
      "resultText": Colors.greenAccent,
      "numberColors": Colors.limeAccent,
      "numberTextColors": Colors.black87,
    },
    {
      // SUNSET THEME
      "backGroundColorGradientBottom": Colors.red.shade700,
      "backGroundColorGradientTop": Colors.pink.shade300,
      "displayBackground": Colors.pink.shade900,
      "divider": Colors.black87,
      "expressionText": Colors.black87,
      "resultText": Colors.indigo,
      "numberColors": Colors.red.shade300,
      "numberTextColors": Colors.black87,
    },
    {
      // OCEAN DEPTHS THEME
      "backGroundColorGradientBottom": Colors.blue.shade900,
      "backGroundColorGradientTop": Colors.lightBlue.shade200,
      "displayBackground": Colors.blueGrey.shade800,
      "divider": Colors.lightBlue.shade100,
      "expressionText": Colors.white,
      "resultText": Colors.lightBlue.shade200,
      "numberColors": Colors.blue.shade200,
      "numberTextColors": Colors.blueGrey.shade900,
    },
    {
      // MIDNIGHT GALAXY THEME
      "backGroundColorGradientBottom": Colors.purple.shade900,
      "backGroundColorGradientTop": Colors.indigo.shade200,
      "displayBackground": const Color(0xFF1A237E),
      "divider": Colors.purple.shade100,
      "expressionText": Colors.white,
      "resultText": Colors.purpleAccent.shade100,
      "numberColors": Colors.deepPurple.shade200,
      "numberTextColors": Colors.indigo.shade900,
    },
    {
      // DESERT SAND THEME
      "backGroundColorGradientBottom": Colors.brown.shade700,
      "backGroundColorGradientTop": Colors.orange.shade200,
      "displayBackground": Colors.brown.shade800,
      "divider": Colors.orange.shade300,
      "expressionText": Colors.orange.shade50,
      "resultText": Colors.deepOrange.shade200,
      "numberColors": Colors.brown.shade200,
      "numberTextColors": Colors.brown.shade900,
    },
    {
      // AUTUMN THEME
      "backGroundColorGradientBottom": Colors.deepOrange.shade800,
      "backGroundColorGradientTop": Colors.amber.shade300,
      "displayBackground": Colors.brown.shade700,
      "divider": Colors.amber.shade200,
      "expressionText": Colors.orange.shade50,
      "resultText": Colors.deepOrange.shade200,
      "numberColors": Colors.amber.shade200,
      "numberTextColors": Colors.black87,
    }
  ];

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
    return currentTheme["numberColors"];
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
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            currentTheme["backGroundColorGradientTop"],
            currentTheme["backGroundColorGradientBottom"]
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )),
        child: SafeArea(
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
                          style: GoogleFonts.onest(
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
                          style: GoogleFonts.onest(
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
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
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
                                          _expression =
                                              _expression.replaceFirst(regex,
                                                  randomNumber.toString());
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
                                    _getButtonColor(button).withOpacity(0.7),
                                endColor:
                                    _getButtonColor(button).withOpacity(0.9),
                                borderRadius: 30,
                                stretch: true,
                                borderThickness: 2,
                                child: Text(
                                  button,
                                  style: GoogleFonts.onest(
                                      fontWeight: FontWeight.bold,
                                      fontSize: button != "<<" && button != ">>"
                                          ? 32
                                          : 16,
                                      color: currentTheme["numberTextColors"]),
                                ),
                              );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
