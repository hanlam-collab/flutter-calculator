
import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Calculator(),
  ));
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String expression = '';
  String display = '0';

  // Add a button's value to the expression
  void addInput(String input) {
    setState(() {
      expression += input;
      display = expression;
    });
  }

  // Clear everything
  void clearCalculator() {
    setState(() {
      expression = '';
      display = '0';
    });
  }

  // Evaluate the expression
  void calculate() {
    if (expression.isEmpty) {
      return;
    }

    try {
      // Check for division by zero
      if (RegExp(r'/\s*0(?:\.0*)?(?:\D|$)').hasMatch(expression)) {
        setState(() {
          display = 'Error: Cannot divide by zero';
        });
        return;
      }

      final parsedExpression = Expression.parse(expression);

      const evaluator = ExpressionEvaluator();

      final result = evaluator.eval(parsedExpression, {});

      setState(() {
        display = '$expression = $result';
        expression = result.toString();
      });
    } catch (e) {
      setState(() {
        display = 'Error: Invalid expression';
      });
    }
  }

  // Create a calculator button
  Widget calculatorButton(
    String text, {
    VoidCallback? onPressed,
    bool isOperator = false,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          height: 70,
          child: FilledButton(
            onPressed: onPressed ?? () => addInput(text),
            style: FilledButton.styleFrom(
              backgroundColor:
                  isOperator ? const Color.fromARGB(255, 86, 145, 97) : const Color.fromARGB(255, 23, 105, 23),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,

      appBar: AppBar(
        title: const Text(
          'Han Lam\'s Calculator',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 86, 145, 97),
        foregroundColor: Colors.white,
      ),

      body: SafeArea(
        child: Column(
          children: [
            // Display
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      display,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Calculator buttons
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  // 7 8 9 /
                  Row(
                    children: [
                      calculatorButton('7'),
                      calculatorButton('8'),
                      calculatorButton('9'),
                      calculatorButton(
                        '/',
                        isOperator: true,
                      ),
                    ],
                  ),

                  // 4 5 6 *
                  Row(
                    children: [
                      calculatorButton('4'),
                      calculatorButton('5'),
                      calculatorButton('6'),
                      calculatorButton(
                        '*',
                        isOperator: true,
                      ),
                    ],
                  ),

                  // 1 2 3 -
                  Row(
                    children: [
                      calculatorButton('1'),
                      calculatorButton('2'),
                      calculatorButton('3'),
                      calculatorButton(
                        '-',
                        isOperator: true,
                      ),
                    ],
                  ),

                  // 0 + C =
                  Row(
                    children: [
                      calculatorButton('0'),
                      calculatorButton(
                        '+',
                        isOperator: true,
                      ),
                      calculatorButton(
                        'C',
                        onPressed: clearCalculator,
                      ),
                      calculatorButton(
                        '=',
                        onPressed: calculate,
                        isOperator: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

