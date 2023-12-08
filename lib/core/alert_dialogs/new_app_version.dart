import 'package:flutter/material.dart';

void updateDialog(BuildContext context, VoidCallback onPressed) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          child: Container(
            width: double.infinity,
            height: 200,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Հասանելի է հավելվածի թարմացում",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    onPressed();
                  },
                  child: Container(
                    width: 187,
                    height: 35,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xffC42225),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Text(
                      "Թարմացնել",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      });
}
