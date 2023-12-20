import 'package:flutter/material.dart';

void fail(BuildContext context, String message) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget> [
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget> [
                  InkWell(
                    onTap: () {
                      // Navigator.pop(context);
                    },
                    child: Container(
                      width: 22,
                      height: 22,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.close,
                        size: 15,
                        color: Colors.transparent,
                      ),
                    ),
                  )
                ],
              ),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Center(
                  child: Image(
                      image: AssetImage("assets/Settings/Vector-1.png"),
                      width: 20,
                      height: 20,
                    ),
                ),
              ),
              // const Stack(
              //   children: [
              //     Align(
              //       alignment: Alignment.center,
              //       child:  Image(
              //         image: AssetImage("assets/Settings/Vector.png"),
              //         width: 55,
              //         height: 55,
              //       ),
              //     ),

              //     Align(
              //       alignment: Alignment.center,
              //       child: Image(
              //         image: AssetImage("assets/Settings/Vector-1.png"),
              //         width: 20,
              //         height: 20,
              //       ),
              //     )
              //   ],
              // ),

              const SizedBox(height: 20,),
          
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
        );
      });
}

void failAutoRequest(BuildContext context, String message) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget> [
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget> [
                  InkWell(
                    onTap: () {
                      // Navigator.pop(context);
                    },
                    child: Container(
                      width: 22,
                      height: 22,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.close,
                        size: 15,
                        color: Colors.transparent,
                      ),
                    ),
                  )
                ],
              ),
              const Center(
                child: Image(
                    image: AssetImage("assets/Navigation/Exception.png"),
                    width: 60,
                    height: 60,
                  ),
              ),
              
              const SizedBox(height: 20,),

              const Text(
                "ՍԱՀՄԱՆԱՓԱԿՈՒՄ",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Color(0xff164866)
                ),
              ),
              const SizedBox(height: 23,),
          
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
        );
      });
}
