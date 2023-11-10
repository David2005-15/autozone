import 'package:flutter/material.dart';

void error(BuildContext context, String autoSerialCode) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: 33,
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 22,
                      height: 22,
                      margin: const EdgeInsets.only(right: 10, top: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xff164866),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.close,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const Image(
                  image: AssetImage('assets/Warning.png'),
                ),
                const SizedBox(
                  height: 19,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 10),
                  child: Text(
                    autoSerialCode,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Color(0xff164866)),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  "Որոնման արդյունքում նման տվյալներով մեքենա չի գտնվել: Խնդրում ենք ստուգել մուտքագրված տվյալների ճշգրտությունը:",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Color(0xff164866)),
                ),
                const SizedBox(
                  height: 22,
                )
              ],
            ),
          ),
        );
      });
}
