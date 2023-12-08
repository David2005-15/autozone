import 'package:flutter/material.dart';

void loading(BuildContext context, {GlobalKey<NavigatorState>? key}) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xfff8f8f8),
          content: SizedBox(
            height: 120,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: ClipRect(
                    child: Align(
                      heightFactor: 0.5,
                      widthFactor: 0.5,
                      alignment: Alignment.center,
                      child: Image.network(
                        'https://global-uploads.webflow.com/60c38afbb903421f769d6b14/63339fd09bbd2ced74061406_344b0b52291211.59148e0af2f7f.gif',
                      ),
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "Կատարվում է հարցում",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Color(0xff164866)),
                  ),
                )
              ],
            )),
          ),
        );
      });
}
