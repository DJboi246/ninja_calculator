import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const Calculator());
}

class Calculator extends StatelessWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const SimpleCalculator(),
    );
  }
}

class SimpleCalculator extends StatefulWidget {
  const SimpleCalculator({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SimpleCalculatorState createState() => _SimpleCalculatorState();
}

class _SimpleCalculatorState extends State<SimpleCalculator> {
  String equation = "0";
  String result = "0";
  String expression = "";
  double equationFontSize = 38.0;
  double resultFontSize = 48.0;

  buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        equation = "0";
        result = "0";
        equationFontSize = 38.0;
        resultFontSize = 48.0;
      } else if (buttonText == "⌫") {
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        equation = equation.substring(0, equation.length - 1);
        if (equation == "") {
          equation = "0";
        }
      } else if (buttonText == "=") {
        equationFontSize = 38.0;
        resultFontSize = 48.0;

        expression = equation;
        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');

        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);

          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
        } catch (e) {
          result = "Error";
        }
      } else {
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        if (equation == "0") {
          equation = buttonText;
        } else {
          equation = equation + buttonText;
        }

        for (int i = 0; i < 2; i++) {
          if (equation.length > 36) {
            equation = equation.substring(0, equation.length - 1);
          }
        }
      }
    });
  }

  Widget buildButton(
      String buttonText, double buttonHeight, Color buttonColor) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1 * buttonHeight,
      color: buttonColor,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
                side: const BorderSide(
                    color: Colors.black, width: 1, style: BorderStyle.solid)),
            padding: const EdgeInsets.all(16.0),
          ),
          onPressed: () => buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: const TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.normal,
                color: Colors.white),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ninja Calculator')),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            color: Colors.black,
            child: Text(
              equation,
              style: TextStyle(fontSize: equationFontSize, color: Colors.white),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
            color: Colors.black,
            child: Text(
              result,
              style: TextStyle(fontSize: resultFontSize, color: Colors.white),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.black,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * .75,
                child: Table(
                  children: [
                    TableRow(children: [
                      buildButton("C", 1, const Color.fromARGB(254, 226, 1, 1)),
                      buildButton(
                          "⌫", 1, const Color.fromARGB(228, 0, 143, 17)),
                      buildButton(
                          "÷", 1, const Color.fromARGB(228, 0, 143, 17)),
                    ]),
                    TableRow(children: [
                      buildButton("7", 1, Colors.black54),
                      buildButton("8", 1, Colors.black54),
                      buildButton("9", 1, Colors.black54),
                    ]),
                    TableRow(children: [
                      buildButton("4", 1, Colors.black54),
                      buildButton("5", 1, Colors.black54),
                      buildButton("6", 1, Colors.black54),
                    ]),
                    TableRow(children: [
                      buildButton("1", 1, Colors.black54),
                      buildButton("2", 1, Colors.black54),
                      buildButton("3", 1, Colors.black54),
                    ]),
                    TableRow(children: [
                      buildButton(".", 1, Colors.black54),
                      buildButton("0", 1, Colors.black54),
                      buildButton("00", 1, Colors.black54),
                    ]),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Table(
                  children: [
                    TableRow(children: [
                      buildButton(
                          "×", 1, const Color.fromARGB(228, 0, 143, 17)),
                    ]),
                    TableRow(children: [
                      buildButton(
                          "-", 1, const Color.fromARGB(228, 0, 143, 17)),
                    ]),
                    TableRow(children: [
                      buildButton(
                          "+", 1, const Color.fromARGB(228, 0, 143, 17)),
                    ]),
                    TableRow(children: [
                      buildButton("=", 2, const Color.fromRGBO(207, 0, 0, 1)),
                    ]),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
