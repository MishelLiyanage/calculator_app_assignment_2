// Student ID: - IM/2021/115
// Student name: - Mishel Fernando

import 'package:flutter/material.dart';
import 'HistoryPage.dart';
import 'button_values.dart';
import 'dart:math';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // Variables to hold the first number, operand, and second number
  String number1 = "";
  String operand = "";
  String number2 = "";

  // List to store the calculation history
  List<String> calculationHistory = [];

  // Flag to track if the result is currently displayed
  bool isResultDisplayed = false;

  @override
  Widget build(BuildContext context) {
    // Get the screen size for dynamic button layout
    final screenSize = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Display area for the input and result
            Expanded(
              child: SingleChildScrollView(
                reverse: true, // Scroll to the bottom for new inputs
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    // Display the current input or "0" if empty
                    "$number1$operand$number2".isEmpty
                        ? "0"
                        : "$number1$operand$number2",
                    style: const TextStyle(
                      fontSize: 48, // Font size for display text
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end, // Align text to the right
                  ),
                ),
              ),
            ),

            // New Row for History and DEL Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // Space out History and DEL buttons
              children: [
                // History Button (Left-aligned)
                SizedBox(
                  width: screenSize.width / 4, // Same size as other buttons
                  height: screenSize.width / 5,
                  child: buildButton(Btn.history),
                ),
                // DEL Button (Right-aligned)
                SizedBox(
                  width: screenSize.width / 4,
                  height: screenSize.width / 5,
                  child: buildButton(Btn.del),
                ),
              ],
            ),
            // Button grid for calculator inputs
            Wrap(
              children: Btn.buttonValues
                  .map(
                    (value) =>
                    SizedBox(
                      width: value == Btn.n0
                          ? screenSize.width / 2 // Wider button for "0"
                          : (screenSize.width / 4), // Standard button width
                      height: screenSize.width / 5, // Button height
                      child: buildButton(value),
                    ),
              )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  // Widget to build each button with appropriate styles and actions
  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4.5), // Button padding
      child: Material(
        color: getBtnColor(value), // Get button color dynamically
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: BorderSide(
            // Transparent border for special buttons
            color: value == Btn.del || value == Btn.history
                ? Colors
                .transparent // Transparent border for DEL and History buttons
                : Colors.white10, // Default border for other buttons
          ),
          borderRadius: BorderRadius.circular(80), // Rounded corners
        ),
        child: InkWell(
          onTap: () {
            if (value == Btn.history) {
              // Navigate to the History Page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      HistoryPage(history: calculationHistory),
                ),
              );
              return;
            }
            onBtnTap(value);
          },
          child: Center(
            child: Text(
              value, // Display button text
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Handle button tap actions
  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete(); // Handle delete button action
      return;
    }

    if (value == Btn.clr) {
      clearAll(); // Clear all inputs
      return;
    }

    if (value == Btn.per) {
      convertToPercentage(); // Convert number to percentage
      return;
    }

    if (value == Btn.calculate) {
      calculate(); // Perform calculation
      return;
    }

    if (value == Btn.sqrt) {
      calculateSquareRoot(); // Calculate square root
      return;
    }

    appendValue(value); // Append value to the input
  }

  // Perform the calculation based on the inputs and operator
  void calculate() {
    // Ensure all required inputs are present
    if (number1.isEmpty || operand.isEmpty || number2.isEmpty) {
      return;
    }

    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);

    var result = 0.0; // Variable to hold the result
    switch (operand) {
      // add the numbers
      case Btn.add:
        result = num1 + num2;
        break;
      // subtract the numbers
      case Btn.subtract:
        result = num1 - num2;
        break;
      // multiply 2 numbers
      case Btn.multiply:
        result = num1 * num2;
        break;
      // divide the 2 numbers
      case Btn.divide:
        if (num2 == 0) {
          setState(() {
            // handle the 1/0 and 0/0 validation
            number1 = num1 == 0 ? "NaN" : "Infinity";
            operand = "";
            number2 = "";
            isResultDisplayed = true; // Set the flag to true after calculation
          });
          return;
        }
        result = num1 / num2;
        break;
      default:
    }

    // Format result as integer or decimal as needed
    final formattedResult =
    result % 1 == 0 ? result.toStringAsFixed(0) : result.toStringAsFixed(6);

    setState(() {
      // Add to history in the proper format: "2 + 3 = 5"
      calculationHistory.add("$number1 $operand $number2 = $formattedResult");

      // Update current display with the result
      number1 = formattedResult;
      operand = "";
      number2 = "";
      isResultDisplayed = true; // Set the flag to true after calculation
    });
  }

  // convert the number to a percentage
  void convertToPercentage() {
    // check whether the numbers are
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      calculate();
    }

    if (operand.isNotEmpty) {
      return;
    }

    final double number = double.parse(number1);

    setState(() {
      final result = number / 100;
      // Format the result
      final formattedResult =
      result % 1 == 0 ? result.toStringAsFixed(0) : result.toStringAsFixed(6);

      // Add to history in the proper format: "X% = Y"
      calculationHistory.add("$number1% = $formattedResult");

      // Update display
      number1 = formattedResult;
      operand = "";
      number2 = "";
      isResultDisplayed = true; // Set the flag to true after calculation
    });
  }

  // Calculate the square root of the input number
  void calculateSquareRoot() {
    if (number1.isEmpty || operand.isNotEmpty || number2.isNotEmpty) {
      return;
    }

    final double num = double.parse(number1);

    // Handle negative input for square root
    if (num < 0) {
      setState(() {
        number1 = "Error"; // Display error for negative input
      });
      return;
    }

    setState(() {
      final result = sqrt(num); // Calculate square root
      // Format the result
      final formattedResult =
      result % 1 == 0 ? result.toStringAsFixed(0) : result.toStringAsFixed(6);

      // Add to history in the proper format: "√X = Y"
      calculationHistory.add("√$number1 = $formattedResult");

      // Update display
      number1 = formattedResult;

      isResultDisplayed = true; // Set the flag to true after calculation
    });
  }

  // Reset all calculator inputs (number1, operand, number2) to empty strings
  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

  // Delete the last character from the input
  void delete() {
    // Check if the second number (number2) is not empty
    if (number2.isNotEmpty) {
      // Remove the last character from number2
      number2 = number2.substring(0, number2.length - 1);
    }
    // If number2 is empty, check if the operand exists
    else if (operand.isNotEmpty) {
      // Clear the operand
      operand = "";
    }
    // If both number2 and operand are empty, check number1
    else if (number1.isNotEmpty) {
      // Remove the last character from number1
      number1 = number1.substring(0, number1.length - 1);
    }

    // Trigger a UI update
    setState(() {});
  }

  // Append a value to the input
  void appendValue(String value) {
    // If the value is not a decimal point (.) or a number, it is an operator
    if (value != Btn.dot && int.tryParse(value) == null) {
      // Perform a calculation if both operand and number2 are not empty
      if (operand.isNotEmpty && number2.isNotEmpty) {
        calculate();
      }
      // Assign the operator to the operand
      operand = value;
      isResultDisplayed = false; // Reset flag for new operations
    }
    // If the first number (number1) or operand is empty
    else if (number1.isEmpty || operand.isEmpty) {
      // Prevent multiple decimal points in number1
      if (value == Btn.dot && number1.contains(Btn.dot))
        return;
      // If the input is a decimal point, ensure number1 starts with "0."
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
        value = "0.";
      }

      if (isResultDisplayed) {
        // Replace the result if new input is provided
        number1 = value;
        isResultDisplayed = false;
      } else {
        // append the value to number1
        number1 += value;
      }
    }
    // If number2 is being entered (operand is set)
    else if (number2.isEmpty || operand.isNotEmpty) {
      // Prevent multiple decimal points in number2
      if (value == Btn.dot && number2.contains(Btn.dot)) return;
      // If the input is a decimal point, ensure number2 starts with "0."
      if (value == Btn.dot && (number2.isEmpty || number2 == Btn.n0)) {
        value = "0.";
      }
      // Append the value to number2
      number2 += value;
    }

    // Trigger a UI update
    setState(() {});
  }

  Color getBtnColor(value) {
    // If the button is DEL or HISTORY, set its color to transparent
    if ([Btn.del, Btn.history].contains(value)) {
      return Colors.transparent;
    }

    // If the button is CLR, set its color to blue-grey
    return [Btn.clr].contains(value)
        ? Colors.blueGrey
    // For operator buttons, set their color to indigo accent
        : [
      Btn.per,
      Btn.multiply,
      Btn.add,
      Btn.subtract,
      Btn.divide,
      Btn.calculate,
      Btn.sqrt
    ].contains(value)
        ? Colors.indigoAccent
    // For all other buttons, set the color to black-grey
        : Colors.black45;
  }
}