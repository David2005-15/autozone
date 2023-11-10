import 'package:autozone/app/home/location.dart';
import 'package:autozone/core/alert_dialogs/report.dart';
import 'package:autozone/core/factory/message_answer_factory.dart';
import 'package:autozone/utils/notification_title_by_id.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class NotificationsPage extends StatefulWidget {
  final int userId;

  const NotificationsPage({required this.userId, super.key});

  @override
  State<StatefulWidget> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  DatabaseReference? database;

  Map<String, Widget> notifications = {};
  Map<String, Widget> paymentDate = {};

  @override
  void initState() {
    super.initState();
    var app = initFirebaseApp();

    Future.wait([app]).then((db) async {
      DatabaseEvent snapshot = await database!.child("messages").once();
      DatabaseEvent insurance_snapshot =
          await database!.child("inspection_due").once();

      try {
        final data = snapshot.snapshot.value as Map<dynamic, dynamic>;

        final documents = data.values.toList().cast<Map<dynamic, dynamic>>();

        documents.sort((a, b) =>
            DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));

        for (int i = 0; i < documents.length; i++) {
          if (documents[i]["requested_user_id"] as int == widget.userId ||
              documents[i]["issued_user_id"] as int == widget.userId) {
            setState(() {
              notifications[documents[i]['date']] = notificationTile(
                  notificationTitleById(documents[i]['issue_type']),
                  notificationBodyById(
                      documents[i]['issue_type'], documents[i]["car_number"]),
                  documents[i]['date'],
                  documents[i]["answer"].toString().isNotEmpty,
                  isRequested:
                      documents[i]["requested_user_id"] as int == widget.userId,
                  isAnswered: documents[i]["answer"].toString().isNotEmpty,
                  document: documents[i],
                  snapshot: snapshot.snapshot,
                  key: data.keys.toList()[i],
                  answer: documents[i]["answer"]);
            });

            if (documents[i]["answer"].toString().isNotEmpty) {
              setState(() {
                notifications[documents[i]['date'] + "0"] = notificationTile(
                  "${documents[i]["car_number"]} վարորդի պատասխանը",
                  documents[i]["answer"],
                  documents[i]['date'],
                  widget.userId == documents[i]["issued_user_id"] as int,

                  // documents[i]["requested_user_id"] as int == widget.userId,
                  isRequested:
                      documents[i]["requested_user_id"] as int == widget.userId,
                  answer: documents[i]["answer"],
                  document: documents[i],
                  forAnswer: true
                );
              });
            }
          }
        }
      } catch (e) {
        rethrow;
      }

      try {
        final insurance_data =
            insurance_snapshot.snapshot.value as Map<dynamic, dynamic>;
        final instrance_document =
            insurance_data.values.toList().cast<Map<dynamic, dynamic>>();

        for (int i = 0; i < instrance_document.length; i++) {
          if (instrance_document[i]["userId"] as int == widget.userId) {
            setState(() {
              notifications[instrance_document[i]['date']] = buildPaymentTile(
                  instrance_document[i]["car_number"],
                  instrance_document[i]["due_date"],
                  instrance_document[i]["date"],
                  instrance_document[i]["reg_number"]);
            });
          }
        }
      } catch (e) {}

      List<MapEntry<String, Widget>> entries = notifications.entries.toList();

      entries.sort(
          (a, b) => DateTime.parse(b.key).compareTo(DateTime.parse(a.key)));

      notifications = Map<String, Widget>.fromEntries(entries);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 2),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Image(
              image: AssetImage("assets/Settings/BackIcon.png"),
              width: 21,
              height: 21,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.grey[100],
            height: 1.0,
          ),
        ),
        title: const Text(
          "Ծանուցումներ",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: Color(0xff164866),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xff164866)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Container(
          color: Colors.white,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: notifications.values.toList(),
            ),
          )),
    );
  }

  Future initFirebaseApp() async {
    setState(() {
      database = FirebaseDatabase.instance.ref();
    });
  }

  Widget buildPaymentTile(
      String carNumber, String dueDate, String date, String regNumber) {
    DateTime parsedDate = DateTime.parse(dueDate);
    DateTime parsedDateRec = DateTime.parse(date);

    return Container(
      width: double.infinity,
      height: 140,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Color(0xffF5F5F5),
        width: 1.0,
      ))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xffF2F2F4),
                      // color: Colors.red,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Image(
                      image: AssetImage(
                        "assets/Settings/Req.png",
                      ),
                      width: 15,
                      height: 15,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Հիշեցում",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Color(0xff164866),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            "$carNumber մեքենայի տեխզննման ժամկետն ավարտվում է ${parsedDate.day}.${parsedDate.month}.${parsedDate.year}թ.-ին:",
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Color(0xff164866),
            ),
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 150,
                  height: 35,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChooseLocationPage(
                                  autoNumber: carNumber,
                                  regNumber: regNumber)));
                    },
                    child: Container(
                      width: 150,
                      height: 35,
                      decoration: BoxDecoration(
                          color: const Color(0xff00611E),
                          borderRadius: BorderRadius.circular(25)),
                      alignment: Alignment.center,
                      child: const Text(
                        "Վճարել",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Text(
                  "${parsedDateRec.day.toString().padLeft(2, '0')}.${parsedDateRec.month}.${parsedDateRec.year} ${parsedDateRec.hour.toString().padLeft(2, '0')}:${parsedDateRec.minute.toString().padLeft(2, '0')}",
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Color(0xff164866)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  bool getTheRec(bool answer, int recId, int reqId) {
      if(answer) {
        return recId == widget.userId;
      }

      return reqId == widget.userId;
    }

  Widget notificationTile(String title, String body, String date, bool seen,
      {bool isAnswered = true,
      required bool isRequested,
      dynamic document,
      dynamic snapshot,
      dynamic key,
      dynamic answer,
      bool forAnswer = false}) {
    DateTime prasedData = DateTime.parse(date);

    DateTime today = DateTime.now();

    String notificationDate = "";

    if (prasedData.day == today.day &&
        prasedData.month == today.month &&
        prasedData.year == today.year) {
      notificationDate =
          "Այսօր ${prasedData.hour.toString().padLeft(2, '0')}:${prasedData.minute.toString().padLeft(2, '0')}";
    } else {
      notificationDate =
          "${prasedData.day.toString().padLeft(2, '0')}.${prasedData.month}.${prasedData.year}"
          " ${prasedData.hour.toString().padLeft(2, '0')}:${prasedData.minute.toString().padLeft(2, '0')}";
    }

    int reqId = document["requested_user_id"] as int;
    int recId = document["issued_user_id"] as int;

    print(recId == widget.userId);
    print(reqId == widget.userId);


    

    return Container(
      width: double.infinity,
      height: 140,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Color(0xffF5F5F5),
        width: 1.0,
      ))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xffF2F2F4),
                      // color: Colors.red,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: getTheRec(forAnswer, recId, reqId)
                        ? const Image(
                            image: AssetImage("assets/Settings/Req.png"),
                            width: 15,
                            height: 15,
                          )
                        : const Image(
                            image: AssetImage(
                              "assets/Settings/Rec.png",
                            ),
                            width: 15,
                            height: 15,
                          ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Color(0xff164866),
                    ),
                  ),
                ],
              ),
              Visibility(
                  visible: seen,
                  child: Container(
                    width: 57,
                    height: 30,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color(0xffF2F2F4),
                      // color: Colors.red,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Image(
                      image: AssetImage("assets/Settings/Seen.png"),
                      width: 20,
                      height: 20,
                    ),
                  ))
            ],
          ),
          Text(
            body,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Color(0xff164866),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (document["answer"] as String).isEmpty &&
                        document["requested_user_id"] as int != widget.userId
                    ? InkWell(
                        onTap: () {
                          MessageAnswerFactory.getMessage(
                              snapshot: snapshot,
                              key: key,
                              id: document["issued_user_id"] as int,
                              type: document["issue_type"] as String,
                              context: context,
                              number: document["car_number"],
                              onClose: () {
                                Navigator.pop(context);

                                snapshot.ref.update(
                                    {"$key/answer": "Չեմ կարող մոտենալ"});

                                Navigator.pop(context);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NotificationsPage(
                                            userId: widget.userId)));
                              },
                              onApprove: () {
                                Navigator.pop(context);

                                if (document["issue_type"] == "car_number") {
                                  String answer =
                                      "Խնդրում եմ զանգահարել 0${document["phoneNumber"]} հեռախոսահամարին";

                                  snapshot.ref.update({"$key/answer": answer});
                                } else {
                                  snapshot.ref.update(
                                      {"$key/answer": "Շուտով կմոտենամ"});
                                }
                                Navigator.pop(context);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NotificationsPage(
                                            userId: widget.userId)));
                              },
                              onNumberApprove: (String number) {
                                Navigator.pop(context);

                                if (document["issue_type"] == "car_number") {
                                  String answer =
                                      "Խնդրում եմ զանգահարել $number հեռախոսահամարին";

                                  snapshot.ref.update({"$key/answer": answer});
                                } else {
                                  snapshot.ref.update(
                                      {"$key/answer": "Շուտով կմոտենամ"});
                                }
                                Navigator.pop(context);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NotificationsPage(
                                            userId: widget.userId)));
                              },
                              phoneNumber: document["phoneNumber"]);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 150,
                              height: 35,
                              decoration: BoxDecoration(
                                  color: const Color(0xff00611E),
                                  borderRadius: BorderRadius.circular(25)),
                              alignment: Alignment.center,
                              child: const Text(
                                "Պատասխանել",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontSize: 14),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () {
                                // showReport(context, 1, "${prasedData.day.toString().padLeft(2, '0')}.${prasedData.month}.${prasedData.year} ${prasedData.hour.toString().padLeft(2, '0')}:${prasedData.minute.toString().padLeft(2, '0')}");
                                showReportDialog(context,
                                    document["requested_user_id"] as int);
                              },
                              child: const Image(
                                image:
                                    AssetImage("assets/Message/NotReport.png"),
                                width: 18,
                                height: 18,
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(),
                Text(
                  notificationDate,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Color(0xff164866),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

void showReport(BuildContext context, int requestId, String date) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color(0xffF2F2F4)),
                        child: const Image(
                          image: AssetImage("assets/Message/Person.png"),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Ուղարկողի ID $requestId",
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: Color(0xff164866)),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Text(
                      date,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Colors.transparent),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color(0xffF2F2F4)),
                        child: const Image(
                          image: AssetImage("assets/Message/Request.png"),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text(
                        "Ծանուցման ստացում",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: Color(0xff164866)),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Text(
                      date,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Color(0xff164866)),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color(0xffF2F2F4)),
                        child: const Image(
                          image: AssetImage("assets/Message/SeenReq.png"),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text(
                        "Ծանուցումը դիտվել է",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: Color(0xff164866)),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Text(
                      date,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Color(0xff164866)),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color(0xffF2F2F4)),
                        child: const Image(
                          image: AssetImage("assets/Message/AnswerData.png"),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text(
                        "Պատասխանվել է",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: Color(0xff164866)),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Text(
                      date,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Color(0xff164866)),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        );
      });
}
