import 'package:flutter/material.dart';

class CustomKeyboard extends StatelessWidget {
  final Function(String) onKeyPressed;
  final bool isForgot;

  const CustomKeyboard({Key? key, required this.onKeyPressed, required this.isForgot})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('1'),
              _buildButton('2'),
              _buildButton('3'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('4'),
              _buildButton('5'),
              _buildButton('6'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('7'),
              _buildButton('8'),
              _buildButton('9'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton(''),
              _buildButton('0'),
              _buildBackspaceButton(),
            ],
          ),
          Visibility(
            visible: isForgot,
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () => onKeyPressed('forgot'),
              child: const Text(
                "Վերականգնել PIN գաղտնաբառը",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                    color: Color(0xff164866)),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButton(String text) {
    return ElevatedButton(
      onPressed: () => onKeyPressed(text),
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
      child: Text(
        text,
        style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 30,
            color: Color(0xff164866)),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return ElevatedButton(
      onPressed: () => onKeyPressed('backspace'),
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
      child: const Icon(
        Icons.backspace,
        color: Color(0xff164866),
      ),
    );
  }
}
