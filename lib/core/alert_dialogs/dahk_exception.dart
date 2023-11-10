import 'package:flutter/material.dart';

void dahkException(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget> [
              const SizedBox(height: 20,),
              const Image(
                image: AssetImage("assets/Navigation/Exception.png"),
                width: 46,
                height: 46,
              ),
              const SizedBox(height: 20,),
              Container(
                margin: const EdgeInsets.only(right: 10, left: 10),
                child: const Text(
                  "Վճարումն հնարավոր չի իրականացնել, քանի որ մեքենան գտնվում է ԴԱՀԿ հետախուզման մեջ։",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Color(0xff164866)
                  ),
                ),
              ),
              const SizedBox(height: 20,),
            ],
          ),
        );
      });
}
