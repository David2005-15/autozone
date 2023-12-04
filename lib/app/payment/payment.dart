import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class PaymentInfo extends StatefulWidget {
  final Map<dynamic, dynamic> items;
  final String date;
  final String name;
  final String autoMark;
  final String autoNumber;
  final String mijnordavchar;

  const PaymentInfo({
    required this.items,
    required this.date,
    required this.name,
    required this.autoMark,
    required this.autoNumber,
    required this.mijnordavchar,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _PaymentInfoState();
}

class _PaymentInfoState extends State<PaymentInfo> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.grey[100],
            height: 1.0,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 40,
        actions: <Widget>[
          InkWell(
            onTap: () {
              screenshotController.capture().then((image) async {
                if (image != null) {
                  final directory = await getApplicationDocumentsDirectory();
                  final imagePath =
                      await File('${directory.path}/image.png').create();
                  await imagePath.writeAsBytes(image);

                  /// Share Plugin
                  await Share.shareXFiles([XFile(imagePath.path)]);
                }
              });
            },
            child: const Image(
              image: AssetImage("assets/Settings/Share.png"),
              width: 22,
              height: 22,
            ),
          ),
          const SizedBox(
            width: 16,
          )
        ],
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
        title: const Text(
          "Վճարման անդորրագիր",
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Color(0xff164866)),
        ),
        iconTheme: const IconThemeData(color: Color(0xff164866)),
      ),
      backgroundColor: Colors.white,
      body: Screenshot(
        controller: screenshotController,
        child: Container(
          // padding: const EdgeInsets.only(left: 10, right: 10),
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              keyValuePair("Գործարք/ամսաթիվ", widget.date),
              keyValuePair("Սեփականատեր", widget.name),
              keyValuePair("Հաշվ․ համարանիշ", widget.autoNumber),
              keyValuePair(reformatText(widget.items["name"]),
                  "${widget.items["value"]} դր․"),
              keyValuePair("Միջնորդավճար", "300 դր․"),
              // for (int i = 0; i < widget.items.length; i++)
              //   keyValuePair(reformatText(widget.items[i]["name"]),
              //       "${widget.items[i]["value"]} դր․"),
              keyValuePair("Ընդամենը վճարվել է",
                  "${int.parse(widget.items["value"].toString()) + 300} դր․")
            ],
          ),
        ),
      ),
    );
  }

  Widget keyValuePair(String key, String value) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      height: 57,
      decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Color(0xffECECEC), width: 1))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            key,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: Color(0xff164866),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: Color(0xff164866),
            ),
          ),
        ],
      ),
    );
  }
}

String reformatText(String text) {
  if (text == "CO") {
    return "Բնապահպանական հարկ ( CO)";
  }

  return "Տեխզննում";
}

int getPaymentSum(List<dynamic> items) {
  int sum = 0;

  for (int i = 0; i < items.length; i++) {
    sum += int.parse(items[i]["value"]);
  }

  return sum;
}
