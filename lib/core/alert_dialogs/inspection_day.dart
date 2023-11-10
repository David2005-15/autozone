import 'package:autozone/app/home/location.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void showInspectionExpire(
    BuildContext context,
    String autoNumber,
    DateTime date,
    String regNumber,
    DatabaseReference database,
    int userId) async {
  var snapshot = await database.child("inspection_due").once();

  if (snapshot.snapshot.value == null) {
    database.child("inspection_due").child("due${const Uuid().v4()}").set({
      "date": DateTime.now().toIso8601String(),
      "car_number": autoNumber,
      "userId": userId,
      "due_date": date.toIso8601String(),
      "reg_number": regNumber
    });
    
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            insetPadding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                const Image(
                  image: AssetImage("assets/Warning.png"),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "$autoNumber մեքենայի վարորդ, Ձեր մեքենայի տեխզննման ժամկետը ավարտվում է ${date.day}.${date.month}.${date.year}թ.-ին։",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Color(0xff164866)),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChooseLocationPage(
                                autoNumber: autoNumber, regNumber: regNumber)));
                  },
                  child: Container(
                    width: 250,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: const Color(0xff007200),
                    ),
                    child: const Center(
                      child: Text(
                        "Վճարել",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          );
        });
  } else {
    final data = snapshot.snapshot.value as Map<dynamic, dynamic>;
    final documents = data.values.toList().cast<Map<dynamic, dynamic>>();

    bool containsAutoNumber =
        documents.any((map) => map["car_number"] == autoNumber);

    if (!containsAutoNumber) {
      database.child("inspection_due").child("due${const Uuid().v4()}").set({
        "date": DateTime.now().toIso8601String(),
        "car_number": autoNumber,
        "userId": userId,
        "due_date": date.toIso8601String(),
        "reg_number": regNumber
      });

      showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              insetPadding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  const Image(
                    image: AssetImage("assets/Warning.png"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "$autoNumber մեքենայի վարորդ, Ձեր մեքենայի տեխզննման ժամկետը ավարտվում է ${date.day}.${date.month}.${date.year}թ.-ին։",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Color(0xff164866)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChooseLocationPage(
                                  autoNumber: autoNumber,
                                  regNumber: regNumber)));
                    },
                    child: Container(
                      width: 250,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color(0xff007200),
                      ),
                      child: const Center(
                        child: Text(
                          "Վճարել",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            );
          });
    }
  }
}

  // final data = snapshot.snapshot.value as Map<dynamic, dynamic>;

  // if (data == null) {
  //   database
  //       .child("inspection_due")
  //       .child("due${const Uuid().v4()}")
  //       .set({"date": DateTime.now(), "car_number": autoNumber});
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return Dialog(
  //           insetPadding: const EdgeInsets.all(10),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               const SizedBox(
  //                 height: 20,
  //               ),
  //               const Image(
  //                 image: AssetImage("assets/Warning.png"),
  //               ),
  //               const SizedBox(
  //                 height: 10,
  //               ),
  //               Text(
  //                 "$autoNumber մեքենայի վարորդ, Ձեր մեքենայի տեխզննման ժամկետը ավարտվում է ${date.day}.${date.month}.${date.year}թ.-ին։",
  //                 textAlign: TextAlign.center,
  //                 style: const TextStyle(
  //                     fontWeight: FontWeight.w700,
  //                     fontSize: 15,
  //                     color: Color(0xff164866)),
  //               ),
  //               const SizedBox(
  //                 height: 20,
  //               ),
  //               InkWell(
  //                 highlightColor: Colors.transparent,
  //                 splashColor: Colors.transparent,
  //                 onTap: () {
  //                   Navigator.pop(context);
  //                   Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                           builder: (context) => ChooseLocationPage(
  //                               autoNumber: autoNumber, regNumber: regNumber)));
  //                 },
  //                 child: Container(
  //                   width: 250,
  //                   height: 35,
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(25),
  //                     color: const Color(0xff007200),
  //                   ),
  //                   child: const Center(
  //                     child: Text(
  //                       "Վճարել",
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                         fontWeight: FontWeight.w700,
  //                         fontSize: 15,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(
  //                 height: 10,
  //               )
  //             ],
  //           ),
  //         );
  //       });
  // }

  // final documents = data.values.toList().cast<Map<dynamic, dynamic>>();

  // if (documents.isEmpty) {
  //   database
  //       .child("inspection_due")
  //       .child("due${const Uuid().v4()}")
  //       .set({"date": DateTime.now(), "car_number": autoNumber});
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return Dialog(
  //           insetPadding: const EdgeInsets.all(10),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               const SizedBox(
  //                 height: 20,
  //               ),
  //               const Image(
  //                 image: AssetImage("assets/Warning.png"),
  //               ),
  //               const SizedBox(
  //                 height: 10,
  //               ),
  //               Text(
  //                 "$autoNumber մեքենայի վարորդ, Ձեր մեքենայի տեխզննման ժամկետը ավարտվում է ${date.day}.${date.month}.${date.year}թ.-ին։",
  //                 textAlign: TextAlign.center,
  //                 style: const TextStyle(
  //                     fontWeight: FontWeight.w700,
  //                     fontSize: 15,
  //                     color: Color(0xff164866)),
  //               ),
  //               const SizedBox(
  //                 height: 20,
  //               ),
  //               InkWell(
  //                 highlightColor: Colors.transparent,
  //                 splashColor: Colors.transparent,
  //                 onTap: () {
  //                   Navigator.pop(context);
  //                   Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                           builder: (context) => ChooseLocationPage(
  //                               autoNumber: autoNumber, regNumber: regNumber)));
  //                 },
  //                 child: Container(
  //                   width: 250,
  //                   height: 35,
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(25),
  //                     color: const Color(0xff007200),
  //                   ),
  //                   child: const Center(
  //                     child: Text(
  //                       "Վճարել",
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                         fontWeight: FontWeight.w700,
  //                         fontSize: 15,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(
  //                 height: 10,
  //               )
  //             ],
  //           ),
  //         );
  //       });
  // }
