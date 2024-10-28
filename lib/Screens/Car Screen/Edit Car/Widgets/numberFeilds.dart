import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputFeilds extends StatelessWidget {
  const InputFeilds({
    super.key,
    required this.ccController,
    required this.label,
  });

  final TextEditingController ccController;
  final String label;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    double screenHeight = screenSize.height;
    double screenWidth = screenSize.width;
    return SizedBox(
      width: kIsWeb ? screenWidth * 0.15 : screenWidth * 0.27,
      child: TextFormField(
        validator: (value) {
          if (value == null || value == "") {
            return "please fill valid feild";
          }
          return null;
        },
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: ccController,
        decoration: InputDecoration(
          hintStyle: const TextStyle(
            fontFamily: 'Roboto',
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          label: Text(
            label,
            style: TextStyle(fontFamily: "Roboto"),
          ),
        ),
      ),
    );
  }
}
