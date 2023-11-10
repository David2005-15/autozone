import 'package:flutter/material.dart';

void document_hint(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: SizedBox(
            width: MediaQuery.of(context).size.width *
                0.8, // Set the width to 80% of the screen width
            child: Image.asset(
              'assets/Document.png',
              fit: BoxFit.contain, // Fit the image to the available space
            ),
          ),
        );
      });
}
