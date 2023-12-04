import 'package:flutter/material.dart';

void success(BuildContext context, String message) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          child: Container(
            height: 200,
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                const SizedBox(height: 10,),
                const Image(
                  image: AssetImage("assets/Settings/Success.png"),
                  width: 70,
                  height: 70,
                ),
          
                const SizedBox(height: 30,),
            
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Color(0xff164866)
                  ), 
                ),
          
                const SizedBox(height: 20,)
              ],
            ),
          ),
        );
      });
}
